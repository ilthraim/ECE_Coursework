#include <inttypes.h>
#include <string.h>
#include "tft_gfx.h"
#include "tft_master.h"
#include "tft_display.h"
#include "TouchScreen.h"
#include "adc_intf.h"
#include "PID.h"

static char debugChar[50];
static char RPMString[8];
static int pos;
static int prevDC;

void debugWrite(char val[]) {
    tft_setCursor(20, 20);
    tft_setTextSize(2);
    tft_setTextColor(ILI9341_BLACK);
    tft_writeString(debugChar);
    tft_setCursor(20, 20);
    tft_setTextSize(2);
    tft_setTextColor(ILI9341_WHITE);
    tft_writeString(val);
    strncpy(debugChar, val, 50);
    
    delay_ms(100);
}

//320 x 240
void tx_tft_init() {
    SYSTEMConfigPerformance(PBCLK);
    
    configureADC();
    tft_init_hw();
    tft_begin();
    tft_setRotation(3); 
    tft_fillScreen(ILI9341_BLACK);
    tft_drawLine(40, 40, 40, 220, ILI9341_WHITE);
    tft_drawLine(40, 130, 317, 130, ILI9341_WHITE);
    tft_drawLine(317, 40, 317, 220, ILI9341_ORANGE);
    sprintf(RPMString, "0");
    pos = 0;
}

void writeRPM(int RPM) {
    tft_setCursor(0, 130);
    tft_setTextSize(1);
    tft_setTextColor(ILI9341_BLACK);
    tft_writeString(RPMString);
    sprintf(RPMString, "%i", RPM);
    if (RPM == 1)
        sprintf(RPMString, "%i", 0);
    tft_setCursor(0, 130);
    tft_setTextSize(1);
    tft_setTextColor(ILI9341_WHITE);
    tft_writeString(RPMString);
}

void TXPlot() {
    
    if (pos == 10) {
        clearPlot();
    }
    else {
        char numBuf[8];
        int desired = (int) getDesired();
        int actual = getRPM();
        int x = 40 + pos * 28;
        int yr = 220 - (90 * actual) / desired;
        int y = (yr < 45) ? 45 : yr;
        if (pos == 0) {
            int curDC = (int) OC3GetRPM();
            prevDC = 220 - (curDC * 180) / 0xffff;
        }
        else {
            int curDC = (int) OC3GetRPM();
            int yDC = 220 - (curDC * 180) / 0xffff;
            tft_drawLine(40 + (pos - 1) * 28, yDC, 40 + pos * 28, yDC, ILI9341_ORANGE);
            tft_drawLine(40 + (pos - 1) * 28, prevDC, 40 + (pos - 1) * 28, yDC, ILI9341_ORANGE);
            prevDC = yDC;
        }
        tft_drawCircle(x, y, 2, ILI9341_WHITE);
        tft_setCursor(x, y + 5);
        tft_setTextSize(1);
        tft_setTextColor(ILI9341_WHITE);
        sprintf(numBuf, "%i", actual);
        tft_writeString(numBuf);
        pos++;
    }
}

void clearPlot() {
    tft_fillRect(35, 40, 317, 220, ILI9341_BLACK);
    tft_drawLine(40, 40, 40, 220, ILI9341_WHITE);
    tft_drawLine(40, 130, 317, 130, ILI9341_WHITE);
    tft_drawLine(317, 40, 317, 220, ILI9341_ORANGE);
    pos = 0;
}
