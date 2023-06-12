#pragma once

#define  GPIO_OK               0x00

#define  GPIO_LED_ON           0
#define  GPIO_LED_OFF          1
#define  GPIO_LED_TOGGLE       2
#define  GPIO_LED_ALL_OFF      3
#define  GPIO_LED_ALL_ON       4
#define  GPIO_TP_ON            5
#define  GPIO_TP_OFF           6
#define  GPIO_TP_TOGGLE        7

#define  GPIO_LED_1            0x01
#define  GPIO_LED_2            0x02
#define  GPIO_LED_3            0x04
#define  GPIO_LED_4            0x08
#define  GPIO_TP_1             0x01
#define  GPIO_TP_2             0x02
#define  GPIO_TP_3             0x04
#define  GPIO_TP_4             0x08

#define  GPIO_LED_HB           GPIO_LED_1
#define  GPIO_LED_COM          GPIO_LED_2
#define  GPIO_LED_DAQ          GPIO_LED_3
#define  GPIO_LED_PIPE         GPIO_LED_4

#define  GPIO_LED_ERR          GPIO_LED_4

#define  GPIO_KEY_0            1
#define  GPIO_KEY_1            2
#define  GPIO_KEY_2            4
#define  GPIO_KEY_3            8
#define  GPIO_KEY_ALL_OFF      0x0
#define  GPIO_KEY_ALL_ON       0xF

// all registers
typedef struct _gpio_regs_t {
   uint32_t       dat;
   uint32_t       tri;
} gpio_regs_t, *pgpio_regs_t;

uint32_t gpio_init(void);
void     gpio_isr(void *arg);
void     gpio_set_val(uint8_t gpio, uint8_t state);
uint8_t  gpio_key(void);
