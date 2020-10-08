#include <xc.h>
#include <inttypes.h>
#include "portb_out.h"

void portb_out_init() {
    ANSELB = 0;
    TRISB = 0;
}

void portb_out_write(uint16_t val) {
    LATB = ((val << 2) & 0xE000) + ((val << 1) & 0x0F80) + (val & 0x003F);
}
