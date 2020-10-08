#include <xc.h>
#include <inttypes.h>
#include "portb_out.h"

#pragma config FNOSC = FRCPLL, POSCMOD = OFF
#pragma config FPLLIDIV = DIV_2, FPLLMUL = MUL_20
#pragma config FPBDIV = DIV_1, FPLLODIV = DIV_2
#pragma config FWDTEN = OFF, JTAGEN = OFF, FSOSCEN = OFF

void main() {
    uint16_t val;
    uint16_t retVal;
    uint16_t mask;
    
    porta_in_init();
    portb_out_init();
    
    
    while (1) {
        val = porta_in_read();
        
        mask = 0x0001;
        mask = mask << (val & 0xF);
        retVal = (val & 0x0010) ?  ~mask : mask;

        portb_out_write(retVal);
git   }
}