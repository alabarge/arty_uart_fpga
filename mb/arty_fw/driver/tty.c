/*-----------------------------------------------------------------------------

   1  ABSTRACT

   1.1 Module Type

      Fast Serial TTY I/O Driver

   1.2 Functional Description

      The TTY I/O Interface routines are contained in this module.

      Steps for adding this driver to the main application :

         1. Call tty_init() from main
         2. Call tty_revision() in cp_msg() version request
         3. Adjust the ADC sample rates per interface speed
         4. Call tty_pipe() from daq_hal_run()
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
         7.1   tty_init()
         7.2   tty_isr()
         7.3   tty_tx()
         7.4   tty_cmio()
         7.5   tty_msgtx()
         7.6   tty_pipe()

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

   static   tty_txq_t      txq;
   static   tty_rxq_t      rxq;

   static   volatile ptty_regs_t   tty = (volatile ptty_regs_t)XPAR_AXI_CM_UART_BASEADDR;

// 7 MODULE CODE

// ===========================================================================

// 7.1

uint32_t tty_init(uint32_t baudrate, uint8_t port) {

/* 7.1.1   Functional Description

   The TTY Interface is initialized in this routine.

   7.1.2   Parameters:

   baudrate Serial Baud Rate
   port     TTY Port

   7.1.3   Return Values:

   result   CFG_ERROR_OK

-----------------------------------------------------------------------------
*/

// 7.1.4   Data Structures

   uint32_t    result = CFG_ERROR_OK;
   uint32_t    j;

// 7.1.5   Code

   // clear FIFOs
   tty->control = UART_RST_TX_FIFO | UART_RST_RX_FIFO;

   // Initialize the TX Queue
   memset(&txq, 0, sizeof(tty_txq_t));
   for (j=0;j<TTY_TX_QUE;j++) {
      txq.buf[j] = NULL;
      txq.len[j] = 0;
   }
   txq.slots = TTY_TX_QUE;
   txq.state = TTY_IDLE;
   txq.n     = 0;
   txq.head  = 0;
   txq.tail  = 0;

   // Initialize the RX Queue
   memset(&rxq, 0, sizeof(tty_rxq_t));
   rxq.buf     = (uint8_t *)rxq.raw;
   rxq.n       = 0;
   rxq.state   = TTY_IDLE;

   XIntc_Connect(&gc.intc, XPAR_INTC_0_UARTLITE_0_VEC_ID,
      (XInterruptHandler)tty_isr, NULL);

   // Register the I/O Interface callback for CM
   cm_ioreg(tty_cmio, port, CM_MEDIA_TTY);

   // Update CM Port
   cm_port = port;

   // enable uart interrupts
   tty->control = UART_INT_EN;

   // enable uart in intc
   XIntc_Enable(&gc.intc, XPAR_INTC_0_UARTLITE_0_VEC_ID);

   // Report H/W Details
   if (gc.trace & CFG_TRACE_ID) {
      xlprint("%-16s base:rev:irq %08X:%d:%d\n", "tty", XPAR_AXI_CM_UART_BASEADDR, 0,
         XPAR_INTC_0_UARTLITE_1_VEC_ID);
      xlprint("%-16s rate:   %d.%d Kbps\n", "tty", baudrate / 1000, baudrate % 1000);
      xlprint("%-16s port:   %d\n", "tty", cm_port);
   }

   return result;

}  // end tty_init()


// ===========================================================================

// 7.2

