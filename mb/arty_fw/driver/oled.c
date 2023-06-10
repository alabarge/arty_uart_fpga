#include "main.h"

// Add header of the fonts here.  Remove as many as possible to conserve FLASH memory.
#include "font5x7.h"
#include "font8x16.h"
#include "fontlargenumber.h"
#include "7segment.h"

// Change the total fonts included
#define OLED_TOTALFONTS      4

// Add the font name as declared in the header file.  Remove as many as possible to conserve FLASH memory.
static const unsigned char *fontsPointer[] = {
    font5x7,
    font8x16,
    sevensegment,
    fontlargenumber
};

/** \brief MicroOLED screen buffer.

Page buffer 64 x 48 divided by 8 = 384 bytes
Page buffer is required because in SPI mode, the host cannot read the SSD1306's GDRAM of the controller.  This page buffer serves as a scratch RAM for graphical functions.  All drawing function will first be drawn on this page buffer, only upon calling display() function will transfer the page buffer to the actual LCD controller's memory.
*/
static uint8_t screenmemory [] = {
    /* LCD Memory organised in 64 horizontal pixels and 6 rows of bytes
     B  B .............B  -----
     y  y .............y        \
     t  t .............t         \
     e  e .............e          \
     0  1 .............63          \
                                    \
     D0 D0.............D0            \
     D1 D1.............D1            / ROW 0
     D2 D2.............D2           /
     D3 D3.............D3          /
     D4 D4.............D4         /
     D5 D5.............D5        /
     D6 D6.............D6       /
     D7 D7.............D7  ----
    */
    //SparkFun Electronics LOGO

    // ROW0, BYTE0 to BYTE63
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xE0, 0xF8, 0xFC, 0xFE, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0x0F, 0x07, 0x07, 0x06, 0x06, 0x00, 0x80, 0x80, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

    // ROW1, BYTE64 to BYTE127
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x80, 0x80, 0x80, 0x80, 0x80, 0x80, 0x81, 0x07, 0x0F, 0x3F, 0x3F, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFE, 0xFE, 0xFC, 0xFC, 0xFC, 0xFE, 0xFF, 0xFF, 0xFF, 0xFC, 0xF8, 0xE0,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

    // ROW2, BYTE128 to BYTE191
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFC,
    0xFE, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xF1, 0xE0, 0xE0, 0xE0, 0xE0, 0xE0, 0xF0, 0xFD, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

    // ROW3, BYTE192 to BYTE255
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x1F, 0x07, 0x01,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

    // ROW4, BYTE256 to BYTE319
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
    0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x7F, 0x3F, 0x1F, 0x1F, 0x0F, 0x0F, 0x0F, 0x0F,
    0x0F, 0x0F, 0x0F, 0x0F, 0x07, 0x07, 0x07, 0x03, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,

    // ROW5, BYTE320 to BYTE383
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF,
    0x7F, 0x3F, 0x1F, 0x0F, 0x07, 0x03, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
};

   static   volatile poled_regs_t   oled = (volatile poled_regs_t)XPAR_AXI_OLED_BASEADDR;
   static   oled_dat_reg_t oled_dat;

   static uint8_t foreColor,drawMode,fontWidth, fontHeight, fontType;
   static uint8_t fontStartChar, fontTotalChar, cursorX, cursorY;
   static uint16_t fontMapWidth;


   static uint8_t width  = OLED_LCDWIDTH;
   static uint8_t height = OLED_LCDHEIGHT;

   static float px[] = { -3,  3,  3, -3, -3,  3,  3, -3 };
   static float py[] = { -3, -3,  3,  3, -3, -3,  3,  3 };
   static float pz[] = { -3, -3, -3, -3,  3,  3,  3,  3 };

   static float p2x[] = {0,0,0,0,0,0,0,0};
   static float p2y[] = {0,0,0,0,0,0,0,0};

   static float r[]   = {0,0,0};

   #define SHAPE_SIZE 600

