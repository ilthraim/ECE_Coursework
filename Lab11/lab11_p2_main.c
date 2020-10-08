/* 
 * File:   lab11_p2_main.c
 * Author: millerek
 *
 * Created on November 29, 2018, 8:58 AM
 */

#include "ece212.h"

/*
 * 
 */
int main(int argc, char** argv) {

    ece212_lafbot_setup();
    
    while(1) {
        RFORWARD = 0x7FFF;
        RBACK = 0;
        LFORWARD = 0x7FFF;
        LBACK = 0;
        
        delayms(500);
        
        RFORWARD = 0;
        RBACK = 0;
        LFORWARD = 0;
        LBACK = 0;
        
        delayms(1000);
        
        RFORWARD = 0;
        RBACK = 0x7FFF;
        LFORWARD = 0;
        LBACK = 0x7FFF;
        
        delayms(500);
        
        RFORWARD = 0;
        RBACK = 0;
        LFORWARD = 0;
        LBACK = 0;
        delayms(1000);
    }
    
    return (EXIT_SUCCESS);
}

