/*-----------------------------------------------------------------------------

   1  ABSTRACT

   1.1 Module Type

      Fast Serial COM I/O Driver

   1.2 Functional Description

      The COM I/O Interface routines are contained in this module.

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
         7.1   com_init()
         7.2   com_thread()
         7.3   com_tx()
         7.4   com_cmio()
         7.5   com_head()
         7.6   com_final()

-----------------------------------------------------------------------------*/

// 3 VOCABULARY

// 4 EXTERNAL RESOURCES

// 4.1  Include Files

#include "main.h"
#include "wsc.h"
#include "keycode.h"

// 4.2   External Data Structures

// 4.3 External Function Prototypes

// 5 LOCAL CONSTANTS AND MACROS

   #define COM_RESP          64
   #define COM_RETRIES       4

// 6 MODULE DATA STRUCTURES

// 6.1  Local Function Prototypes

   static   DWORD WINAPI      com_thread(LPVOID data);

// 6.2  Local Data Structures

   static   uint8_t           m_cm_port  = CM_PORT_NONE;

   static   CRITICAL_SECTION  m_tx_mutex;
   static   HANDLE            m_thread;
   static   DWORD             m_tid;

   static   uint8_t          *m_pool = NULL;
   static   uint8_t          *m_nxt_pipe = NULL;
   static   uint8_t          *m_blk_pipe = NULL;
   static   uint8_t           m_end_thread = FALSE;
   static   uint32_t          m_pktcnt = 0;
   static   uint32_t          m_head = 0;

   static   uint32_t          m_sysid, m_stamp, m_cmdat;
   static   uint8_t           m_devid, m_numobjs, m_numcons;
   static   int32_t           m_librev, m_sysrev;

   static   int32_t           m_com = -1;

   static   UCHAR             m_query[] = {0x7E, 0x83, 0x83, 0x10, 0x10, 0x00, 0x00,
                                           0x0C, 0x20, 0x83, 0x09, 0x00, 0x00, 0x7D};

// 7 MODULE CODE

// ===========================================================================

// 7.1