/** \brief Initialisation of MicroOLED Library.

    Setup IO pins for SPI port then send initialisation commands to the SSD1306 controller inside the OLED.
*/
uint32_t oled_init() {

   uint32_t   result = CFG_STATUS_OK;

   // oled data register
   oled_dat.i      = 0x0;
   oled_dat.b.sck  = 0;
   oled_dat.b.mosi = 0;
   oled_dat.b.ss   = 1;
   oled_dat.b.rst  = 1;
   oled_dat.b.dc   = 0;

   // set oled direction, all out
   oled->tri = 0x0;

   // set oled all off
   oled->dat = oled_dat.i;

   // default 5x7 font
   oled_setFontType(0);
   oled_setColor(OLED_WHITE);
   oled_setDrawMode(OLED_NORM);
   oled_setCursor(0,0);

   // oled reset
   oled_dat.b.rst = 0;
   oled->dat = oled_dat.i;
   utick(500);
   oled_dat.b.rst = 1;
   oled->dat = oled_dat.i;
   utick(500);

   // Display Init sequence for 64x48 OLED module
   oled_command(OLED_DISPLAYOFF);          // 0xAE

   oled_command(OLED_SETDISPLAYCLOCKDIV);  // 0xD5
   oled_command(0x80);                    // the suggested ratio 0x80

   oled_command(OLED_SETMULTIPLEX);            // 0xA8
   oled_command(0x2F);

   oled_command(OLED_SETDISPLAYOFFSET);        // 0xD3
   oled_command(0x0);                 // no offset

   oled_command(OLED_SETSTARTLINE | 0x0);  // line #0

   oled_command(OLED_CHARGEPUMP);          // enable charge pump
   oled_command(0x14);

   oled_command(OLED_NORMALDISPLAY);           // 0xA6
   oled_command(OLED_DISPLAYALLONRESUME);  // 0xA4

   oled_command(OLED_SEGREMAP | 0x1);
   oled_command(OLED_COMSCANDEC);

   oled_command(OLED_SETCOMPINS);          // 0xDA
   oled_command(0x12);

   oled_command(OLED_SETCONTRAST);         // 0x81
   oled_command(0x8F);

   oled_command(OLED_SETPRECHARGE);            // 0xd9
   oled_command(0xF1);

   oled_command(OLED_SETVCOMDESELECT);         // 0xDB
   oled_command(0x40);

   oled_clear(OLED_ALL);                       // Erase hardware memory inside the OLED controller to avoid random data in memory.

   oled_command(OLED_DISPLAYON);               //--turn on oled panel

   return result;
}

/** \brief Send the display a command byte

    Send a command via SPI, I2C or parallel to SSD1306 controller.
    For SPI we set the DC and CS pins here, and call spiTransfer(byte)
    to send the data. For I2C and Parallel we use the write functions
    defined in hardware.cpp to send the data.
*/
void oled_command(uint8_t c) {

   uint8_t     mask;
   uint32_t    i;

   oled_dat.b.dc  = 0;
   oled_dat.b.ss  = 0;
   oled_dat.b.sck = 0;
   oled->dat = oled_dat.i;

   mask = 0x80;
   for (i=0;i<8;i++) {
      if (c & mask)
         oled_dat.b.mosi = 1;
      else
         oled_dat.b.mosi = 0;
      oled->dat = oled_dat.i;
      oled_dat.b.sck = 1;
      oled->dat = oled_dat.i;
      oled_dat.b.sck = 0;
      oled->dat = oled_dat.i;
      mask >>= 1;
   }

   oled_dat.b.dc  = 1;
   oled_dat.b.ss  = 1;
   oled_dat.b.sck = 0;
   oled->dat = oled_dat.i;

}


/** \brief Send the display a data byte

    Send a data byte via SPI, I2C or parallel to SSD1306 controller.
    For SPI we set the DC and CS pins here, and call spiTransfer(byte)
    to send the data. For I2C and Parallel we use the write functions
    defined in hardware.cpp to send the data.
*/
void oled_data(uint8_t c) {

   uint8_t     mask;
   uint32_t    i;

   oled_dat.b.dc  = 1;
   oled_dat.b.ss  = 0;
   oled_dat.b.sck = 0;
   oled->dat = oled_dat.i;

   mask = 0x80;
   for (i=0;i<8;i++) {
      if (c & mask)
         oled_dat.b.mosi = 1;
      else
         oled_dat.b.mosi = 0;
      oled->dat = oled_dat.i;
      oled_dat.b.sck = 1;
      oled->dat = oled_dat.i;
      oled_dat.b.sck = 0;
      oled->dat = oled_dat.i;
      mask >>= 1;
   }

   oled_dat.b.dc  = 1;
   oled_dat.b.ss  = 1;
   oled_dat.b.sck = 0;
   oled->dat = oled_dat.i;
}

