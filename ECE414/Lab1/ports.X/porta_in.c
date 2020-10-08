#include <xc.h>
#include <inttypes.h>
#include "porta_in.h"

void porta_in_init() {
    ANSELA = 0;
    TRISA = 0x001F;
    CNPUA = 0x001F;
}

uint8_t porta_in_read() {
    return PORTA;
}
