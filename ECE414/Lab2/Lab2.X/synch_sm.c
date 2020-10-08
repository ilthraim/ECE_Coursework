#include <xc.h>
#include <inttypes.h>
#include "debouncer.h"
#include "synch_sm.h"
#include "portb_out.h"

enum SM_States {SM_Init, SM_Wait, SM_LED1_7, SM_LED8, SM_Hit, SM_Miss} SM_State;

uint8_t delay;
uint8_t delayCount;
uint8_t L_or_R; //L = 0, R = 1
uint8_t LED_out;
uint8_t blink;

unsigned char BTN;

void writeLEDs() {
    if (L_or_R) {
        portb_out_write(LED_out);
    }
    else {
        uint8_t rev_out, temp;
        rev_out = 0;
        int i;
        for (i = 0; i < 8; i++) {
            temp = (LED_out & (1 << i));
            if (temp)
                rev_out |= (1 << (7 - i));
        }
        portb_out_write(rev_out);
           
        
    }
    
    
    
    
        
}

void TickFct_SynchSM(){
    
    switch (SM_State) {
        case SM_Init:
            delay = 6;
            delayCount = 1;
            L_or_R = (rand() % 2);
            LED_out = 0x01;
            SM_State = SM_Wait;
            break;
            
        case SM_Wait:
            if ((BTN >> L_or_R) & 0x01) {
                SM_State = SM_LED1_7;
                delayCount = 1;
                BTN = 0;
            }
            else {
                SM_State = SM_Wait;
            }
            break;
        
        case SM_LED1_7:
            
            if (BTN)
            {
                SM_State = SM_Miss;
                BTN = 0;
                blink = 0;
                L_or_R = (L_or_R) ? 0 : 1;
            }
            else if ((LED_out <= 0x40) && (delayCount >= delay))
            {
                SM_State = SM_LED1_7;
                LED_out = LED_out << 1;
                delayCount = 1;
                BTN = 0;
            }
            else if ((LED_out <= 0x40) && (delayCount < delay)) {
                SM_State = SM_LED1_7;
                delayCount = delayCount + 1;
                BTN = 0;
                
            }
            else {
                SM_State = SM_LED8;
                BTN = 0;
                delayCount = 1;
            }
            
            break;
            
        case SM_LED8:
            if ((delayCount < delay) && !BTN) {
                delayCount = delayCount + 1;
                SM_State = SM_LED8;
            }
            else if ((delayCount >= delay) && !BTN) {
                SM_State = SM_Miss;
                blink = 0;
            }
            else if (!((BTN >> L_or_R) & 0x01))
                SM_State = SM_Hit;
            else {
                SM_State = SM_Miss;
                BTN = 0;
                blink = 0;
                L_or_R = (L_or_R) ? 0 : 1;
            }
            break;
            
        case SM_Hit:
            if (delay >= 1)
                delay = delay - 1;
            L_or_R = (L_or_R) ? 0 : 1;
            LED_out = 0x01;
            SM_State = SM_LED1_7;
            BTN = 0;
            break;
            
        case SM_Miss:
            BTN = 0;
            if (blink < 7) {
                if ((blink % 2) == 0)
                    LED_out = 0x01;
                else
                    LED_out = 0;
                blink = blink + 1;
                SM_State  = SM_Miss;
            }
            else {
                SM_State = SM_Init;
            }
            break;
        default:
            SM_State = SM_Init;
            
    }
    
    writeLEDs();
    
}


