#ifndef ZTIMER2_H
#define	ZTIMER2_H
#include <inttypes.h>

// initialize timer to set a flag every given period (in ms)
extern void zTimerSet(uint32_t period);

extern void zTimerSet2(uint32_t period);

// enable the timer and turn on the interrupt
extern void zTimerOn();

// read and return the timer flag value
// SIDE EFFECT: clear the flag
extern uint8_t zReadTimerFlag();

uint32_t zTimerReadms();

#endif	/* ZTIMER_H */

