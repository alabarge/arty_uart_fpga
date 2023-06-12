/*-----------------------------------------------------------------------------

   1  ABSTRACT

   1.1 Module Type

      Fast Serial UART I/O Driver

   1.2 Functional Description

      The UART I/O Interface routines are contained in this module.

      Steps for adding this driver to the main application :

         1. Call uart_init() from main
         2. Call uart_revision() in cp_msg() version request
         3. Adjust the ADC sample rates per interface speed
         4. Call uart_pipe() from daq_hal_run()
         5. Change baudrate in fw_cfg.h, CFG_BAUD_RATE
         6. Set ADC_POOL_CNT for interface speed
         7. Disable ADC PKT and DONE interrupts

   1.3 Specification/Design Reference

      See fw_cfg.h under the share directory.

   1.4 Module Test Specification Reference

      None

   1.5 Compilation Information

      See fw_cfg.h under the share directory.

   1.6 Notes

      NONE

   2  CONTENTS

      1 ABSTRACT
        1.1 Module Type
        1.2 Functional Description
        1.3 Specification/Design Reference
        1.4 Module Test Specification Reference
        1.5 Compilation Information
        1.6 Notes

      2 CONTENTS

      3 VOCABULARY

      4 EXTERNAL RESOURCES
        4.1  Include Files
        4.2  External Data Structures
        4.3  External Function Prototypes

      5 LOCAL CONSTANTS AND MACROS

      6 MODULE DATA STRUCTURES
        6.1  Local Function Prototypes
        6.2  Local Data Structures

      7 MODULE CODE
         7.1   uart_init()
         7.2   uart_isr()
         7.3   uart_tx()
         7.4   uart_cmio()
         7.5   uart_msgtx()
         7.6   uart_pipe()
         7.7   uart_report()

-----------------------------------------------------------------------------*/

// 3 VOCABULARY

// 4 EXTERNAL RESOURCES

// 4.1  Include Files

#include "main.h"

// 4.2   External Data Structures

// 4.3 External Function Prototypes

// 5 LOCAL CONSTANTS AND MACROS

// 6 MODULE DATA STRUCTURES

// 6.1  Local Function Prototypes

// 6.2  Local Data Structures

   static   uint8_t        cm_port = CM_PORT_NONE;
   static   uint16_t       tx_head = 0;
   static   uint16_t       tx_msglen = 0;

   static   uart_txq_t     txq;
   static   uart_rxq_t     rxq;

   static   uint8_t        msg_out[sizeof(cm_pipe_t)];

   static   volatile puart_regs_t regs = (volatile puart_regs_t)XPAR_AXI_CM_UART_BASEADDR;

// 7 MODULE CODE

// ===========================================================================

// 7.1

uint32_t uart_init(uint32_t baudrate, uint8_t port) {

/* 7.1.1   Functional Description

   The UART Interface is initialized in this routine.

   7.1.2   Parameters:

   baudrate Serial Baud Rate
   port     UART Port

   7.1.3   Return Values:

   result   CFG_ERROR_OK

-----------------------------------------------------------------------------
*/

// 7.1.4   Data Structures

   uint32_t    result = CFG_ERROR_OK;
   uint32_t    j;

   uart_ctl_reg_t  ctl = {0};

// 7.1.5   Code

   // reset uart
   regs->control  = 0;
   ctl.b.enable   = 1;
   regs->control  = ctl.i;

   // set baudrate
   regs->ticks = (uint16_t)((XPAR_CPU_CORE_CLOCK_FREQ_HZ / baudrate) + 0.5);

   // clear the hardware tx buffer, rx is read-only
   // access is 32-Bit address with 8-Bit data
   for (j=0;j<UART_TX_BUF_LEN;j++) {
      regs->rtx_buf[j] = 0;
   }

   // initialize the rx queue
   memset(&rxq, 0, sizeof(uart_rxq_t));
   rxq.state  = UART_RX_IDLE;
   rxq.count  = 0;
   rxq.slotid = 0;
   rxq.slot   = NULL;
   rxq.msg    = NULL;

   // initialize the tx queue
   memset(&txq, 0, sizeof(uart_txq_t));
   for (j=0;j<UART_TX_QUE;j++) {
      txq.buf[j] = NULL;
   }
   txq.state  = UART_TX_IDLE;
   txq.head   = 0;
   txq.tail   = 0;
   txq.slots  = UART_TX_QUE;

   XIntc_Connect(&gc.intc, XPAR_AXI_INTC_AXI_CM_UART_IRQ_INTR,
      (XInterruptHandler)uart_isr, NULL);

   // register the I/O interface callback for CM
   cm_ioreg(uart_cmio, port, CM_MEDIA_UART);

   // update CM port
   cm_port = port;

   // enable rx interrupt, every character
   ctl.b.rx_int   = 1;
   ctl.b.char_cnt = 1;
   regs->control  = ctl.i;

   // enable uart in intc
   XIntc_Enable(&gc.intc, XPAR_AXI_INTC_AXI_CM_UART_IRQ_INTR);

   // report H/W details
   if (gc.trace & CFG_TRACE_ID) {
      xlprint("%-16s base:rev:irq %08X:%d:%d\n", "uart", XPAR_AXI_CM_UART_BASEADDR, 0,
    		  XPAR_AXI_INTC_AXI_CM_UART_IRQ_INTR);
      xlprint("%-16s rate:   %d.%d Kbps\n", "uart", baudrate / 1000, baudrate % 1000);
      xlprint("%-16s port:   %d\n", "uart", cm_port);
   }

   return result;

}  // end uart_init()


