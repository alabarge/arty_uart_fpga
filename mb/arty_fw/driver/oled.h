#pragma once

#define swap(a, b) { uint8_t t = a; a = b; b = t; }

// uoled data register
typedef union _oled_dat_reg_t {
   struct {
      uint32_t sck            : 1;
      uint32_t mosi           : 1;
      uint32_t ss             : 1;
      uint32_t rst            : 1;
      uint32_t dc             : 1;
      uint32_t                : 27;
   } b;
   uint32_t i;
} oled_dat_reg_t, *poled_dat_reg_t;

// all registers
typedef struct _oled_regs_t {
   uint32_t       dat;
   uint32_t       tri;
} oled_regs_t, *poled_regs_t;

#define bit(b) (1UL << (b))

#define OLED_BLACK            0
#define OLED_WHITE            1

#define OLED_LCDWIDTH         64
#define OLED_LCDHEIGHT        48
#define OLED_FONTHEADERSIZE   6

#define OLED_NORM             0
#define OLED_XOR              1

#define OLED_PAGE             0
#define OLED_ALL              1

#define OLED_WIDGETSTYLE0     0
#define OLED_WIDGETSTYLE1     1
#define OLED_WIDGETSTYLE2     2

#define OLED_SETCONTRAST         0x81
#define OLED_DISPLAYALLONRESUME  0xA4
#define OLED_DISPLAYALLON        0xA5
#define OLED_NORMALDISPLAY       0xA6
#define OLED_INVERTDISPLAY       0xA7
#define OLED_DISPLAYOFF          0xAE
#define OLED_DISPLAYON           0xAF
#define OLED_SETDISPLAYOFFSET    0xD3
#define OLED_SETCOMPINS          0xDA
#define OLED_SETVCOMDESELECT     0xDB
#define OLED_SETDISPLAYCLOCKDIV  0xD5
#define OLED_SETPRECHARGE        0xD9
#define OLED_SETMULTIPLEX        0xA8
#define OLED_SETLOWCOLUMN        0x00
#define OLED_SETHIGHCOLUMN       0x10
#define OLED_SETSTARTLINE        0x40
#define OLED_MEMORYMODE          0x20
#define OLED_COMSCANINC          0xC0
#define OLED_COMSCANDEC          0xC8
#define OLED_SEGREMAP            0xA0
#define OLED_CHARGEPUMP          0x8D
#define OLED_EXTERNALVCC         0x01
#define OLED_SWITCHCAPVCC        0x02

// Scroll
#define OLED_ACTIVATESCROLL                 0x2F
#define OLED_DEACTIVATESCROLL               0x2E
#define OLED_SETVERTICALSCROLLAREA          0xA3
#define OLED_RIGHTHORIZONTALSCROLL          0x26
#define OLED_LEFT_HORIZONTALSCROLL          0x27
#define OLED_VERTICALRIGHTHORIZONTALSCROLL  0x29
#define OLED_VERTICALLEFTHORIZONTALSCROLL   0x2A


#define OLED_CMD_CLEAR          0x00
#define OLED_CMD_INVERT         0x01
#define OLED_CMD_CONTRAST       0x02
#define OLED_CMD_DISPLAY        0x03
#define OLED_CMD_SETCURSOR      0x04
#define OLED_CMD_PIXEL          0x05
#define OLED_CMD_LINE           0x06
#define OLED_CMD_LINEH          0x07
#define OLED_CMD_LINEV          0x08
#define OLED_CMD_RECT           0x09
#define OLED_CMD_RECTFILL       0x0A
#define OLED_CMD_CIRCLE         0x0B
#define OLED_CMD_CIRCLEFILL     0x0C
#define OLED_CMD_DRAWCHAR       0x0D
#define OLED_CMD_DRAWBITMAP     0x0E
#define OLED_CMD_GETLCDWIDTH    0x0F
#define OLED_CMD_GETLCDHEIGHT   0x10
#define OLED_CMD_SETCOLOR       0x11
#define OLED_CMD_SETDRAWMODE    0x12

uint32_t oled_init(void);
uint8_t  oled_write(uint8_t c);

void     oled_command(uint8_t c);
void     oled_data(uint8_t c);
void     oled_setColumnAddress(uint8_t add);
void     oled_setPageAddress(uint8_t add);

void     oled_clear(uint8_t mode);
void     oled_invert(uint8_t inv);
void     oled_contrast(uint8_t contrast);
void     oled_display(void);
uint8_t  oled_write(uint8_t c);
void     oled_print(char *str);
void     oled_setCursor(uint8_t x, uint8_t y);
void     oled_pixel0(uint8_t x, uint8_t y);
void     oled_pixel1(uint8_t x, uint8_t y, uint8_t color, uint8_t mode);
void     oled_line0(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1);
void     oled_line1(uint8_t x0, uint8_t y0, uint8_t x1, uint8_t y1, uint8_t color, uint8_t mode);
void     oled_lineH0(uint8_t x, uint8_t y, uint8_t width);
void     oled_lineH1(uint8_t x, uint8_t y, uint8_t width, uint8_t color, uint8_t mode);
void     oled_lineV0(uint8_t x, uint8_t y, uint8_t height);
void     oled_lineV1(uint8_t x, uint8_t y, uint8_t height, uint8_t color, uint8_t mode);
void     oled_rect0(uint8_t x, uint8_t y, uint8_t width, uint8_t height);
void     oled_rect1(uint8_t x, uint8_t y, uint8_t width, uint8_t height, uint8_t color , uint8_t mode);
void     oled_rectFill0(uint8_t x, uint8_t y, uint8_t width, uint8_t height);
void     oled_rectFill1(uint8_t x, uint8_t y, uint8_t width, uint8_t height, uint8_t color , uint8_t mode);
void     oled_circle0(uint8_t x, uint8_t y, uint8_t radius);
void     oled_circle1(uint8_t x, uint8_t y, uint8_t radius, uint8_t color, uint8_t mode);
void     oled_circleFill0(uint8_t x0, uint8_t y0, uint8_t radius);
void     oled_circleFill1(uint8_t x0, uint8_t y0, uint8_t radius, uint8_t color, uint8_t mode);
void     oled_drawChar0(uint8_t x, uint8_t y, uint8_t c);
void     oled_drawChar1(uint8_t x, uint8_t y, uint8_t c, uint8_t color, uint8_t mode);
void     oled_drawBitmap(uint8_t * bitArray);
uint8_t  oled_getLCDWidth(void);
uint8_t  oled_getLCDHeight(void);
void     oled_setColor(uint8_t color);
void     oled_setDrawMode(uint8_t mode);
uint8_t* oled_getScreenBuffer(void);

uint8_t  oled_getFontWidth(void);
uint8_t  oled_getFontHeight(void);
uint8_t  oled_getTotalFonts(void);
uint8_t  oled_getFontType(void);
uint8_t  oled_setFontType(uint8_t type);
uint8_t  oled_getFontStartChar(void);
uint8_t  oled_getFontTotalChar(void);

void     oled_scrollRight(uint8_t start, uint8_t stop);
void     oled_scrollLeft(uint8_t start, uint8_t stop);
void     oled_scrollVertRight(uint8_t start, uint8_t stop);
void     oled_scrollVertLeft(uint8_t start, uint8_t stop);
void     oled_scrollStop(void);
void     oled_flipVertical(uint8_t flip);
void     oled_flipHorizontal(uint8_t flip);

void     oled_draw_cube(void);
