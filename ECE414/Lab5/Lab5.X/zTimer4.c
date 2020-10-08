#include <xc.h>
#include <plib.h>
#include "zTimer4.h"
#include "PID.h"
#include "tft_display.h"

static uint32_t count, count2, epochCount;
static uint32_t period, period2, targetCount;

static uint8_t zTimerFlag = 0;

void __ISR(_TIMER_4_VECTOR, ipl1) T4Handler(void) {
    count++;
    count2++;
    epochCount++;
    if (count == period) {
        zTimerFlag = 1;
        count = 0;
        PIDTick();
    }
    if (count2 == period2) {
        count2 = 0;
        TXPlot();
    }
    mT4ClearIntFlag();
}

// initialize timer to set a flag every given period (in ms)
void zTimerSet(uint32_t pdms) {
    period = pdms;
}

void zTimerSet2(uint32_t pdms) {
    period2 = pdms;
}

// enable the timer and turn on the interrupt
void zTimerOn() {
    // 1. initialize timer
    PR4 = 4999;      // Timer4 periodic reset every 5000 ticks (1ms)
    T4CON = 0x8030;  // Timer4 scaling factor of 8 (200ns)
    TMR4 = 0;        // start out at 0
    epochCount = 0;
    // 2. initialize interrupts
    mT4SetIntPriority(1);
    mT4IntEnable(1); 
}

void zTimerOff() {
    mT4IntEnable(0); 
    T4CON = 0x0;  // turn off timer
}

// read and return the timer flag value
// SIDE EFFECT: clear the flag
uint8_t zReadTimerFlag() {
    if (zTimerFlag) {
        zTimerFlag = 0;
        return 1;
    } else return 0; 
}

uint32_t zTimerReadms() {
    return epochCount;
}
