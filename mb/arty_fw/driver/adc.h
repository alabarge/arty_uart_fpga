#pragma once

#define  ADC_OK            0x0000

#define  ADC_INT_DONE      0x01
#define  ADC_INT_PKT       0x02
#define  ADC_INT_ALL       0x04

// all registers
typedef struct _adc_regs_t {
   uint32_t       sw_reset;
   uint32_t       status;
   uint32_t       alarm;
   uint32_t       convst;
   uint32_t       hw_reset;
} adc_regs_t, *padc_regs_t;

uint32_t adc_init(void);
void     adc_isr(void *arg);
void     adc_intack(uint8_t int_type);
void     adc_run(uint32_t flags, uint32_t packets);
void     adc_tick(void);
void     adc_rate(uint8_t rate);
void     adc_report(void);
void     adc_avg(uint8_t avg);