/** \brief Set SSD1306 page address.

    Send page address command and address to the SSD1306 OLED controller.
*/
void oled_setPageAddress(uint8_t add) {
   add=0xb0|add;
   oled_command(add);
   return;
}

/** \brief Set SSD1306 column address.

    Send column address command and address to the SSD1306 OLED controller.
*/
void oled_setColumnAddress(uint8_t add) {
    oled_command((0x10|(add>>4))+0x02);
    oled_command((0x0f&add));
    return;
}

/** \brief Clear screen buffer or SSD1306's memory.

    To clear GDRAM inside the LCD controller, pass in the variable mode = ALL and to clear screen page buffer pass in the variable mode = PAGE.
*/
void oled_clear(uint8_t mode) {
    //  uint8_t page=6, col=0x40;
    if (mode==OLED_ALL) {
        for (int i=0;i<8; i++) {
            oled_setPageAddress(i);
            oled_setColumnAddress(0);
            for (int j=0; j<0x80; j++) {
                oled_data(0);
            }
        }
    }
    else
    {
        memset(screenmemory,0,384);         // (64 x 48) / 8 = 384
        //display();
    }
}

/** \brief Invert display.

    The WHITE color of the display will turn to BLACK and the BLACK will turn to WHITE.
*/
void oled_invert(uint8_t inv) {
    if (inv)
    oled_command(OLED_INVERTDISPLAY);
    else
    oled_command(OLED_NORMALDISPLAY);
}

/** \brief Set contrast.

    OLED contract value from 0 to 255. Note: Contrast level is not very obvious.
*/
void oled_contrast(uint8_t contrast) {
    oled_command(OLED_SETCONTRAST);           // 0x81
    oled_command(contrast);
}

/** \brief Transfer display memory.

    Bulk move the screen buffer to the SSD1306 controller's memory so that images/graphics drawn on the screen buffer will be displayed on the OLED.
*/
void oled_display(void) {
    uint8_t i, j;

    for (i=0; i<6; i++) {
        oled_setPageAddress(i);
        oled_setColumnAddress(0);
        for (j=0;j<0x40;j++) {
            oled_data(screenmemory[i*0x40+j]);
        }
    }
}

/** \brief Override Arduino's Print.

    Arduino's print overridden so that we can use uView.print().
*/
uint8_t oled_write(uint8_t c) {
    if (c == '\n') {
        cursorY += fontHeight;
        cursorX  = 0;
    } else if (c == '\r') {
        // skip
    } else {
        oled_drawChar1(cursorX, cursorY, c, foreColor, drawMode);
        cursorX += fontWidth+1;
        if ((cursorX > (OLED_LCDWIDTH - fontWidth))) {
            cursorY += fontHeight;
            cursorX = 0;
        }
    }

    return 1;
}

void oled_print(char *str) {
	uint8_t i;
	for (i=0;i<strlen(str);i++) {
		oled_write(str[i]);
	}
}

/** \brief Set cursor position.

MicroOLED's cursor position to x,y.
*/
void oled_setCursor(uint8_t x, uint8_t y) {
    cursorX=x;
    cursorY=y;
}

/** \brief Draw pixel.

Draw pixel using the current fore color and current draw mode in the screen buffer's x,y position.
*/
void oled_pixel0(uint8_t x, uint8_t y) {
    oled_pixel1(x,y,foreColor,drawMode);
}

/** \brief Draw pixel with color and mode.

Draw color pixel in the screen buffer's x,y position with NORM or XOR draw mode.
*/
void oled_pixel1(uint8_t x, uint8_t y, uint8_t color, uint8_t mode) {
    if ((x<0) ||  (x>=OLED_LCDWIDTH) || (y<0) || (y>=OLED_LCDHEIGHT))
    return;

    if (mode==OLED_XOR) {
        if (color==OLED_WHITE)
        screenmemory[x+ (y/8)*OLED_LCDWIDTH] ^= bit((y%8));
    }
    else {
        if (color==OLED_WHITE)
        screenmemory[x+ (y/8)*OLED_LCDWIDTH] |= bit((y%8));
        else
        screenmemory[x+ (y/8)*OLED_LCDWIDTH] &= ~bit((y%8));
    }
}

