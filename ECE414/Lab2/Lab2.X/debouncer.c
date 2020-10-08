#include <xc.h>
#include <inttypes.h>
#include "debouncer.h"
#include "porta_in.h"
#include "portb_out.h"

enum Deb_States {Deb_Pushnt, Deb_PerhapsPush, Deb_Pushed, Deb_PerhapsPushnt} Deb_State;

unsigned char BTN;

void TickFct_Debouncer() {
    
    switch (Deb_State) {
        case Deb_Pushnt:
            if (porta_in_read())
                Deb_State = Deb_PerhapsPush;
            else
                Deb_State = Deb_Pushnt;
            break;
            
        case Deb_PerhapsPush:
            if (porta_in_read()) {
                Deb_State = Deb_Pushed;
                BTN = porta_in_read();
            }
            else
                Deb_State = Deb_Pushnt;
            break;
            
        case Deb_Pushed:
            if (porta_in_read()) {
                Deb_State = Deb_Pushed;
            }
            else
                Deb_State = Deb_PerhapsPushnt;
            break;
        
        case Deb_PerhapsPushnt:
            if (porta_in_read())
                Deb_State = Deb_Pushed;
            else
                Deb_State = Deb_Pushnt;
            break;
            
        default:
            Deb_State = Deb_Pushnt;
            
    }
}