void tty_isr(void *arg) {

/* 7.2.1   Functional Description

   This routine will service the TTY Interrupt.

   7.2.2   Parameters:

   arg     IRQ arguments

   7.2.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.2.4   Data Structures

   uint32_t    i;
   uint8_t     ch;
   uint8_t     slotid = 0;
   pcmq_t      slot   = NULL;

   volatile pcm_msg_t  msg;

// 7.2.5   Code

   // report interrupt request
   if (gc.trace & CFG_TRACE_IRQ) {
      xlprint("tty_isr() irq = %02X\n", tty->status);
   }

   //
   // RX INTERRUPT, PER FIFO VALID
   //
   while (tty->status & UART_RX_VALID) {
      // reading clears interrupt
      ch = tty->rx_dat;
      switch (rxq.state) {
         case TTY_IDLE :
            if (ch == TTY_SOF) {
               rxq.state = TTY_IN_MSG;
               rxq.n     = 0;
               memset(rxq.buf, 0, TTY_MSGLEN_UINT8);
            }
            break;
         case TTY_IN_MSG :
            // end-of-frame, copy message and que
            if (ch == TTY_EOF) {
               rxq.state = TTY_IDLE;
               // allocate slot from cmq
               slot = cm_alloc();
               if (slot != NULL) {
                  msg = (volatile pcm_msg_t)slot->buf;
                  // preserve q slot id
                  slotid = msg->h.slot;
                  // copy message from rxq
                  for (i=0;i<(rxq.n + 3) >> 2;i++) {
                     slot->buf[i] = rxq.raw[i];
                  }
                  // restore q slot id
                  msg->h.slot = slotid;
                  // queue the message
                  cm_qmsg(msg);
                  slot = NULL;
                  // show activity
                  gpio_set_val(GPIO_LED_COM, GPIO_LED_ON);
                  // report message content
                  if ((gc.trace & CFG_TRACE_UART)) {
                     xlprint("tty_isr() msglen:slotid = %d:%d\n", msg->h.msglen, msg->h.slot);
                     dump((uint8_t *)msg, msg->h.msglen, 0, 0);
                  }
               }
            }
            // unstuff the next incoming character
            else if (ch == TTY_ESC) {
               rxq.state = TTY_IN_ESC;
            }
            // store incoming character
            else {
               rxq.state = TTY_IN_MSG;
               rxq.buf[rxq.n] = ch;
               if (++rxq.n == TTY_MSGLEN_UINT8) rxq.n = 0;
            }
            break;
         // unstuff this character
         case TTY_IN_ESC :
            rxq.state = TTY_IN_MSG;
            rxq.buf[rxq.n] = ch ^ TTY_BIT;
            if (++rxq.n == TTY_MSGLEN_UINT8) rxq.n = 0;
            break;
      }
   }

} // end tty_isr()

// ===========================================================================

// 7.4

void tty_tx(void) {

/* 7.4.1   Functional Description

   This routine will transmit the message.

   7.4.2   Parameters:

   msg     Message to send.

   7.4.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.4.4   Data Structures

   uint8_t   *out = (uint8_t *)txq.buf[txq.tail];
   pcm_msg_t  msg = (pcm_msg_t)txq.buf[txq.tail];

// 7.4.5   Code

   // Disable ISR
   XIntc_Disable(&gc.intc, XPAR_INTC_0_UARTLITE_1_VEC_ID);

   // Trace Entry
   if (gc.trace & CFG_TRACE_UART) {
      xlprint("tty_tx() srvid:msgid:msglen:msg = %02X:%02X:%d:%08X\n",
               msg->p.srvid, msg->p.msgid, msg->h.msglen, (uint32_t)msg);
      dump((uint8_t *)msg, msg->h.msglen, 0, 0);
   }

   // Validate message, drop if NULL
   if (txq.buf[txq.tail] == NULL) {
      // advance the tx queue
      if (++txq.tail == txq.slots) txq.tail = 0;
   }
   // check for transmit ready
   else if ((tty->status & UART_TX_FULL) == 0) {
      switch (txq.state) {
         case TTY_IDLE :
            txq.state   = TTY_IN_MSG;
            tty->tx_dat = TTY_SOF;
            txq.n       = 0;
            // show activity
            gpio_set_val(GPIO_LED_COM, GPIO_LED_ON);
            // report message content
            if (gc.trace & CFG_TRACE_UART) {
               xlprint("tty_tx() msglen = %d\n", txq.len[txq.tail]);
               dump((uint8_t *)txq.buf[txq.tail], txq.len[txq.tail], 0, 0);
            }
            break;
         case TTY_IN_MSG :
            if (txq.n == txq.len[txq.tail]) {
               txq.state   = TTY_IDLE;
               tty->tx_dat = TTY_EOF;
               // release message
               cm_free((pcm_msg_t)txq.buf[txq.tail]);
               // clear the msg pointer
               txq.buf[txq.tail] = NULL;
               txq.len[txq.tail] = 0;
               // advance the tx queue
               if (++txq.tail == txq.slots) txq.tail = 0;
            }
            // escape the character
            else if ((out[txq.n] == TTY_SOF)  ||
                     (out[txq.n] == TTY_EOF)  ||
                     (out[txq.n] == TTY_ESC)) {
               txq.state   = TTY_IN_ESC;
               tty->tx_dat = TTY_ESC;
            }
            // send regular character
            else {
               txq.state = TTY_IN_MSG;
               tty->tx_dat = out[txq.n];
               txq.n++;
            }
            break;
         // send character after escape
         case TTY_IN_ESC :
            txq.state = TTY_IN_MSG;
            tty->tx_dat = out[txq.n] ^ TTY_BIT;
            txq.n++;
            break;
      }
   }

   // Enable ISR
   XIntc_Enable(&gc.intc, XPAR_INTC_0_UARTLITE_1_VEC_ID);

} // end tty_tx()


// ===========================================================================

// 7.5

void tty_cmio(uint8_t op_code, pcm_msg_t msg) {

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
      xlprint("tty_cmio() op_code:msg = %02X:%08X\n", op_code, (uint32_t)msg);
   }

   // place in transmit queue
   txq.buf[txq.head] = (uint32_t *)msg;
   txq.len[txq.head] = msg->h.msglen;
   if (++txq.head == txq.slots) txq.head = 0;

   // try to transmit message
   tty_msgtx();

} // end tty_cmio()


// ===========================================================================

// 7.6

void tty_msgtx(void) {

/* 7.6.1   Functional Description

   This routine will check for outgoing messages and route them to the
   transmitter ttyTx().

   7.6.2   Parameters:

   NONE

   7.6.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.6.4   Data Structures

// 7.6.5   Code

   // Check for message in Queue
   if (txq.head != txq.tail) tty_tx();

} // end tty_msgtx()


// ===========================================================================

// 7.7

void tty_pipe(uint32_t index, uint32_t msglen) {

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
      xlprint("tty_pipe() msg:msglen = %08X:%d\n", (uint8_t *)msg, msglen);
      dump((uint8_t *)msg, 32, 0, 0);
   }

   // Validate message, drop if NULL
   if (msg != NULL) {
      // place in transmit queue
      txq.buf[txq.head] = (uint32_t *)msg;
      txq.len[txq.head] = msglen;
      if (++txq.head == txq.slots) txq.head = 0;
      // try to transmit message
      tty_msgtx();
      // show activity
      gpio_set_val(GPIO_LED_PIPE, GPIO_LED_ON);
   }

} // end tty_pipe()