uint32_t com_init(uint32_t baudrate, uint8_t cm_port, uint8_t com_port) {

/* 7.1.1   Functional Description

   The COM Interface is initialized in this routine.

   7.1.2   Parameters:

   baudrate  Serial Baud Rate
   cm_port   CM Port
   com_port  FTDI COM Port from FT_GetDeviceInfoList()

   7.1.3   Return Values:

   result   CFG_ERROR_OK

-----------------------------------------------------------------------------
*/

// 7.1.4   Data Structures

   uint32_t    result = COM_OK;
   int32_t     status;
   int32_t     sent, recv;
   UCHAR       resp[COM_RESP], msg[COM_RESP];
   uint8_t     retry = 0;
   int32_t     i,k;

// 7.1.5   Code

   // Update COM Port
   m_com = com_port -1;

   // Issue Serial I/O Driver Keycode
   status = SioKeyCode(WSC_KEY_CODE);
   if (status < 0)    result |= COM_ERR_KEYCODE;
   if (status != 999) result |= COM_ERR_KEYCODE;

   if (result == COM_OK) {
      printf("\ncom_init() selected port = %d\n", com_port);
      // Overlapped I/O
      status  = SioSetInteger(-1, 'O', 1);

      // Reset Serial I/O Port
      status  = SioReset(m_com, COM_RX_Q_SIZE, COM_TX_Q_SIZE);

      // If Open already then close the port
      if (status == WSC_IE_OPEN) SioDone(m_com);

      // Purge Queues
      SioRxClear(m_com);
      SioTxClear(m_com);

      // Serial I/O Port Baudrate
      status |= SioBaud(m_com, baudrate);

      // Serial I/O Port Parameters
      status |= SioParms(m_com, WSC_NoParity, WSC_TwoStopBits, WSC_WordLength8);

      // Set DTR and RTS
      status |= SioDTR(m_com, 'S');
      status |= SioRTS(m_com, 'S');

      // Check return status from COM
      if (status < 0) result |= COM_ERR_OPEN;
   }

   // Device Opened
   if (result == COM_OK && m_com != -1) {

      // Purge Queues
      SioRxClear(m_com);
      SioTxClear(m_com);

      while (retry < COM_RETRIES) {

         result |= COM_ERR_RESP;

         // Send CM_QUERY_REQ to validate connection
         cm_crc((pcm_msg_t)&m_query[1], CM_CALC_CRC);
         sent = SioPuts(m_com, (CHAR *)m_query, sizeof(m_query));
         // report message content
         if ((gc.trace & WIN_TRACE_UART)) {
            printf("com_init() tx msglen = %d\n", (int)sizeof(m_query));
            dump((uint8_t *)m_query, sizeof(m_query), 0, 0);
         }

         // If sent OK then check response
         if (sent == sizeof(m_query)) {
            // Allow time for Response
            Sleep(100);
            // Read the Port
            recv = SioGets(m_com, (CHAR *)resp, sizeof(resp));
            // report message content
            if ((gc.trace & WIN_TRACE_UART)) {
               printf("com_init() rx msglen = %d\n", recv);
               dump((uint8_t *)resp, recv, 0, 0);
            }
            // Check Response
            if (recv != 0) {
               // Check SOF & EOF
               if (resp[0] == COM_SOF && resp[recv-1] == COM_EOF) {
                  // Remove HDLC Coding
                  for (i=1,k=0;i<(recv-1);i++) {
                     if (resp[i] == COM_ESC) {
                        msg[k++] = resp[i+1] ^ COM_BIT;
                        i++;
                     }
                     else {
                        msg[k++] = resp[i];
                     }
                  }
                  // Verify Magic Number
                  if (msg[12] == 0x34 && msg[13] == 0x12 &&
                      msg[14] == 0xAA && msg[15] == 0x55) {
                     // Purge Queues
                     SioRxClear(m_com);
                     SioTxClear(m_com);
                     // Record SysID
                     m_sysid = (msg[19] << 24) | (msg[18] << 16) | (msg[17] << 8) | msg[16];
                     // Record Timestamp
                     m_stamp = (msg[23] << 24) | (msg[22] << 16) | (msg[21] << 8) | msg[20];
                     // Record Device ID, etc.
                     m_devid    = msg[24];
                     m_numobjs  = msg[25];
                     m_numcons  = msg[26];
                     m_cmdat    = (m_devid << 24) | (m_numobjs << 16) | (m_numcons << 8);
                     result = COM_OK;
                     break;
                  }
               }
            }
         }
         retry++;
      }
   }

   // OK to Continue
   if (result == COM_OK && m_com != -1) {

      // Serial I/O Version and Build
      m_librev = SioInfo('V');
      m_sysrev = SioInfo('B');

      // Init the Mutex's
      InitializeCriticalSection (&m_tx_mutex);

      // Update CM Port
      m_cm_port = cm_port;

      // Register the I/O Interface callback for CM
      cm_ioreg(com_cmio, m_cm_port, CM_MEDIA_COM);

      // Allocate Pipe Message Pool
      m_pool  = malloc(COM_PIPE_SLOTS * COM_PIPELEN_UINT8);

      if (m_pool == NULL) {
         result = COM_ERR_POOL;
      }

      // Start the H/W Receive Thread
      m_end_thread = FALSE;
      if ((m_thread = CreateThread(NULL, 0, com_thread, NULL, 0, &m_tid)) == NULL) {
         result = CFG_ERROR_COM;
      }
      else {
         SetThreadPriority(&m_tid, THREAD_PRIORITY_NORMAL);
      }

       // Print Hardware Version to Serial Port
      if (gc.trace & WIN_TRACE_ID) {
         printf("Opened COM.%d for Messaging\n", com_port);
         printf("COM.%d : wsc64.lib = %08X\n", com_port, m_librev);
         printf("COM.%d : sysid:stamp:cm = %d:%d:%08X\n\n", com_port, m_sysid, m_stamp, m_cmdat);
      }
   }

   if ((gc.trace & WIN_TRACE_ERROR) && result != COM_OK) {
      printf("com_init() Error : %08X\n", result);
   }

   return (result == COM_OK) ? WIN_ERROR_OK : WIN_ERROR_COM;

}  // end com_init()


// ===========================================================================

// 7.2

