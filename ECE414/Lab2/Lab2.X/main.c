#define _SUPPRESS_PLIB_WARNING
#include <xc.h>
#include <inttypes.h>
#include <plib.h>
#include "porta_in.h"
#include "portb_out.h"
#include "debouncer.h"
#include "synch_sm.h"

#pragma config FNOSC = FRCPLL, POSCMOD = OFF
#pragma config FPLLIDIV = DIV_2, FPLLMUL = MUL_20
#pragma config FPBDIV = DIV_1, FPLLODIV = DIV_2
#pragma config FWDTEN = OFF, JTAGEN = OFF, FSOSCEN = OFF

#pragma interrupt InterruptHandler ipl1 vector 0
void InterruptHandler(void)
{
    TickFct_Debouncer();
    TickFct_SynchSM();
    mT1ClearIntFlag();
    
}

main() {
    OpenTimer1(T1_PS_1_256|  T1_ON, 7812);
    BTN = 0;
    portb_out_init();
    porta_in_init();
    
    mT1SetIntPriority(1);
    INTEnableSystemSingleVectoredInt();
    mT1IntEnable(1);
    
    while (1);
}