/** \brief Draw line.

Draw line using current fore color and current draw mode from x0,y0 to x1,y1 of the screen buffer.
*/
void oled_line0(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1) {
    oled_line1(x0,y0,x1,y1,foreColor,drawMode);
}

/** \brief Draw line with color and mode.

Draw line using color and mode from x0,y0 to x1,y1 of the screen buffer.
*/
void oled_line1(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t color, uint8_t mode) {
    uint8_t steep = abs(y1 - y0) > abs(x1 - x0);
    if (steep) {
        swap(x0, y0);
        swap(x1, y1);
    }

    if (x0 > x1) {
        swap(x0, x1);
        swap(y0, y1);
    }

    uint8_t dx, dy;
    dx = x1 - x0;
    dy = abs(y1 - y0);

    int8_t err = dx / 2;
    int8_t ystep;

    if (y0 < y1) {
        ystep = 1;
    } else {
        ystep = -1;}

    for (; x0<x1; x0++) {
        if (steep) {
            oled_pixel1(y0, x0, color, mode);
        } else {
            oled_pixel1(x0, y0, color, mode);
        }
        err -= dy;
        if (err < 0) {
            y0 += ystep;
            err += dx;
        }
    }
}

/** \brief Draw horizontal line.

Draw horizontal line using current fore color and current draw mode from x,y to x+width,y of the screen buffer.
*/
void oled_lineH0(uint8_t x, uint8_t y, uint8_t width) {
    oled_line1(x,y,x+width,y,foreColor,drawMode);
}

/** \brief Draw horizontal line with color and mode.

Draw horizontal line using color and mode from x,y to x+width,y of the screen buffer.
*/
void oled_lineH1(uint8_t x, uint8_t y, uint8_t width, uint8_t color, uint8_t mode) {
    oled_line1(x,y,x+width,y,color,mode);
}

/** \brief Draw vertical line.

Draw vertical line using current fore color and current draw mode from x,y to x,y+height of the screen buffer.
*/
void oled_lineV0(uint8_t x, uint8_t y, uint8_t height) {
    oled_line1(x,y,x,y+height,foreColor,drawMode);
}

/** \brief Draw vertical line with color and mode.

Draw vertical line using color and mode from x,y to x,y+height of the screen buffer.
*/
void oled_lineV1(uint8_t x, uint8_t y, uint8_t height, uint8_t color, uint8_t mode) {
    oled_line1(x,y,x,y+height,color,mode);
}

/** \brief Draw rectangle.

Draw rectangle using current fore color and current draw mode from x,y to x+width,y+height of the screen buffer.
*/
void oled_rect0(uint8_t x, uint8_t y, uint8_t width, uint8_t height) {
    oled_rect1(x,y,width,height,foreColor,drawMode);
}

/** \brief Draw rectangle with color and mode.

Draw rectangle using color and mode from x,y to x+width,y+height of the screen buffer.
*/
void oled_rect1(uint8_t x, uint8_t y, uint8_t width, uint8_t height, uint8_t color , uint8_t mode) {
    uint8_t tempHeight;

    oled_lineH1(x,y, width, color, mode);
    oled_lineH1(x,y+height-1, width, color, mode);

    tempHeight=height-2;

    // skip drawing vertical lines to avoid overlapping of pixel that will
    // affect XOR plot if no pixel in between horizontal lines
    if (tempHeight<1) return;

    oled_lineV1(x,y+1, tempHeight, color, mode);
    oled_lineV1(x+width-1, y+1, tempHeight, color, mode);
}

/** \brief Draw filled rectangle.

Draw filled rectangle using current fore color and current draw mode from x,y to x+width,y+height of the screen buffer.
*/
void oled_rectFill0(uint8_t x, uint8_t y, uint8_t width, uint8_t height) {
    oled_rectFill1(x,y,width,height,foreColor,drawMode);
}

/** \brief Draw filled rectangle with color and mode.

Draw filled rectangle using color and mode from x,y to x+width,y+height of the screen buffer.
*/
void oled_rectFill1(uint8_t x, uint8_t y, uint8_t width, uint8_t height, uint8_t color , uint8_t mode) {
    for (int i=x; i<x+width;i++) {
        oled_lineV1(i,y, height, color, mode);
    }
}

