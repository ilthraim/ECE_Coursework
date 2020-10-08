#include <plib.h>
#include <xc.h>
#include <inttypes.h>
#include "outputCompare.h"
#include "tft_display.h"


void OC3Init(int dutyCycle) {
    PPSOutput(4, RPB10, OC3);
    OpenTimer3(T3_ON | T3_SOURCE_INT | T3_PS_1_1, 0xffff);
    OpenOC3(OC_ON | OC_TIMER_MODE16 | OC_TIMER3_SRC | OC_PWM_FAULT_PIN_DISABLE, dutyCycle, 0);
}

void OC3SetRPM(int RPM) {
    int DC;
    if (RPM <= 4400)
        DC = (RPM * 0xffff) / 4400;
    else
        DC = 0xffff;
    
    SetDCOC3PWM(DC);
    
}

unsigned int OC3GetRPM() {
    return(ReadDCOC3PWM());
}