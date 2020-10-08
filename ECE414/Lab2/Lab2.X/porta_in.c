#include <xc.h>
#include <inttypes.h>
#include "porta_in.h"

void porta_in_init() {
    ANSELA = 0;
    TRISA = 0x0003;
    CNPUA = 0x0003;
}

uint8_t porta_in_read() {
    return ~PORTA & 0x03;
}

