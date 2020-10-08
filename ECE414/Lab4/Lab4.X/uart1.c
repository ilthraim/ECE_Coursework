#include <inttypes.h>
#include <xc.h>
#include <plib.h>
#include <string.h>

void uart1_init(int32_t baudrate) {
    U1MODEbits.ON = 1; //enable UART
    U1MODEbits.UEN = 0; //no flow control
    U1MODEbits.BRGH = 0; //standard speed
    U1MODEbits.PDSEL = 0; //no parity - 8 bits
    U1MODEbits.STSEL = 0; //1 stop bit
    U1RXR = 0x0; //input pin to RPA2 - pin 9
    RPA0R = 0x1; //output pin to RPA0 - pin 2
    CNPUA = 0x0; //disable pull up r on A
    ANSELA = 0x0; //set a to digital
    
    /*IEC1bits.U1TXIE = 1; //enable transmit interrupt
    IEC1bits.U1RXIE = 1; //enable recieve interrupt
    IPC8bits.U1IP = 1; //set interrupt priority to 1
    IPC8bits.U1IS = 2; //set interrupt subpriority to 2
    U1STAbits.UTXISEL = 0x2; //interrupt when transmit buffer is empty
    U1STAbits.URXISEL = 0x0; //interrupt when not empty*/
    
    U1STAbits.URXEN = 1; //enable rx pin
    U1STAbits.UTXEN = 1; //enable tx pin
    
    U1BRG = 40000000 / (16 * baudrate) - 1; //set baudrate
}

uint8_t uart1_txrdy() {
    return U1STAbits.UTXBF ? 0 : 1;
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

uint8_t uart1_rxrdy() {
    return U1STAbits.URXDA;
}

uint8_t uart1_rxread() {
    return ReadUART1();
}