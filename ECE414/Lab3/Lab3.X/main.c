#define _SUPPRESS_PLIB_WARNING
#include <plib.h>
#include <xc.h>
#include <inttypes.h>
#include "tft_gfx.h"
#include "tft_master.h"
#include "ts_tft.h"
#include "TouchScreen.h"
#include "calc_display.h"
#include "debouncer.h"
#include "calcSM.h"
#include "timer1.h"

#pragma config FNOSC = FRCPLL, POSCMOD = OFF
#pragma config FPLLIDIV = DIV_2, FPLLMUL = MUL_20 //40 MHz
#pragma config FPBDIV = DIV_1, FPLLODIV = DIV_2 // PB 40 MHz
#pragma config FWDTEN = OFF,  FSOSCEN = OFF, JTAGEN = OFF


void main() {
    uint16_t t1, t2;
    const uint16_t PERIOD = 50;
    
    timer1_init();
    tx_tft_init();
    draw_calc();
    
    t1 = timer1_read();
    
    while(1){
        t2 = timer1_read();
        if (timer1_ms_elapsed(t1, t2) >= PERIOD) {
            t1 = t2;
            debounceTick();
        }
        calcSMTick();
    }
}