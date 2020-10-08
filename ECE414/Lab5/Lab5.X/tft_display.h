#include <inttypes.h>

#ifndef TS_TFT_H
#define	TS_TFT_H

void tx_tft_init();
void debugWrite(char val[]);
void writeRPM(int RPM);
void TXPlot();
void clearPlot();

#endif

