/* 
 * File:   lab12_main.c
 * Author: millerek
 *
 * Created on November 29, 2018, 9:08 AM
 */

#include "ece212.h"
#define THRESHOLD 330
#define SPEED 0xFFFF

int main(int argc, char** argv) {

    ece212_lafbot_setup();
    int lSense;
    int rSense;
    while(1){
        
        lSense = analogRead(LEFT_SENSOR);
        rSense = analogRead(RIGHT_SENSOR);
        
        if ((lSense > THRESHOLD) && (rSense > THRESHOLD)) {
            RBACK = 0;
            RFORWARD = SPEED;
            LBACK = 0;
            LFORWARD = SPEED;
        } else if (lSense < THRESHOLD) {
            RBACK = 0;
            RFORWARD = 0;
            LBACK = 0;
            LFORWARD = SPEED;
        } else if (rSense < THRESHOLD) {
            RBACK = 0;
            RFORWARD = SPEED;
            LBACK = 0;
            LFORWARD = 0;
        } else {
            RBACK = SPEED;
            RFORWARD = 0;
            LBACK = SPEED;
            LFORWARD = 0;
        }
        
        //delayms(10);
        
    }
    
    return (EXIT_SUCCESS);
}

