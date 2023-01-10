#pragma once

#include "cm.h"

#define  TTY_SOF              0x7E
#define  TTY_EOF              0x7D
#define  TTY_ESC              0x7C
#define  TTY_BIT              0x20

#define  TTY_INT_RX           0x01
#define  TTY_INT_TX           0x02
#define  TTY_INT_ALL          0x04

#define  TTY_OK               0x00000000
#define  TTY_ERROR            0x80000001
#define  TTY_ERR_MSG_NULL     0x80000002
#define  TTY_ERR_LEN_NULL     0x80000004
#define  TTY_ERR_LEN_MAX      0x80000008
#define  TTY_ERR_FRAMING      0x80000010
#define  TTY_ERR_OVERRUN      0x80000020
#define  TTY_ERR_PARITY       0x80000040
#define  TTY_ERR_TX_DROP      0x80000080
#define  TTY_ERR_RX_DROP      0x80000100
#define  TTY_ERR_CRC          0x80000200
#define  TTY_ERR_OPEN         0x80000400

#define  TTY_IDLE             0
#define  TTY_IN_MSG           1
#define  TTY_IN_ESC           2

#define  TTY_MSGLEN_UINT8     512
#define  TTY_MSGLEN_UINT32    (TTY_MSGLEN_UINT8 >> 2)

#define  TTY_TX_QUE           8
#define  TTY_RX_QUE           1

// control
#define  TTY_RST_TX_FIFO      0x0001
#define  TTY_RST_RX_FIFO      0x0002
#define  TTY_INT_EN           0x0010

// status
#define  TTY_RX_VALID         0x0001
#define  TTY_RX_FULL          0x0002
#define  TTY_TX_EMPTY         0x0004
#define  TTY_TX_FULL          0x0008
#define  TTY_INT_ENABLED      0x0010
#define  TTY_OVERRUN_ERR      0x0020
#define  TTY_FRAME_ERR        0x0040
#define  TTY_PARITY_ERR       0x0080

// all registers
typedef struct _tty_regs_t {
   uint32_t       rx_dat;
   uint32_t       tx_dat;
   uint32_t       status;
   uint32_t       control;
} tty_regs_t, *ptty_regs_t;

// Transmit Queue
typedef struct _tty_txq_t {
   uint32_t     *buf[TTY_TX_QUE];
   uint32_t      len[TTY_TX_QUE];
   uint32_t      n;
   uint8_t       tail;
   uint8_t       head;
   uint8_t       slots;
   uint8_t       state;
} tty_txq_t, *ptty_txq_t;

// Receive Queue
typedef struct _tty_rxq_t {
   uint32_t      raw[TTY_MSGLEN_UINT32];
   uint8_t      *buf;
   uint32_t      n;
   uint8_t       state;
} tty_rxq_t, *ptty_rxq_t;

uint32_t  tty_init(uint32_t baudrate, uint8_t port);
void      tty_isr(void *arg);
void      tty_intack(uint8_t int_type);
void      tty_tx(void);
void      tty_cmio(uint8_t op_code, pcm_msg_t msg);
void      tty_msgtx(void);
void      tty_pipe(uint32_t index, uint32_t msglen);

