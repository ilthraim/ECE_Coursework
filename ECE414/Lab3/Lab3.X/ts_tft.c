#define _SUPPRESS_PLIB_WARNING
#include <inttypes.h>
#include <string.h>
#include "tft_gfx.h"
#include "tft_master.h"
#include "ts_tft.h"
#include "TouchScreen.h"

char buffer[30];
uint16_t xo, yo, xl, yl;
char debugChar[11];

uint8_t ts_tft_get_ts(uint16_t *x, uint16_t *y) {
    uint32_t interp_x, interp_y; //x 150 880 y 90 940
    
    struct TSPoint p;
    getPoint(&p);
    
    interp_x = (p.y - 90) * (320) / (940 - 90); //actual x = 320 y = 240
    interp_x = 320 - interp_x;
    interp_y = (p.x - 150) * 240 / (880 - 150);
    *x = interp_x;
    *y = interp_y;
    
    return (p.z >= 100);
}

void write_pos() {

    if (ts_tft_get_ts(&xo, &yo))
    {
        tft_setCursor(20, 120);
        tft_setTextSize(2);

        //erase old text
        tft_setTextColor(ILI9341_BLACK);
        tft_writeString(buffer);
        
        tft_drawLine(xl - 5, yl, xl + 5, yl, ILI9341_BLACK);
        tft_drawLine(xl, yl - 5, xl, yl + 5, ILI9341_BLACK);
    
        tft_setTextColor(ILI9341_WHITE); 
        tft_setTextSize(2);
        tft_setCursor(20, 120);
        sprintf(buffer, "x: %d, y: %d", xo, yo);
        tft_writeString(buffer);
        tft_drawLine(xo - 5, yo, xo + 5, yo, ILI9341_WHITE);
        tft_drawLine(xo, yo - 5, xo, yo + 5, ILI9341_WHITE);
        xl = xo;
        yl = yo;
    }

    delay_ms(100);
}
void debugWrite(char val[]) {
    tft_setCursor(20, 20);
    tft_setTextSize(2);
    tft_setTextColor(ILI9341_BLACK);
    tft_writeString(debugChar);
    tft_setCursor(20, 20);
    tft_setTextSize(2);
    tft_setTextColor(ILI9341_WHITE);
    tft_writeString(val);
    strncpy(debugChar, val, 11);
    
    delay_ms(100);
}

void tx_tft_init() {
    SYSTEMConfigPerformance(PBCLK);
    
    configureADC();
    tft_init_hw();
    tft_begin();
    tft_setRotation(3); 
    tft_fillScreen(ILI9341_BLACK);  
    
}

char getTouch() { //C = 11, = = 12, / = 13, x = 14, - = 15, + = 16
    uint16_t x, y, val;
    char ret;
    
    if (ts_tft_get_ts(&x, &y)) {
       val =  (((y / 47) * 4) + (x / 77));
       switch(val) {
           case 4: ret = '7'; break;
           case 5: ret = '8'; break;
           case 6: ret = '9'; break;
           case 7: ret = '+'; break;
           case 8: ret = '4'; break;
           case 9: ret = '5'; break;
           case 10: ret = '6'; break;
           case 11: ret = '-'; break;
           case 12: ret = '1'; break;
           case 13: ret = '2'; break;
           case 14: ret = '3'; break;
           case 15: ret = 'x'; break;
           case 16: ret = '0'; break;
           case 17: ret = 'c'; break;
           case 18: ret = '='; break;
           case 19: ret = '/'; break;
           default: ret = 0;
       }
       return ret;
    }
    else return 0;
}
