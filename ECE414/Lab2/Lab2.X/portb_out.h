#include <xc.h>
#include <inttypes.h>

#ifndef PORTB_OUT_H
#define	PORTB_OUT_H

extern void portb_out_init();

extern void portb_out_write(uint16_t val);

#endif

