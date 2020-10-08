#include <xc.h>
#include <plib.h>

#define FREQ 40000000
#define SCALE 256

static uint16_t capture1, last_capture1, capture_period, max_period, min_period;

void IC1Init() {
    OpenTimer2(T2_ON | T2_SOURCE_INT | T2_PS_1_256, 0xffff);
    OpenCapture1(IC_ON | IC_TIMER2_SRC | IC_INT_1CAPTURE | IC_EVERY_RISE_EDGE);
    ConfigIntCapture1(IC_INT_ON | IC_INT_PRIOR_3 | IC_INT_SUB_PRIOR_3 );
    INTClearFlag(INT_IC1);
    PPSInput(3, IC1, RPA4);
    mPORTBSetPinsDigitalIn(BIT_4);
    capture1 = 0;
    last_capture1 = 0;
    capture_period = 0;
}

void __ISR(_INPUT_CAPTURE_1_VECTOR, ipl3) C1Handler(void) {
    capture1 = mIC1ReadCapture();
    capture_period = capture1 - last_capture1;
    // condition on last capture to avoid start up error
    if (capture_period > max_period && last_capture1 > 0) max_period = capture_period;
    if (capture_period < min_period && last_capture1 > 0) min_period = capture_period;
    last_capture1 = capture1;
    mIC1ClearIntFlag();
}

uint16_t getPeriod() {
    return capture_period;
}

uint32_t getRPM() {
    return (((uint32_t) (FREQ * 60) / SCALE)) / (uint32_t)(capture_period + 1);
}