// ===========================================================================

// 7.2

void uart_isr(void *arg) {

/* 7.2.1   Functional Description

   This routine will service the UART Interrupt.

   7.2.2   Parameters:

   arg     IRQ arguments

   7.2.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.2.4   Data Structures

   uint8_t     c;

   uart_ptr_ctl_reg_t ptr_ctl;

// 7.2.5   Code

   // report interrupt request
   if (gc.trace & CFG_TRACE_IRQ) {
      xlprint("uart_isr() irq = %02X\n", regs->irq);
   }

   //
   // RX INTERRUPT, WHILE HEAD != TAIL
   //
   ptr_ctl.i = regs->ptr_ctl;
   while (regs->ptr_sta.b.rx_head != rxq.tail) {
      // clear interrupts
      regs->irq = regs->irq;
      // always read the rx buffer, 8-Bits
      c = regs->rtx_buf[rxq.tail];
      if (++rxq.tail == UART_RX_BUF_LEN) rxq.tail = 0;
      // update hardware
      ptr_ctl.b.rx_tail = rxq.tail;
      regs->ptr_ctl = ptr_ctl.i;
      // handle restart outside of switch
      if (c == UART_START_FRAME) {
          rxq.state = UART_RX_IDLE;
          if (rxq.slot != NULL) {
              cm_free((pcm_msg_t)rxq.slot->buf);
              rxq.slot = NULL;
          }
      }
      switch (rxq.state) {
         case UART_RX_IDLE :
            // all messages begin with UART_START_FRAME
            // drop all characters until start-of-frame
            if (c == UART_START_FRAME) {
               // allocate slot from cmq
               rxq.slot = cm_alloc();
               if (rxq.slot != NULL) {
                  rxq.msg = (pcm_msg_t)rxq.slot->buf;
                  // preserve q slot id
                  rxq.slotid = rxq.msg->h.slot;
                  rxq.count  = 0;
                  rxq.state  = UART_RX_MSG;
               }
               else {
                  // no room at the inn, drop the entire message
                  rxq.state  = UART_RX_IDLE;
                  rxq.count  = 0;
               }
            }
            break;
         case UART_RX_MSG :
            // unstuff next octet
            if (c == UART_ESCAPE) {
               rxq.state = UART_RX_ESCAPE;
            }
            // end-of-frame
            else if (c == UART_END_FRAME) {
               // restore q slot id
               rxq.msg->h.slot = rxq.slotid;
               rxq.slot->msglen = rxq.msg->h.msglen;
               cm_qmsg(rxq.msg);
               rxq.state = UART_RX_IDLE;
               rxq.slot  = NULL;
            }
            else {
               // store message octet
               rxq.slot->buf[rxq.count++] = c;
            }
            break;
         case UART_RX_ESCAPE :
            // unstuff octet
            rxq.slot->buf[rxq.count++] = c ^ UART_STUFFED_BIT;
            rxq.state = UART_RX_MSG;
            break;
      }
   }

} // end uart_isr()

// ===========================================================================

// 7.4

void uart_tx(void) {

/* 7.4.1   Functional Description

   This routine will transmit the message.

   7.4.2   Parameters:

   NONE

   7.4.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.4.4   Data Structures

   uart_ptr_ctl_reg_t ptr_ctl;

// 7.4.5   Code

   if ((((tx_head + 1) & (UART_TX_BUF_LEN - 1)) != regs->ptr_sta.b.tx_tail) &&
         (regs->status.b.tx_rdy == 1)) {
      switch (txq.state) {
         case UART_TX_IDLE :
            txq.state   = UART_TX_MSG;
            txq.n       = 0;
            regs->rtx_buf[tx_head] = msg_out[txq.n++];
            if (++tx_head == UART_TX_BUF_LEN) tx_head = 0;
            // update hardware, RMW
            ptr_ctl.i = regs->ptr_ctl;
            ptr_ctl.b.tx_head = tx_head;
            regs->ptr_ctl = ptr_ctl.i;
            // show activity
            gpio_set_val(GPIO_LED_COM, GPIO_LED_ON);
            // report message content
            if (gc.trace & CFG_TRACE_UART) {
               xlprint("uart_tx() msglen = %d\n", tx_msglen);
               dump(msg_out, tx_msglen, 0, 0);
            }
            break;
         case UART_TX_MSG :
            if (txq.n == tx_msglen) {
               txq.state   = UART_TX_IDLE;
            }
            else {
               regs->rtx_buf[tx_head] = msg_out[txq.n++];
               if (++tx_head == UART_TX_BUF_LEN) tx_head = 0;
               // update hardware, RMW
               ptr_ctl.i = regs->ptr_ctl;
               ptr_ctl.b.tx_head = tx_head;
               regs->ptr_ctl = ptr_ctl.i;
            }
            break;
      }
   }

} // end uart_tx()


// ===========================================================================

// 7.5

void uart_cmio(uint8_t op_code, pcm_msg_t msg) {

/* 7.5.1   Functional Description

   OPCODES

   CM_IO_TX : The transmit queue index will be incremented,
   this causes the top of the queue to be transmitted.

   7.5.2   Parameters:

   msg     Message Pointer
   opCode  CM_IO_TX

   7.5.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.5.4   Data Structures

// 7.5.5   Code

   if (gc.trace & CFG_TRACE_UART) {
      xlprint("uart_cmio() op_code:msg = %02X:%08X\n", op_code, (uint32_t)msg);
   }

   // Disable ISR
   XIntc_Disable(&gc.intc, XPAR_AXI_INTC_AXI_CM_UART_IRQ_INTR);

   // place in transmit queue
   txq.buf[txq.head] = (uint8_t *)msg;
   txq.len[txq.head] = msg->h.msglen;
   if (++txq.head == txq.slots) txq.head = 0;

   // try to transmit message
   uart_msgtx();

   // Enable ISR
   XIntc_Enable(&gc.intc, XPAR_AXI_INTC_AXI_CM_UART_IRQ_INTR);

} // end uart_cmio()


// ===========================================================================

// 7.6

void uart_msgtx(void) {

/* 7.6.1   Functional Description

   This routine will check for outgoing messages and route them to the
   transmitter uart_tx(). HDLC-like octet stuffing.

   7.6.2   Parameters:

   NONE

   7.6.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.6.4   Data Structures

   pcm_msg_t   msg;

   uint32_t    i,j;

// 7.6.5   Code

   // check for active message transmit
   if (txq.state != UART_TX_IDLE) {
      uart_tx();
   }
   // check for message in queue
   else if (txq.head != txq.tail) {
      msg = (pcm_msg_t)txq.buf[txq.tail];
      // clear outbound message buffer
      memset(msg_out, 0, sizeof(msg_out));
      //
      // cm message
      //
      if (msg->h.dst_cmid != CM_ID_PIPE) {
         // start-of-frame
         msg_out[0] = UART_START_FRAME;
         // octet stuffing for transmit
         for (i=0,j=1;i<msg->h.msglen;i++) {
            // check for control characters
            if ((txq.buf[txq.tail][i] == UART_START_FRAME) ||
                (txq.buf[txq.tail][i] == UART_END_FRAME)   ||
                (txq.buf[txq.tail][i] == UART_ESCAPE)) {
               msg_out[j++] = txq.buf[txq.tail][i] ^ UART_STUFFED_BIT;
            }
            // all others
            msg_out[j++] = txq.buf[txq.tail][i];
         }
         // end-of-frame
         msg_out[j++] = UART_END_FRAME;
         tx_msglen = j;
         uart_tx();
      }
      //
      // pipe message
      //
      else {
         for (i=0;i<sizeof(cm_pipe_t);i++) {
            msg_out[i] = txq.buf[txq.tail][i];
         }
         tx_msglen = sizeof(cm_pipe_t);
         uart_tx();
      }
      // release message
      cm_free((pcm_msg_t)txq.buf[txq.tail]);
      // clear the msg pointer
      txq.buf[txq.tail] = NULL;
      txq.len[txq.tail] = 0;
      // advance the tx queue
      if (++txq.tail == txq.slots) txq.tail = 0;
   }

} // end uart_msgtx()


// ===========================================================================

// 7.7

void uart_pipe(uint32_t index, uint32_t msglen) {

/* 7.7.1   Functional Description

   This routine will queue a pipe message for transmit.

   7.7.2   Parameters:

   index   Index into DMA mapped memory
   msglen  Message length in bytes

   7.7.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.7.4   Data Structures

   uint8_t *msg = NULL;

// 7.7.5   Code

   // Trace Entry
   if (gc.trace & CFG_TRACE_PIPE) {
      xlprint("uart_pipe() msg:msglen = %08X:%d\n", (uint8_t *)msg, msglen);
      dump((uint8_t *)msg, 32, 0, 0);
   }

   // Disable ISR
   XIntc_Disable(&gc.intc, XPAR_AXI_INTC_AXI_CM_UART_IRQ_INTR);

   // Validate message, drop if NULL
   if (msg != NULL) {
      // place in transmit queue
      txq.buf[txq.head] = (uint8_t *)msg;
      txq.len[txq.head] = msglen;
      if (++txq.head == txq.slots) txq.head = 0;
      // try to transmit message
      uart_msgtx();
      // show activity
      gpio_set_val(GPIO_LED_PIPE, GPIO_LED_ON);
   }

   // Enable ISR
   XIntc_Enable(&gc.intc, XPAR_AXI_INTC_AXI_CM_UART_IRQ_INTR);

} // end uart_pipe()


// ===========================================================================

// 7.7

void uart_report(void) {

/* 7.7.1   Functional Description

   This routine will report the txq and rxq state.

   7.7.2   Parameters:

   NONE

   7.7.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.7.4   Data Structures

// 7.7.5   Code

   // txq
   xlprint("\n");
   xlprint("txq.state  : %d\n", txq.state);
   xlprint("txq.head   : %d\n", txq.head);
   xlprint("txq.tail   : %d\n", txq.tail);
   xlprint("txq.buf[]  : %08X\n", txq.buf[txq.head]);
   xlprint("txq.slots  : %d\n", txq.slots);
   xlprint("txq.len[]  : %d\n", txq.len[txq.head]);
   xlprint("txq.n      : %d\n", txq.n);

   // rxq
   xlprint("\n");
   xlprint("rxq.state  : %d\n", rxq.state);
   xlprint("rxq.count  : %d\n", rxq.count);
   xlprint("rxq.slotid : %d\n", rxq.slotid);
   xlprint("rxq.tail   : %d\n", rxq.tail);
   xlprint("rxq.slot   : %d\n", rxq.slot);
   xlprint("rxq.msg    : %08X\n\n", rxq.msg);

   // regs
   xlprint("\n");
   xlprint("regs->control  : %08X\n", regs->control);
   xlprint("regs->status   : %08X\n", regs->status);
   xlprint("regs->verion   : %02X\n", regs->version);
   xlprint("regs->irq      : %02X\n", regs->irq);
   xlprint("regs->ticks    : %04X\n", regs->ticks);
   xlprint("regs->ptr_sta  : %08X\n", regs->ptr_sta.i);
   xlprint("regs->ptr_ctl  : %08X\n", regs->ptr_ctl);


} // end uart_report()
