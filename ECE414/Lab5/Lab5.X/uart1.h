#include <inttypes.h>

#ifndef UART1_H
#define	UART1_H

void uart1Init(int32_t baudrate);

uint8_t uart1_txrdy();

void uart1_txwrite(uint8_t c);

void uart1_txwrite_str(char *c);

uint8_t uart1_rxrdy();

uint8_t uart1_rxread();

#endif	/* UART1_H */

