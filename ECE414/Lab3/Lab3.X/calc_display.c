#define _SUPPRESS_PLIB_WARNING
#define XOFF 2
#define WIDTH 75
#define YBASE 45
#define YOFF 2
#define HEIGHT 45
#include "calc_display.h"
#include "tft_master.h"

void draw_calc() {
    tft_fillScreen(ILI9341_BLACK);
    tft_setTextSize(2);
    tft_setTextColor(ILI9341_BLACK);
    
    int x, y;
    short color;
    char btnNum;
    for (x = 0; x < 4; x++) {
        for (y = 0; y < 4; y++) {
            if (x == 3)
                color = ILI9341_ORANGE;
            else if (y == 3) {
                if (x == 1)
                    color = ILI9341_RED;
                else if (x == 2)
                    color = ILI9341_BLUE;
            } else
                color = ILI9341_WHITE;
            
            switch (x)
            {
                case 0:
                    switch (y) {
                        case 0: btnNum = '7';
                            break;
                        case 1: btnNum = '4';
                            break;
                        case 2: btnNum = '1';
                            break;
                        case 3: btnNum = '0';
                            break;
                        default: btnNum = 'n';
                    }
                    break;
                case 1:
                    switch (y) {
                        case 0: btnNum = '8';
                            break;
                        case 1: btnNum = '5';
                            break;
                        case 2: btnNum = '2';
                            break;
                        case 3: btnNum = 'C';
                            break;
                        default: btnNum = 'n';
                    }
                    break;
                case 2:
                    switch (y) {
                        case 0: btnNum = '9';
                            break;
                        case 1: btnNum = '6';
                            break;
                        case 2: btnNum = '3';
                            break;
                        case 3: btnNum = '=';
                            break;
                        default: btnNum = 'n';
                    }
                    break;
                case 3:
                    switch (y) {
                        case 0: btnNum = '+';
                            break;
                        case 1: btnNum = '-';
                            break;
                        case 2: btnNum = 'x';
                            break;
                        case 3: btnNum = '/';
                            break;
                        default: btnNum = 'n';
                    }
                    break;
                default: btnNum = 'n';
            }
            
            tft_setCursor(XOFF * (x + 1) + WIDTH * x + 33, YOFF * (y + 1) + HEIGHT * y + YBASE + 17);
            tft_fillRoundRect(XOFF * (x + 1) + WIDTH * x, YOFF * (y + 1) + HEIGHT * y + YBASE, WIDTH, HEIGHT, 10, color);
            tft_write(btnNum);
        }
    }
}
