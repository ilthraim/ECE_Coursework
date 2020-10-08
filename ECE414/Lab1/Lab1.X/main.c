/*=========================================================
* main.c
* My first PIC32 program.
*
* Author: John Nestor
*====================================================================*/
/* Clock configuration */
#pragma config FNOSC = FRCPLL, POSCMOD = OFF
#pragma config FPLLIDIV = DIV_2, FPLLMUL = MUL_20
#pragma config FPBDIV = DIV_1, FPLLODIV = DIV_2
#pragma config FWDTEN = OFF, JTAGEN = OFF, FSOSCEN = OFF
#include <xc.h>
#include <inttypes.h>
void main()
{
 uint8_t count;
 /* Set up PORTA pins as outputs. */
 ANSELA = 0;
 TRISA = 0;
 /* Simple counter. */
 count = 0;
 while (1) {
 LATA = count & 7; // output bottom 3 bits
 count++;
 }
}
