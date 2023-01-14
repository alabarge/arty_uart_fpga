/*-----------------------------------------------------------------------------

   1  ABSTRACT

   1.1 Module Type

      LED and BTN Switch Driver.

   1.2 Functional Description

      The GPIO Interface routines are contained in this module.

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
      7.1   gpio_init()
      7.2   gpio_isr()
      7.3   gpio_val_set()
      7.4   gpio_key()

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

   static   volatile pgpio_regs_t   leds = (volatile pgpio_regs_t)XPAR_AXI_LED_BASEADDR;
   static   volatile pgpio_regs_t   btns = (volatile pgpio_regs_t)XPAR_AXI_BUTTON_BASEADDR;
   static   uint32_t leds_dat;

// 7 MODULE CODE

// ===========================================================================

// 7.1

uint32_t gpio_init(void) {

/* 7.1.1   Functional Description

   This routine is responsible for initializing the driver hardware.

   7.1.2   Parameters:

   NONE

   7.1.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.1.4   Data Structures

   uint32_t   result = CFG_STATUS_OK;

// 7.1.5   Code

   // set gpio_1 direction, all out
   leds->tri = 0x0;

   // set gpio_1 all off
   leds->dat = 0x0;
   leds_dat  = 0x0;

   // set gpio_2 direction, all in
   btns->tri = ~0x0;

   return result;

}  // end gpio_init()


// ===========================================================================

// 7.2

void gpio_isr(void *arg) {

/* 7.2.1   Functional Description

   This routine will service the GPX Interrupt.

   7.2.2   Parameters:

   NONE

   7.2.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.2.4   Data Structures

// 7.2.5   Code

} // end gpio_isr()


// ===========================================================================

// 7.3

void gpio_set_val(uint8_t gpio, uint8_t state) {

/* 7.3.1   Functional Description

   This routine will set the GPIO0 data bits.

   7.3.2   Parameters:

   gpio     GPIO to change
   state    ON/OFF/TOGGLE state

   7.3.3   Return Values:

   NONE

-----------------------------------------------------------------------------
*/

// 7.3.4   Data Structures

// 7.3.5   Code

   switch(state) {
      case GPIO_LED_ON :
         leds_dat |=  gpio;
         break;
      case GPIO_LED_OFF :
         leds_dat &= ~gpio;
         break;
      case GPIO_LED_TOGGLE :
         leds_dat ^=  gpio;
         break;
      case GPIO_LED_ALL_OFF :
         leds_dat  &=  0xF0;
         break;
      case GPIO_LED_ALL_ON :
         leds_dat  |=  0x0F;
         break;
      case GPIO_TP_ON :
         leds_dat |=  gpio;
         break;
      case GPIO_TP_OFF :
         leds_dat &= ~gpio;
         break;
      case GPIO_TP_TOGGLE :
         leds_dat ^=  gpio;
         break;
   }

   leds->dat = leds_dat;

}  // end gpio_val_set()


// ===========================================================================

// 7.4

uint8_t gpio_key(void) {

/* 7.4.1   Functional Description

   This routine will return the current state of the push button switches.

   7.4.2   Parameters:

   NONE

   7.4.3   Return Values:

   result   KEY 0-3 Switch states

-----------------------------------------------------------------------------
*/

// 7.4.4   Data Structures

// 7.4.5   Code

   // return current port value
   return btns->dat & 0xF;

}  // end gpio_key()
