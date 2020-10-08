#include <plib.h>
#include <xc.h>
#include <inttypes.h>
#include <stdio.h>
#include "uart1.h"
#include "ztimer.h"

#pragma config FNOSC = FRCPLL, POSCMOD = OFF
#pragma config FPLLIDIV = DIV_2, FPLLMUL = MUL_20 //40 MHz
#pragma config FPBDIV = DIV_1, FPLLODIV = DIV_2 // PB 40 MHz
#pragma config FWDTEN = OFF,  FSOSCEN = OFF, JTAGEN = OFF

// Number of iterations for testing. You may need to play with this
// number. If it is too short, you may not get a very accurate measure
// of performance. Too long and you will have to wait forever.
#define NUM_ITERATIONS 100000
// This is the number of times you repeat the operation within the
// loop. You want to repeat enough times that the loop overhead is
// small for the simplest operations.
#define NUM_REPS 10
uint8_t buffer[64];
void test_uint8_mult()
{
    uint32_t i;
    uint8_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
    }
}
void test_uint8_sub()
{
    uint32_t i;
    uint8_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
    }
}
void test_uint8_add()
{
    uint32_t i;
    uint8_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
    }
}
void test_uint8_div()
{
    uint32_t i;
    uint8_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
    }
}

void test_uint16_add()
{
    uint32_t i;
    uint16_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
    }
}

void test_uint16_sub()
{
    uint32_t i;
    uint16_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1+i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
    }
}

void test_uint16_mult()
{
    uint32_t i;
    uint16_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
    }
}

void test_uint16_div()
{
    uint32_t i;
    uint16_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
    }
}

void test_uint32_add()
{
    uint32_t i;
    uint32_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
    }
}

void test_uint32_sub()
{
    uint32_t i;
    uint32_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
    }
}

void test_uint32_mult()
{
    uint32_t i;
    uint32_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
    }
}

void test_uint32_div()
{
    uint32_t i;
    uint32_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
    }
}

void test_uint64_add()
{
    uint32_t i;
    uint64_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
    }
}

void test_uint64_sub()
{
    uint32_t i;
    uint64_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
    }
}

void test_uint64_mult()
{
    uint32_t i;
    uint64_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
    }
}

void test_uint64_div()
{
    uint32_t i;
    uint64_t i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
    }
}

void test_float_add()
{
    uint32_t i;
    float i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
    }
}

void test_float_sub()
{
    uint32_t i;
    float i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
    }
}

void test_float_mult()
{
    uint32_t i;
    float i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
    }
}

void test_float_div()
{
    uint32_t i;
    float i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
    }
}

void test_double_add()
{
    uint32_t i;
    double i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
        i3 = i1+i2;
    }
}

void test_double_sub()
{
    uint32_t i;
    double i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
        i3 = i1-i2;
    }
}

void test_double_mult()
{
    uint32_t i;
    double i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
        i3 = i1*i2;
    }
}

void test_double_div()
{
    uint32_t i;
    double i1, i2, i3;
    i1 = 15;
    i2 = 26;
    for (i=0; i<NUM_ITERATIONS; i++)
    {
        // Make sure NUM_REPS is the same as the number
        // of repeated lines here.
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
        i3 = i1/i2;
    }
}

void main() {
    //INTEnableSystemSingleVectoredInt();
    //INTEnableInterrupts();
    uint32_t t1, t2;
    uart1_init(9600);
    zTimerOn();
    uart1_txwrite_str("Performance Summary: Time per operation statistics\r\n");
    
    // Test adding bytes
    t1 = zTimerReadms();
    test_uint8_add();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT8 ADD: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    // Test subtracting bytes
    t1 = zTimerReadms();
    test_uint8_sub();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT8 SUB: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    // Test multiplying bytes
    t1 = zTimerReadms();
    test_uint8_mult();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT8 MULT: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    // Test dividing bytes
    t1 = zTimerReadms();
    test_uint8_div();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT8 DIV: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    // Test adding 16
    t1 = zTimerReadms();
    test_uint16_add();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT16 ADD: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    // Test subtracting 16
    t1 = zTimerReadms();
    test_uint16_sub();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT16 SUB: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    // Test multiplying 16
    t1 = zTimerReadms();
    test_uint16_mult();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT16 MULT: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    // Test dividing 16
    t1 = zTimerReadms();
    test_uint16_div();
    t2 = zTimerReadms();
    // Print timing result. Doubles OK here. Not time critical code.
    sprintf(buffer, "UINT16 DIV: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_uint32_add();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT32 ADD: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_uint32_sub();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT32 SUB: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_uint32_mult();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT32 MULT: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_uint32_div();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT32 DIV: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_uint64_add();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT64 ADD: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_uint64_sub();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT64 SUB: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_uint64_mult();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT64 MULT: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);

    
    t1 = zTimerReadms();
    test_uint64_div();
    t2 = zTimerReadms();
    sprintf(buffer, "UINT64 DIV: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_float_add();
    t2 = zTimerReadms();
    sprintf(buffer, "FLOAT ADD: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_float_sub();
    t2 = zTimerReadms();
    sprintf(buffer, "FLOAT SUB: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_float_mult();
    t2 = zTimerReadms();
    sprintf(buffer, "FLOAT MULT: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_float_div();
    t2 = zTimerReadms();
    sprintf(buffer, "FLOAT DIV: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_double_add();
    t2 = zTimerReadms();
    sprintf(buffer, "DOUBLE ADD: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_double_sub();
    t2 = zTimerReadms();
    sprintf(buffer, "DOUBLE SUB: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_double_mult();
    t2 = zTimerReadms();
    sprintf(buffer, "DOUBLE MULT: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);
    
    t1 = zTimerReadms();
    test_double_div();
    t2 = zTimerReadms();
    sprintf(buffer, "DOUBLE DIV: %.06f us per operation\r\n", (double)(t2-t1) / (double) NUM_ITERATIONS / (double) NUM_REPS * 1000.0);
    uart1_txwrite_str(buffer);

   // while (1); // When done, wait forever.
}

void unitTest1() {
    char temp;
    uart1_txwrite_str("Ethan Miller and John Burk\n\rInventors of Poingid\n\rHarassers of Zach\n\rMust be allowed to speak with BONK\n\r");
    while (1) {
        while (uart1_rxrdy() == 0);
        temp  = uart1_rxread();
        if ((temp >= 97) && (temp <= 122))
            temp = temp - 32;
        else if ((temp >= 65) && (temp <= 90))
            temp = temp + 32;
        uart1_txwrite(temp);
    }
}

void unitTest2() {
    char str[50];
    zTimerOn();
    while (1) {
        while (uart1_rxrdy() == 0);
        uart1_rxread();
        sprintf(str, "%d\n\r", zTimerReadms());
        uart1_txwrite_str(str);
    }
}