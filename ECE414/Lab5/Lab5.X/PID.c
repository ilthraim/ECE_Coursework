#include <plib.h>
#include <xc.h>
#include "inputCapture.h"
#include "tft_display.h"
#include <stdio.h>

enum PIDStates {SMInit, SMCTRL} PIDState;

static float actuator, actualPrev, error, desired, deriv, integ = 0, integMax = 10000, integMin = -10000,
        kp = 120, ki = 3, kd = 20, actual; //i = 5 for bigger stuff

void PIDTick() {
    switch(PIDState) {
        case SMInit:
            actuator = 0;
            actualPrev = 0;
            PIDState = SMCTRL;
            break;
        case SMCTRL:
            actual = getRPM();
            error = desired - actual;
            deriv = actual - actualPrev;
            
            integ = integ + error;
            if (integ > integMax) 
                integ = integMax;
            else if (integ < integMin)
                integ = integMin;
            
            actuator = kp * error + ki * integ - kd * deriv;
            if (actuator > 0xffff)
                actuator = 0xffff;
            else if (actuator < 5000)
                actuator = 5000;
            
            if (desired == 1)
                actuator = 0;
            
            SetDCOC3PWM((int) actuator);
            actualPrev = actual;
            break;
    }
}

void setKP(float kpn) {
    kp = kpn;
}

void setKI(float kin) {
    ki = kin;
}

void setKD(float kdn) {
    kd = kdn;
}

void setDesired(float desiredn) {
    desired = desiredn;
    writeRPM((int) desiredn);
}

float getDesired() {
    return desired;
}