#include "debouncer.h"
#include "ts_tft.h"

enum debStates {debPushnt, debPerhapsPush, debPushed, debPerhapsPushnt} debState;

char temp0, temp1, sel;

void debounceTick() {
    
    switch (debState) {
        case debPushnt:
            if (temp0 = getTouch())
                debState = debPerhapsPush;
            else
                debState = debPushnt;
            break;
        
        case debPerhapsPush:
            if ((temp1 = getTouch()) == temp0) {
                debState = debPushed;
                sel = temp0;
            } else if (temp1) {
                temp0 = temp1;
                debState = debPerhapsPush;
            } else
                debState = debPushnt;
            break;
            
        case debPushed:
            if ((temp1 = getTouch()) == temp0) {
                debState = debPushed;
            } else if (temp1) {
                temp0 = temp1;
                debState = debPerhapsPush;
            } else
                debState = debPerhapsPushnt;
            break;
            
        case debPerhapsPushnt:
            if ((temp1 = getTouch()) == temp0) {
                debState = debPushed;
            } else if (temp1) {
                temp0 = temp1;
                debState = debPerhapsPush;
            } else
                debState = debPushnt;
            
        default:
            debState = debPushnt;
    }
}
