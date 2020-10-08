#include <inttypes.h>

#ifndef TS_TFT_H
#define	TS_TFT_H



uint8_t ts_tft_get_ts(uint16_t *x, uint16_t *y);
void tx_tft_init();
void write_pos();
void debugWrite(char val[]);
char getTouch();

#endif