/** \brief Draw circle.

    Draw circle with radius using current fore color and current draw mode at x,y of the screen buffer.
*/
void oled_circle0(uint8_t x0, uint8_t y0, uint8_t radius) {
    oled_circle1(x0,y0,radius,foreColor,drawMode);
}

/** \brief Draw circle with color and mode.

Draw circle with radius using color and mode at x,y of the screen buffer.
*/
void oled_circle1(uint8_t x0, uint8_t y0, uint8_t radius, uint8_t color, uint8_t mode) {
    int8_t f = 1 - radius;
    int8_t ddF_x = 1;
    int8_t ddF_y = -2 * radius;
    int8_t x = 0;
    int8_t y = radius;

    oled_pixel1(x0, y0+radius, color, mode);
    oled_pixel1(x0, y0-radius, color, mode);
    oled_pixel1(x0+radius, y0, color, mode);
    oled_pixel1(x0-radius, y0, color, mode);

    while (x<y) {
        if (f >= 0) {
            y--;
            ddF_y += 2;
            f += ddF_y;
        }
        x++;
        ddF_x += 2;
        f += ddF_x;

        oled_pixel1(x0 + x, y0 + y, color, mode);
        oled_pixel1(x0 - x, y0 + y, color, mode);
        oled_pixel1(x0 + x, y0 - y, color, mode);
        oled_pixel1(x0 - x, y0 - y, color, mode);

        oled_pixel1(x0 + y, y0 + x, color, mode);
        oled_pixel1(x0 - y, y0 + x, color, mode);
        oled_pixel1(x0 + y, y0 - x, color, mode);
        oled_pixel1(x0 - y, y0 - x, color, mode);

    }
}

/** \brief Draw filled circle.

    Draw filled circle with radius using current fore color and current draw mode at x,y of the screen buffer.
*/
void oled_circleFill0(uint8_t x0, uint8_t y0, uint8_t radius) {
    oled_circleFill1(x0,y0,radius,foreColor,drawMode);
}

/** \brief Draw filled circle with color and mode.

    Draw filled circle with radius using color and mode at x,y of the screen buffer.
*/
void oled_circleFill1(uint8_t x0, uint8_t y0, uint8_t radius, uint8_t color, uint8_t mode) {
    int8_t f = 1 - radius;
    int8_t ddF_x = 1;
    int8_t ddF_y = -2 * radius;
    int8_t x = 0;
    int8_t y = radius;

    // Temporary disable fill circle for XOR mode.
    if (mode==OLED_XOR) return;

    for (uint8_t i=y0-radius; i<=y0+radius; i++) {
        oled_pixel1(x0, i, color, mode);
    }

    while (x<y) {
        if (f >= 0) {
            y--;
            ddF_y += 2;
            f += ddF_y;
        }
        x++;
        ddF_x += 2;
        f += ddF_x;

        for (uint8_t i=y0-y; i<=y0+y; i++) {
            oled_pixel1(x0+x, i, color, mode);
            oled_pixel1(x0-x, i, color, mode);
        }
        for (uint8_t i=y0-x; i<=y0+x; i++) {
            oled_pixel1(x0+y, i, color, mode);
            oled_pixel1(x0-y, i, color, mode);
        }
    }
}

/** \brief Get LCD height.

    The height of the LCD return as byte.
*/
uint8_t oled_getLCDHeight(void) {
    return OLED_LCDHEIGHT;
}

/** \brief Get LCD width.

    The width of the LCD return as byte.
*/
uint8_t oled_getLCDWidth(void) {
    return OLED_LCDWIDTH;
}

/** \brief Get font width.

    The current font's width return as byte.
*/
uint8_t oled_getFontWidth(void) {
    return fontWidth;
}

/** \brief Get font height.

    The current font's height return as byte.
*/
uint8_t oled_getFontHeight(void) {
    return fontHeight;
}

/** \brief Get font starting character.

    Return the starting ASCII character of the currnet font, not all fonts start with ASCII character 0. Custom fonts can start from any ASCII character.
*/
uint8_t oled_getFontStartChar(void) {
    return fontStartChar;
}

/** \brief Get font total characters.

    Return the total characters of the current font.
*/
uint8_t oled_getFontTotalChar(void) {
    return fontTotalChar;
}

