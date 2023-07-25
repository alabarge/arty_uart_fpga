/*-----------------------------------------------------------------------------

   1  ABSTRACT

   1.1 Module Type

      XADC Driver

   1.2 Functional Description

      The XADC Interface routines are contained in this module.

   1.3 Specification/Design Reference

      See fw_cfg.h under the BOOT/SHARE directory.

   1.4 Module Test Specification Reference

      None

   1.5 Compilation Information

      See fw_cfg.h under the BOOT/SHARE directory.

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
      7.1   adc_init()
      7.2   adc_isr()
      7.3   adc_run()
      7.4   adc_tick()
      7.5   adc_rate()
      7.6   adc_report()
      7.7   adc_avg()

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

   static   volatile padc_regs_t   regs = (volatile padc_regs_t)(XPAR_AXI_XADC_BASEADDR);

   static   cm_pipe_t     m_pipe  = {0};
   static   uint32_t      m_sam_cnt = 0;
   static   uint8_t       m_run = 0;
   static   uint32_t      m_flags = 0;
   static   uint16_t      m_ramp = 0;
   static   uint32_t      m_packets = 0;
   static   uint32_t      m_pkt_cnt = 0;

// 7 MODULE CODE

// ===========================================================================

// 7.1

uint32_t adc_init(void) {

/* 7.1.1   Functional Description

   This routine is responsible for initializing the driver hardware.

   7.1.2   Parameters:

   NONE

   7.1.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.1.4   Data Structures

   uint32_t    result = CFG_STATUS_OK;

   XSysMon_Config *config;


// 7.1.5   Code

   // initialize sysmon driver
   config = XSysMon_LookupConfig(XPAR_SYSMON_0_DEVICE_ID);
   XSysMon_CfgInitialize(&gc.sysmon, config, config->BaseAddress);

   // set adcclk rate
   XSysMon_SetAdcClkDivisor(&gc.sysmon, 40);

   // continuous sampling
   XSysMon_SetSequencerMode(&gc.sysmon, XSM_SEQ_MODE_CONTINPASS);

   m_pipe.dst_cmid = CM_ID_PIPE;
   m_pipe.msgid    = CM_PIPE_DAQ_DATA;
   m_pipe.port     = 0;
   m_pipe.flags    = 0;
   m_pipe.msglen   = 0x100;
   m_pipe.seqid    = 0;
   m_pipe.stamp    = STAMP_TCR;
   m_pipe.stamp_us = 0;
   m_pipe.status   = gc.status;
   m_pipe.rate     = 100;
   m_pipe.magic    = 0x012355AA;

   // report H/W details
   if (gc.trace & CFG_TRACE_ID) {
      xlprint("adc_init()\n");
      xlprint("  adc rate  : %d\n", XSysMon_GetAdcClkDivisor(&gc.sysmon));
      xlprint("  adc avg   : %d\n", XSysMon_GetAvg(&gc.sysmon));
      adc_report();
   }

   return result;

}  // end adc_init()


// ===========================================================================

// 7.2

void adc_isr(void *arg) {

/* 7.2.1   Functional Description

   This routine will service the hardware interrupt.

   7.2.2   Parameters:

   arg     IRQ arguments

   7.2.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.2.4   Data Structures

// 7.2.5   Code

} // end adc_isr()


// ===========================================================================

// 7.3

void adc_run(uint32_t flags, uint32_t packets) {

/* 7.3.1   Functional Description

   This routine will start or stop the ADC acquisition.

   7.3.2   Parameters:

   flags    Start/Stop flags
   packets  Number of 1024-Byte packets to acquire

   7.3.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.3.4   Data Structures

// 7.3.5   Code

   if (flags & DAQ_CMD_RUN) {
      m_packets = packets;
      m_pkt_cnt = 0;
      m_ramp    = 0;
      m_flags   = flags;
      m_run     = 1;
   }
   else if (flags & DAQ_CMD_STOP) {
      m_packets = packets;
      m_pkt_cnt = 0;
      m_ramp    = 0;
      m_flags   = flags;
      m_run     = 0;
   }

} // end adc_run()


// ===========================================================================

// 7.4

void adc_tick(void) {

/* 7.4.1   Functional Description

   This routine will check for end-of-sequence from the XADC.

   7.4.2   Parameters:

   NONE

   7.4.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.4.4   Data Structures

// 7.4.5   Code

   if (((XSysMon_GetStatus(&gc.sysmon) & XSM_SR_EOS_MASK) == XSM_SR_EOS_MASK) &&
        (m_run == 1)) {
      gpio_set_val(GPIO_TP_1, GPIO_TP_ON);
      gpio_set_val(GPIO_TP_1, GPIO_TP_OFF);
      // send ramp data
      if (m_flags & DAQ_CMD_RAMP) {
         m_pipe.samples[m_sam_cnt + 0] = m_ramp++;
         m_pipe.samples[m_sam_cnt + 1] = m_ramp++;
         m_pipe.samples[m_sam_cnt + 2] = m_ramp++;
         m_pipe.samples[m_sam_cnt + 3] = m_ramp++;
         m_pipe.samples[m_sam_cnt + 4] = m_ramp++;
         m_pipe.samples[m_sam_cnt + 5] = m_ramp++;
         m_pipe.samples[m_sam_cnt + 6] = m_ramp++;
         m_pipe.samples[m_sam_cnt + 7] = m_ramp++;
      }
      // send ADC samples
      else {
         m_pipe.samples[m_sam_cnt + 0] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 0);
         m_pipe.samples[m_sam_cnt + 1] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 1);
         m_pipe.samples[m_sam_cnt + 2] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 9);
         m_pipe.samples[m_sam_cnt + 3] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 2);
         m_pipe.samples[m_sam_cnt + 4] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 10);
         m_pipe.samples[m_sam_cnt + 5] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 11);
         m_pipe.samples[m_sam_cnt + 6] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 8);
         m_pipe.samples[m_sam_cnt + 7] = XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 3);
      }
      // eight samples per end-of-sequence
      m_sam_cnt += 8;
      // send completed message
      if (m_sam_cnt == 496) {
         m_sam_cnt = 0;
         m_pipe.stamp  = STAMP_TCR;
         m_pipe.status = gc.status;
         // transmit
         uart_pipe(&m_pipe);
         m_pipe.seqid++;
         m_pkt_cnt++;
         // stop after packets sent
         if (m_pkt_cnt == m_packets) {
            adc_run(DAQ_CMD_STOP, 0);
            // send interrupt indication
            cm_local(CM_ID_DAQ_SRV, DAQ_INT_IND, DAQ_INT_FLAG_DONE, DAQ_OK);
         }
      }
   }

} // end adc_tick()


// ===========================================================================

// 7.5

void adc_rate(uint8_t rate) {

/* 7.5.1   Functional Description

   This routine will set the ADC acquisition rate.

   7.5.2   Parameters:

   rate    DCLK rate

   7.5.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.5.4   Data Structures

// 7.5.5   Code

   XSysMon_SetSequencerMode(&gc.sysmon, XSM_SEQ_MODE_SAFE);
   XSysMon_SetAdcClkDivisor(&gc.sysmon, rate);
   XSysMon_SetSequencerMode(&gc.sysmon, XSM_SEQ_MODE_CONTINPASS);

} // end adc_rate()


// ===========================================================================

// 7.6

void adc_report(void) {

/* 7.6.1   Functional Description

   This routine will report all the ADC channels.

   7.6.2   Parameters:

   NONE

   7.6.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.6.4   Data Structures

// 7.6.5   Code

   // wait for end conversion
   while((XSysMon_GetStatus(&gc.sysmon) & XSM_SR_EOS_MASK) != XSM_SR_EOS_MASK);
   xlprint("  adc[0] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 0));
   xlprint("  adc[1] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 1));
   xlprint("  adc[2] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 9));
   xlprint("  adc[3] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 2));
   xlprint("  adc[4] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 10));
   xlprint("  adc[5] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 11));
   xlprint("  adc[6] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 8));
   xlprint("  adc[7] : %d\n", XSysMon_GetAdcData(&gc.sysmon, XSM_CH_AUX_MIN + 3));

} // end adc_report()


// ===========================================================================

// 7.7

void adc_avg(uint8_t avg) {

/* 7.7.1   Functional Description

   This routine will set the ADC averaging.

   7.7.2   Parameters:

   avg     0:No Average, 1:16 samples, 2:64 samples, 3:256 samples

   7.7.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.7.4   Data Structures

// 7.7.5   Code

   XSysMon_SetSequencerMode(&gc.sysmon, XSM_SEQ_MODE_SAFE);
   XSysMon_SetAvg(&gc.sysmon, avg);
   XSysMon_SetSequencerMode(&gc.sysmon, XSM_SEQ_MODE_CONTINPASS);

} // end adc_avg()
