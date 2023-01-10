#pragma once

// control
#define  UART_RST_TX_FIFO  0x0001
#define  UART_RST_RX_FIFO  0x0002
#define  UART_INT_EN       0x0010

// status
#define  UART_RX_VALID     0x0001
#define  UART_RX_FULL      0x0002
#define  UART_TX_EMPTY     0x0004
#define  UART_TX_FULL      0x0008
#define  UART_INT_ENABLED  0x0010
#define  UART_OVERRUN_ERR  0x0020
#define  UART_FRAME_ERR    0x0040
#define  UART_PARITY_ERR   0x0080

// all registers
typedef struct _uart_regs_t {
   uint32_t       rx_dat;
   uint32_t       tx_dat;
   uint32_t       status;
   uint32_t       control;
} uart_regs_t, *puart_regs_t;

int  xlprint(const char *format, ...);
int  xlprints(char *buf, const char *format, ...);
void xlprint_open(uint32_t devAddr);
void xlprint_isr(void *arg);