static DWORD WINAPI com_thread(LPVOID data) {


/* 7.2.1   Functional Description

   This thread will service the incoming characters from the COM serial
   interface.

   7.2.2   Parameters:

   data     Thread parameters

   7.2.3   Return Values:

   return   Thread exit status

-----------------------------------------------------------------------------
*/

// 7.2.4   Data Structures

   int32_t     rx_bytes, i, j, k;
   uint8_t     raw[COM_PIPELEN_UINT8 * 2];
   uint32_t    buf[COM_PIPELEN_UINT8 >> 2];
   uint8_t     *buf_u8 = (uint8_t *)buf;
   uint8_t     esc = 0, newmsg = 0;
   int32_t     status;
   uint8_t     type = COM_EPID_NONE;
   uint8_t     slotid;
   uint32_t    head = 0;
   pcmq_t      slot;
   pcm_msg_t   msg;

   pcm_pipe_daq_t  pipe;

// 7.2.5   Code

   if (gc.trace & WIN_TRACE_ID) {
      printf("com_thread() started, tid 0x%X\n", m_tid);
   }

   // Purge Queues
   SioRxClear(m_com);
   SioTxClear(m_com);

   // beginning of PIPE message circular buffer
   m_nxt_pipe  = m_pool;
   m_blk_pipe  = m_pool;
   m_head      = 0;

   // clear staging buffer
   memset(buf, 0, sizeof(buf));

   while (m_end_thread == FALSE) {
      rx_bytes = SioRxQue(m_com);
      if (rx_bytes == 0)
         status = SioEventWait(m_com, EV_RXCHAR, COM_THREAD_TIMEOUT);
      rx_bytes = SioRxQue(m_com);
      // timeout
      if (status == WSC_IO_PENDING && rx_bytes == 0) continue;
      // event error
      if (status == WSC_IO_ERROR) {
         m_end_thread = TRUE;
         continue;
      }
      if (rx_bytes != 0 && m_end_thread == FALSE) {
         // prevent buffer overflow, account for encoding
         rx_bytes = (rx_bytes > (COM_PIPELEN_UINT8 * 2)) ? COM_PIPELEN_UINT8 * 2 : rx_bytes;
         memset(raw, 0, sizeof(raw));
         rx_bytes = SioGets(m_com, (CHAR *)raw, rx_bytes);
         if ((rx_bytes > 0) && (m_end_thread != TRUE)) {
            for (i=0;i<rx_bytes;i++) {
               //
               // HDLC END-OF-FILE
               //
               if (raw[i] == COM_EOF && newmsg == 1) {
                  //
                  // CONTROL MESSAGE
                  //
                  if (type == COM_EPID_CTL) {
                     slot = cm_alloc();
                     if (slot != NULL) {
                        msg = (pcm_msg_t)slot->buf;
                        // preserve slotid
                        slotid = msg->h.slot;
                        // uint32_t boundary, copy multiple of 32-bits
                        // always read CM header + parms in order
                        // to determine message length
                        for (j=0;j<sizeof(cm_msg_t) >> 2;j++) {
                           slot->buf[j] = buf[j];
                        }
                        slot->msglen = msg->h.msglen;
                        // read rest of CM message body, uint32_t per cycle
                        if (slot->msglen > sizeof(cm_msg_t) && (slot->msglen <= COM_MSGLEN_UINT8)) {
                           for (j=0;j<(slot->msglen + 3 - sizeof(cm_msg_t)) >> 2;j++) {
                              slot->buf[j + (sizeof(cm_msg_t) >> 2)] =
                                    buf[j + (sizeof(cm_msg_t) >> 2)];
                           }
                        }
                        // restore slotid
                        msg->h.slot = slotid;
                        // clear staging buffer
                        memset(buf, 0, sizeof(buf));
                        // validate message length
                        if (msg->h.msglen >= sizeof(cm_msg_t) &&
                            msg->h.msglen <= CM_MAX_MSG_INT8U) {
                           // report message content
                           if ((gc.trace & WIN_TRACE_UART) && (slot != NULL)) {
                              printf("com_thread() msglen = %d\n", msg->h.msglen);
                              dump((uint8_t *)slot->buf, slot->msglen, LIB_ASCII, 0);
                           }
                           // queue the message
                           cm_qmsg((pcm_msg_t)slot->buf);
                        }
                     }
                  }
                  //
                  // PIPE MESSAGE
                  //
                  else if (type == COM_EPID_PIPE) {
                     pipe = (pcm_pipe_daq_t)m_nxt_pipe;
                     // packet arrival
                     pipe->stamp_us = (uint32_t)tmr_get_elapsed_microseconds();
                     // next slot in circular buffer
                     if (++m_head == COM_PIPE_SLOTS) m_head = 0;
                     m_nxt_pipe = m_pool + (m_head * COM_PIPELEN_UINT8);
                     // last packet in block?
                     if (++m_pktcnt == COM_PACKET_CNT) {
                        m_pktcnt = 0;
                        // report partial pipe content
                        if (gc.trace & WIN_TRACE_PIPE) {
                           printf("com_thread() pipelen = %d\n", COM_BLOCK_LEN);
                           dump(m_blk_pipe, 32, LIB_ASCII, 0);
                        }
                        // send pipe message
                        cm_pipe_send((pcm_pipe_t)m_blk_pipe, COM_BLOCK_LEN);
                        // record next start of block
                        m_blk_pipe = m_nxt_pipe;
                     }
                  }
                  newmsg = 0;
               }
               //
               // HDLC SOF
               //
               else if (raw[i] == COM_SOF) {
                  k      = 0;
                  esc    = 0;
                  newmsg = 1;
                  type   = COM_EPID_NEXT;
               }
               //
               // CTL OR PIPE
               //
               else if (type == COM_EPID_NEXT) {
                  type = (raw[i] == CM_ID_PIPE) ? COM_EPID_PIPE : COM_EPID_CTL;
                  // store cmid
                  if (type == COM_EPID_PIPE)
                     m_nxt_pipe[k++] = raw[i];
                  else
                     buf_u8[k++] = raw[i];
               }
               //
               // HDLC ESC
               //
               else if (raw[i] == COM_ESC) {
                  // unstuff next byte
                  esc = 1;
               }
               //
               // HDLC UNSTUFF OCTET
               //
               else if (esc == 1) {
                  esc = 0;
                  // unstuff byte
                  if (type == COM_EPID_PIPE)
                     m_nxt_pipe[k++] = raw[i] ^ COM_BIT;
                  else
                     buf_u8[k++] = raw[i] ^ COM_BIT;
               }
               //
               // NORMAL INCOMING OCTET
               //
               else {
                  if (type == COM_EPID_PIPE)
                     m_nxt_pipe[k++] = raw[i];
                  else
                     buf_u8[k++] = raw[i];
               }
            }
         }
      }
   }

   return 0;

} // end com_thread()


