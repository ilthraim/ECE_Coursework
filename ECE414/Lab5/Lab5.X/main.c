#include <plib.h>
#include <xc.h>
#include <stdio.h>
#include <stdlib.h>
#include "outputCompare.h"
#include "inputCapture.h"
#include "tft_display.h"
#include "zTimer4.h"

#pragma config FNOSC = FRCPLL, POSCMOD = OFF
#pragma config FPLLIDIV = DIV_2, FPLLMUL = MUL_20 //40 MHz
#pragma config FPBDIV = DIV_1, FPLLODIV = DIV_2 // PB 40 MHz
#pragma config FWDTEN = OFF,  FSOSCEN = OFF, JTAGEN = OFF

void main() {
    OC3Init(0x8000);
    IC1Init();
    tx_tft_init();
    setDesired((float) 2000);
    writeRPM(2000);
    uart1Init(9600);
    zTimerOn();
    zTimerSet(20);
    zTimerSet2(250);
    
    INTEnableSystemMultiVectoredInt();
    while(1);
    
        
}