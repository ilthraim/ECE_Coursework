/* 
 * File:   lab11_p1_main.c
 * Author: millerek
 *
 * Created on November 29, 2018, 8:07 AM
 */

#include "ece212.h"

/*
 * 
 */
int main(int argc, char** argv) {
    
    ece212_setup();
    int leds;
    int dir;
    int btntemp;
    leds = 0x1;
    dir = 0;
    btntemp = 0;
    while(1) {
        
        if (!BTN11) {
            if (btntemp == 0)
                btntemp = 1;
        } else {
            if (btntemp) {
                if (dir)
                    dir = 0;
                else
                    dir = 1;
                
                btntemp = 0;
            }
        }
        delayms(100);
        
        writeLEDs(leds);
        if (dir) {
            if (leds == 0x1)
                leds = 0x8;
            else
                leds = leds >> 1;
        } else {
            if (leds == 0x8)
                leds = 0x1;
            else
                leds = leds << 1;
        }
    }
    
    return (EXIT_SUCCESS);
}

