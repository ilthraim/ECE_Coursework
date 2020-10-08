#include <inttypes.h>
#include <xc.h>
#include <plib.h>
#include <string.h>
#include <stdio.h>
#include "tft_display.h"
#include "PID.h"
#include "outputCompare.h"

static char buf[50];
static int x = 0;

void uart1Init(int32_t baudrate) {
    U1RXR = 0x0; //input pin to RPA2 - pin 9
    mPORTASetPinsDigitalOut(BIT_0);
    
    OpenUART1(UART_EN | UART_NO_PAR_8BIT | UART_1STOPBIT | UART_IRDA_DIS | UART_MODE_SIMPLEX
            | UART_DIS_BCLK_CTS_RTS | UART_BRGH_SIXTEEN, UART_RX_ENABLE |  UART_INT_RX_CHAR,
            40000000 / (16 * baudrate) - 1);
    INTEnable(INT_SOURCE_UART_RX(UART1), INT_ENABLED);
    INTSetVectorPriority(INT_VECTOR_UART(UART1), INT_PRIORITY_LEVEL_2);
    INTSetVectorSubPriority(INT_VECTOR_UART(UART1), INT_SUB_PRIORITY_LEVEL_2);
    
    INTClearFlag(INT_U1RX);
}

void __ISR(_UART_1_VECTOR, ipl2) U1RXHandler(void) {
    char doubleBuf;
    while(DataRdyUART1()){
        if ((doubleBuf = ReadUART1()) != '\r')
            buf[x++] = doubleBuf;
        else {
            float val;
            char cmd;
            char writeBuf[20];
            sscanf(buf, "%c %f", &cmd, &val);
            if (cmd == 's') {
                int RPM = (int) val;
                sprintf(writeBuf, "Wrote %i to RPM", (RPM >= 4400) ? 4400 : RPM);
                if (RPM == 0)
                    val = 1;
                setDesired((val >= 4400) ? 4400 : val);
                clearPlot();
            }
            else if (cmd == 'p') {
                setKP(val);
                sprintf(writeBuf, "Wrote %f to KP", val);
            }
            else if (cmd == 'i') {
                setKI(val);
                sprintf(writeBuf, "Wrote %f to KI", val);
            }
            else if (cmd == 'd') {
                setKD(val);
                sprintf(writeBuf, "Wrote %f to KD", val);
            }
            else
                sprintf(writeBuf, "Invalid Command");
            
            debugWrite(writeBuf);
            memset(buf, 0, 50);
            x = 0;
        }
    }
    
    
    
    INTClearFlag(INT_SOURCE_UART_RX(UART1));
}

void uart1_txwrite(uint8_t c) {
    while (U1STAbits.UTXBF); //while full
    U1TXREG = c;
}

void uart1_txwrite_str(char *c) {
    int x;
    for (x = 0; x < strlen(c); x++) {
        uart1_txwrite(c[x]);
    }
}