/** \brief Get total fonts.

    Return the total number of fonts loaded into the MicroOLED's flash memory.
*/
uint8_t oled_getTotalFonts(void) {
    return OLED_TOTALFONTS;
}

/** \brief Get font type.

    Return the font type number of the current font.
*/
uint8_t oled_getFontType(void) {
    return fontType;
}

/** \brief Set font type.

    Set the current font type number, ie changing to different fonts base on the type provided.
*/
uint8_t oled_setFontType(uint8_t type) {
    if ((type>=OLED_TOTALFONTS) || (type<0))
    return FALSE;

    fontType=type;
    fontWidth=*(fontsPointer[fontType]+0);
    fontHeight=*(fontsPointer[fontType]+1);
    fontStartChar=*(fontsPointer[fontType]+2);
    fontTotalChar=*(fontsPointer[fontType]+3);
    fontMapWidth=(*(fontsPointer[fontType]+4)*100)+*(fontsPointer[fontType]+5); // two bytes values into integer 16
    return TRUE;
}

/** \brief Set color.

    Set the current draw's color. Only WHITE and BLACK available.
*/
void oled_setColor(uint8_t color) {
    foreColor=color;
}

/** \brief Set draw mode.

    Set current draw mode with NORM or XOR.
*/
void oled_setDrawMode(uint8_t mode) {
    drawMode=mode;
}

/** \brief Draw character.

    Draw character c using current color and current draw mode at x,y.
*/
void  oled_drawChar0(uint8_t x, uint8_t y, uint8_t c) {
    oled_drawChar1(x,y,c,foreColor,drawMode);
}

/** \brief Draw character with color and mode.

    Draw character c using color and draw mode at x,y.
*/
void  oled_drawChar1(uint8_t x, uint8_t y, uint8_t c, uint8_t color, uint8_t mode) {

    uint8_t rowsToDraw,row, tempC;
    uint8_t i,j,temp;
    uint16_t charPerBitmapRow,charColPositionOnBitmap,charRowPositionOnBitmap,charBitmapStartPosition;

    if ((c<fontStartChar) || (c>(fontStartChar+fontTotalChar-1)))       // no bitmap for the required c
    return;

    tempC=c-fontStartChar;

    // each row (in datasheet is call page) is 8 bits high, 16 bit high character will have 2 rows to be drawn
    rowsToDraw=fontHeight/8;    // 8 is LCD's page size, see SSD1306 datasheet
    if (rowsToDraw<=1) rowsToDraw=1;

    // the following draw function can draw anywhere on the screen, but SLOW pixel by pixel draw
    if (rowsToDraw==1) {
        for  (i=0;i<fontWidth+1;i++) {
            if (i==fontWidth) // this is done in a weird way because for 5x7 font, there is no margin, this code add a margin after col 5
            temp=0;
            else
            temp=*(fontsPointer[fontType]+OLED_FONTHEADERSIZE+(tempC*fontWidth)+i);

            for (j=0;j<8;j++) {         // 8 is the LCD's page height (see datasheet for explanation)
                if (temp & 0x1) {
                    oled_pixel1(x+i, y+j, color,mode);
                }
                else {
                    oled_pixel1(x+i, y+j, !color,mode);
                }

                temp >>=1;
            }
        }
        return;
    }

    // font height over 8 bit
    // take character "0" ASCII 48 as example
    charPerBitmapRow=fontMapWidth/fontWidth;  // 256/8 =32 char per row
    charColPositionOnBitmap=tempC % charPerBitmapRow;  // =16
    charRowPositionOnBitmap=tempC/charPerBitmapRow; // =1
    charBitmapStartPosition=(charRowPositionOnBitmap * fontMapWidth * (fontHeight/8)) + (charColPositionOnBitmap * fontWidth) ;

    // each row on LCD is 8 bit height (see datasheet for explanation)
    for(row=0;row<rowsToDraw;row++) {
        for (i=0; i<fontWidth;i++) {
            temp=*(fontsPointer[fontType]+OLED_FONTHEADERSIZE+(charBitmapStartPosition+i+(row*fontMapWidth)));
            for (j=0;j<8;j++) {         // 8 is the LCD's page height (see datasheet for explanation)
                if (temp & 0x1) {
                    oled_pixel1(x+i,y+j+(row*8), color, mode);
                }
                else {
                    oled_pixel1(x+i,y+j+(row*8), !color, mode);
                }
                temp >>=1;
            }
        }
    }

}

