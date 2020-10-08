#include <inttypes.h>
#include <stdio.h>
#include "calcSM.h"
#include "debouncer.h"

enum SMStates {SMInit, SMWait, SMNum1, SMOp, SMNum2, SMResult, SMErr} SMState;

int32_t out, n1, n2;
char op, sel;
char display[11];

void calcSMTick() { //TODO replace all display cases
    switch (SMState) {
        case SMInit:
            SMState = SMWait;
        break;
        
        case SMWait:
            sprintf(display, "%11d", 0);
            debugWrite(display);
            n1 = 0;
            n2 = 0;
            op = 0;
            if (sel) {
                if ((sel >= 48) && (sel <= 57)) {
                    n1 = sel - 48;
                    sprintf(display, "%11d", n1);
                    debugWrite(display);
                    SMState = SMNum1;
                    sel = 0;
                }
            }
            else
                SMState = SMWait;
        break;
        
        case SMNum1:
            
            if (sel) {
                if ((sel >= 48) && (sel <= 57)) {
                    if (n1 > 214748364) {
                        SMState = SMErr;
                        sprintf(display, "ERROR");
                        debugWrite(display);
                    }
                    else {
                        n1 = (n1 * 10) + (sel - 48);
                        sprintf(display, "%11d", n1);

                        debugWrite(display);
                    }
                }
                else if (sel == 'c')
                    SMState = SMWait;
                else {
                    op = sel;
                    SMState = SMOp;
                    sprintf(display, "%11c", op);
                    debugWrite(display);
                }
                sel = 0;
            }
            else
                SMState = SMNum1;
        break;
        
        case SMOp:
           

            if (sel) {
                if ((sel >= 48) && (sel <= 57)) {
                    n2 = sel - 48;
                    SMState = SMNum2;
                    sprintf(display, "%11d", n2);
                    debugWrite(display);
                    sel = 0;
                }
                else if (sel == 'c')
                    SMState = SMWait;
                else {
                    op = sel;
                    SMState = SMOp;
                }
                sel = 0;
            }
            else
                SMState = SMOp;
            
            break;
            
        case SMNum2:
            
            if (sel) {
                if ((sel >= 48) && (sel <= 57)) {
                    if (n2 > 214748364) {
                        SMState = SMErr;
                        sprintf(display, "ERROR");
                        debugWrite(display);
                    }
                    else {
                        n2 = (n2 * 10) + (sel - 48);
                        sprintf(display, "%11d", n2);
                        debugWrite(display);
                    }
                }
                else if (sel == 'c')
                    SMState = SMWait;
                else if (sel != '=') { //TODO add op code
                    
                    SMState = SMOp;
                    if (op == '+') {
                        n1 = n1 + n2;
                        sprintf(display, "%11d", n1);
                        debugWrite(display);
                        if (n1 < 0) {
                            SMState = SMErr;
                            sprintf(display, "ERROR");
                            debugWrite(display);
                        }
                       
                    }
                    else if (op == '-') {
                        n1 = n1 - n2;
                        sprintf(display, "%11d", n1);
                        debugWrite(display);
                    }
                    else if (op == 'x') {
                        if (n1 > (2147483647 / n2)) {
                            SMState = SMErr;
                            sprintf(display, "ERROR");
                            debugWrite(display);
                        }
                        
                        else {
                            n1 = n1 * n2;
                            sprintf(display, "%11d", n1);
                            debugWrite(display);
                        }
                    
                    }
                    else {
                        if (n2) {
                            n1 = n1 / n2;
                            sprintf(display, "%11d", n1);
                            debugWrite(display);
                        }
                        else {
                            SMState = SMErr;
                            sprintf(display, "DIV0");
                            debugWrite(display);
                        }
                    }
                    op = sel;
                }
                else {
                    SMState = SMResult;
                    if (op == '+') {
                        out = n1 + n2;
                        sprintf(display, "%11d", out);
                        debugWrite(display);
                        if (out < 0) {
                            SMState = SMErr;
                            sprintf(display, "ERROR");
                            debugWrite(display);
                        }
                    }
                    else if (op == '-') {
                        out = n1 - n2;
                        sprintf(display, "%11d", out);
                        debugWrite(display);
                    }
                    else if (op == 'x') {
                        if (n1 > (2147483647 / n2)){
                            SMState = SMErr;
                            sprintf(display, "ERROR");
                            debugWrite(display);
                        }
                        else {
                            out = n1 * n2;
                            sprintf(display, "%11d", out);
                            debugWrite(display);
                        }
                    }
                    else {
                        if (n2) {
                            out = n1 / n2;
                            sprintf(display, "%11d", out);
                            debugWrite(display);
                        }
                        else {
                            SMState = SMErr;
                            sprintf(display, "DIV0");
                            debugWrite(display);
                        }
                    }
                    
                         
                }
                sel = 0;
            }
            else
                SMState = SMNum2;
            
            break;
               
                
            
            
        case SMResult:
            
            if (sel) {
                if (sel == 'c')
                    SMState = SMWait;
                else {
                    SMState = SMResult;
                    
                }
                sel = 0;
            }
            else
                SMState = SMResult;
            break;
            
        case SMErr:
            if (sel) {
                if (sel == 'c')
                    SMState = SMWait;
                else {
                    SMState = SMErr;
                }
                sel = 0;
            }
            else
                SMState = SMErr;
            break;
        
        default: SMState = SMInit;
    }
    
    
    
}
