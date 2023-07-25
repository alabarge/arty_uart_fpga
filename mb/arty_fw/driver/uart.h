#pragma once

#include "cm.h"

#define  UART_START_FRAME      0x7E
#define  UART_END_FRAME        0x7D
#define  UART_ESCAPE           0x7C
#define  UART_STUFFED_BIT      0x20

#define  UART_FLAG_ESCAPE      0x01
#define  UART_FLAG_START       0x02
#define  UART_FLAG_MSG         0x04

#define  UART_OSR              16

#define  UART_RX_IDLE          0
#define  UART_RX_MSG           1
#define  UART_RX_ESCAPE        2

#define  UART_TX_IDLE          0
#define  UART_TX_MSG           1
#define  UART_TX_ESCAPE        2

#define  UART_OK               0x00000000
#define  UART_ERROR            0x80000001
#define  UART_ERR_MSG_NULL     0x80000002
#define  UART_ERR_LEN_NULL     0x80000004
#define  UART_ERR_LEN_MAX      0x80000008
#define  UART_ERR_FRAMING      0x80000010
#define  UART_ERR_OVERRUN      0x80000020
#define  UART_ERR_PARITY       0x80000040
#define  UART_ERR_TX_DROP      0x80000080
#define  UART_ERR_RX_DROP      0x80000100
#define  UART_ERR_CRC          0x80000200
#define  UART_ERR_OPEN         0x80000400

#define  UART_OP_START         0x00000001
#define  UART_OP_STOP          0x00000002
#define  UART_OP_BYPASS        0x00000004

#define  UART_MSGLEN_UINT8     512
#define  UART_MSGLEN_UINT32    (UART_MSGLEN_UINT8 >> 2)

#define  UART_PIPELEN_UINT8    1024

#define  UART_TX_QUE           8
#define  UART_RX_QUE           1

#define  UART_TX_BUF_LEN       4096
#define  UART_RX_BUF_LEN       4096

// Control Register
typedef union _uart_ctl_reg_t {
   struct {
      uint32_t char_cnt       : 12; // uart_CONTROL(11:0)
      uint32_t timeout        : 8;  // uart_CONTROL(19:12)
      uint32_t                : 9;  // uart_CONTROL(28:20)
      uint32_t rx_int         : 1;  // uart_CONTROL(29)
      uint32_t tx_int         : 1;  // uart_CONTROL(30)
      uint32_t enable         : 1;  // uart_CONTROL(31)
   } b;
   uint32_t i;
} uart_ctl_reg_t, *puart_ctl_reg_t;

// Status Register
typedef union _uart_sta_reg_t {
   struct {
      uint32_t                : 30; // uart_STATUS(29:0)
      uint32_t tx_rdy         : 1;  // uart_STATUS(30)
      uint32_t enable         : 1;  // uart_STATUS(31)
   } b;
   uint32_t i;
} uart_sta_reg_t, *puart_sta_reg_t;

// Head Tail Status Register
typedef union _uart_ptr_sta_reg_t {
   struct {
      uint32_t tx_tail        : 12; // uart_PTR_STA(11:0)
      uint32_t                : 4;  // uart_PTR_STA(15:12)
      uint32_t rx_head        : 12; // uart_PTR_STA(27:16)
      uint32_t                : 4;  // uart_PTR_STA(31:28)
   } b;
   uint32_t i;
} uart_ptr_sta_reg_t, *puart_ptr_sta_reg_t;

// Head Tail Control Register
typedef union _uart_ptr_ctl_reg_t {
   struct {
      uint32_t tx_head        : 12; // uart_PTR_STA(11:0)
      uint32_t                : 4;  // uart_PTR_STA(15:12)
      uint32_t rx_tail        : 12; // uart_PTR_STA(27:16)
      uint32_t                : 4;  // uart_PTR_STA(31:28)
   } b;
   uint32_t i;
} uart_ptr_ctl_reg_t, *puart_ptr_ctl_reg_t;

// all registers
typedef struct _uart_regs_t {
   uint32_t       control;
   uart_sta_reg_t status;
   uint32_t       version;
   uint32_t       irq;
   uint32_t       ticks;
   uart_ptr_sta_reg_t ptr_sta;
   uint32_t       ptr_ctl;
   uint32_t       unused[4089];
   uint32_t       rtx_buf[4096];
} uart_regs_t, *puart_regs_t;

// transmit queue
typedef struct _uart_txq_t {
   uint8_t       state;
   uint8_t       head;
   uint8_t       tail;
   uint8_t      *buf[UART_TX_QUE];
   uint8_t       slots;
   uint16_t      len[UART_TX_QUE];
   uint16_t      n;
} uart_txq_t, *puart_txq_t;

// receive queue
typedef struct _uart_rxq_t {
   uint8_t       state;
   uint16_t      count;
   uint8_t       slotid;
   uint32_t      tail;
   pcmq_t        slot;
   pcm_msg_t     msg;
} uart_rxq_t, *puart_rxq_t;

uint32_t  uart_init(uint32_t baudrate, uint8_t port);
void      uart_isr(void *arg);
void      uart_intack(uint8_t int_type);
void      uart_tx(void);
void      uart_cmio(uint8_t op_code, pcm_msg_t msg);
void      uart_msgtx(void);
void      uart_pipe(pcm_pipe_t msg);
void      uart_report(void);

