/* 
 * File:   PID.h
 * Author: millerek
 *
 * Created on October 29, 2019, 9:44 AM
 */

#ifndef PID_H
#define	PID_H

void PIDTick();

void setKP(float kpn);

void setKI(float kin);

void setKD(float kdn);

void setDesired(float desiredn);

float getDesired();

#endif	/* PID_H */