// ===========================================================================

// 7.3

void com_tx(pcm_msg_t msg) {

/* 7.3.1   Functional Description

   This routine will transmit the message. The tx_mutex is used to prevent
   mulitple threads from interferring with a single message transfer. HDLC
   coding is used to form a message packet.

   7.3.2   Parameters:

   msg     CM message to send.

   7.3.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.3.4   Data Structures

   uint8_t    *out = (uint8_t *)msg;
   uint8_t    *buf;
   uint16_t    i, j = 0;
   DWORD       bytes_left, bytes_sent;
   uint8_t     retry = 0;

// 7.3.5   Code

   // Trace Entry
   if (gc.trace & WIN_TRACE_UART) {
      printf("com_tx() srvid:msgid:msglen = %02X:%02X:%04X\n",
               msg->p.srvid, msg->p.msgid, msg->h.msglen);
      dump((uint8_t *)msg, msg->h.msglen, LIB_ASCII, 0);
   }

   // Enter Critical Section
   EnterCriticalSection(&m_tx_mutex);

   buf = (uint8_t *)calloc(COM_MSGLEN_UINT8 * 2, sizeof(uint8_t));

   buf[j++] = COM_SOF;
   for (i=0;i<msg->h.msglen;i++) {
      if (out[i] == COM_SOF || out[i] == COM_EOF || out[i] == COM_ESC) {
         buf[j++] = COM_ESC;
         buf[j++] = out[i] ^ COM_BIT;
      }
      else {
         buf[j++] = out[i];
      }
   }
   buf[j++] = COM_EOF;
   bytes_left = j;
   bytes_sent = SioPuts(m_com, (CHAR *)buf, bytes_left);
   bytes_left -= bytes_sent;
   //retry
   while (bytes_left != 0 && retry < COM_RETRIES) {
      Sleep(10);
      bytes_sent = SioPuts(m_com, (CHAR *)&buf[j - bytes_left], bytes_left);
      bytes_left -= bytes_sent;
      retry++;
   }

   // release message
   cm_free(msg);

   free(buf);

   // Leave Critical Section
   LeaveCriticalSection(&m_tx_mutex);

} // end com_tx()


// ===========================================================================

// 7.4

void com_cmio(uint8_t op_code, pcm_msg_t msg) {

/* 7.4.1   Functional Description

   OPCODES

   CM_IO_TX : The transmit queue index will be incremented,
   this causes the top of the queue to be transmitted.

   7.4.2   Parameters:

   msg     Message Pointer
   opCode  CM_IO_TX

   7.4.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.4.4   Data Structures

// 7.4.5   Code

   if (gc.trace & WIN_TRACE_UART) {
      printf("com_cmio() op_code = %02X\n", op_code);
   }

   // transmit message
   com_tx(msg);

} // end com_cmio()


// ===========================================================================

// 7.5

void com_head(void) {

/* 7.5.1   Functional Description

   This routine will reset the pipe circular buffer pointers and
   associated counters.

   7.5.2   Parameters:

   NONE

   7.5.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.5.4   Data Structures

// 7.5.5   Code

   // reset pipe circular buffer
   m_nxt_pipe  = m_pool;
   m_blk_pipe  = m_pool;
   m_head      = 0;
   m_pktcnt    = 0;

} // end com_head()


// ===========================================================================

// 7.6

void com_final(void) {

/* 7.6.1   Functional Description

   This routine will clean-up any allocated resources.

   7.6.2   Parameters:

   NONE

   7.6.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.6.4   Data Structures

// 7.6.5   Code

   // Wake-up Thread and Cancel
   m_end_thread = TRUE;
   SioSetInteger(m_com,'S',1);

   // Close COM
   SioDone(m_com);

   // Release Memory
   free(m_pool);

} // end com_final()