/** \brief Stop scrolling.

    Stop the scrolling of graphics on the OLED.
*/
void oled_scrollStop(void){
    oled_command(OLED_DEACTIVATESCROLL);
}

/** \brief Right scrolling.

Set row start to row stop on the OLED to scroll right. Refer to http://learn.microview.io/intro/general-overview-of-microview.html for explanation of the rows.
*/
void oled_scrollRight(uint8_t start, uint8_t stop){
    if (stop<start)     // stop must be larger or equal to start
    return;
    oled_scrollStop();       // need to disable scrolling before starting to avoid memory corrupt
    oled_command(OLED_RIGHTHORIZONTALSCROLL);
    oled_command(0x00);
    oled_command(start);
    oled_command(0x7);       // scroll speed frames
    oled_command(stop);
    oled_command(0x00);
    oled_command(0xFF);
    oled_command(OLED_ACTIVATESCROLL);
}

/** \brief Vertical flip.

Flip the graphics on the OLED vertically.
*/
void oled_flipVertical(uint8_t flip) {
    if (flip) {
        oled_command(OLED_COMSCANINC);
    }
    else {
        oled_command(OLED_COMSCANDEC);
    }
}

/** \brief Horizontal flip.

    Flip the graphics on the OLED horizontally.
*/
void oled_flipHorizontal(uint8_t flip) {
    if (flip) {
        oled_command(OLED_SEGREMAP | 0x0);
    }
    else {
        oled_command(OLED_SEGREMAP | 0x1);
    }
}

/*
    Return a pointer to the start of the RAM screen buffer for direct access.
*/
uint8_t *oled_getScreenBuffer(void) {
    return screenmemory;
}

/*
Draw Bitmap image on screen. The array for the bitmap can be stored in the Arduino file, so user don't have to mess with the library files.
To use, create uint8_t array that is 64x48 pixels (384 bytes). Then call .drawBitmap and pass it the array.
*/
void oled_drawBitmap(uint8_t * bitArray)
{
  for (int i=0; i<(OLED_LCDWIDTH * OLED_LCDHEIGHT / 8); i++)
    screenmemory[i] = bitArray[i];
}


void oled_draw_cube(void) {

  r[0] = r[0]+M_PI/180.0; // Add a degree
  r[1] = r[1]+M_PI/180.0; // Add a degree
  r[2] = r[2]+M_PI/180.0; // Add a degree

  if (r[0] >= 360.0*M_PI/180.0) r[0] = 0;
  if (r[1] >= 360.0*M_PI/180.0) r[1] = 0;
  if (r[2] >= 360.0*M_PI/180.0) r[2] = 0;

  for (int i=0;i<8;i++) {
    float px2 = px[i];
    float py2 = cos(r[0])*py[i] - sin(r[0])*pz[i];
    float pz2 = sin(r[0])*py[i] + cos(r[0])*pz[i];

    float px3 = cos(r[1])*px2 + sin(r[1])*pz2;
    float py3 = py2;
    float pz3 = -sin(r[1])*px2 + cos(r[1])*pz2;

    float ax = cos(r[2])*px3 - sin(r[2])*py3;
    float ay = sin(r[2])*px3 + cos(r[2])*py3;
    float az = pz3-150;

    p2x[i] = width/2+ax*SHAPE_SIZE/az;
    p2y[i] = height/2+ay*SHAPE_SIZE/az;
  }

  oled_clear(OLED_PAGE);
  for (uint8_t i=0;i<3;i++) {
    oled_line0(p2x[i],p2y[i],p2x[i+1],p2y[i+1]);
    oled_line0(p2x[i+4],p2y[i+4],p2x[i+5],p2y[i+5]);
    oled_line0(p2x[i],p2y[i],p2x[i+4],p2y[i+4]);
  }

  oled_line0(p2x[3],p2y[3],p2x[0],p2y[0]);
  oled_line0(p2x[7],p2y[7],p2x[4],p2y[4]);
  oled_line0(p2x[3],p2y[3],p2x[7],p2y[7]);
  oled_display();
}

