EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:switches
LIBS:relays
LIBS:motors
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:microchip_pic12mcu
LIBS:myLib
LIBS:tutorial1-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "Tutorial1"
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L R R?
U 1 1 5D651D4E
P 4350 2050
F 0 "R?" V 4430 2050 50  0000 C CNN
F 1 "1k" V 4350 2050 50  0000 C CNN
F 2 "" V 4280 2050 50  0001 C CNN
F 3 "" H 4350 2050 50  0001 C CNN
	1    4350 2050
	0    1    -1   0   
$EndComp
$Comp
L R R?
U 1 1 5D651E1C
P 3600 3450
F 0 "R?" V 3680 3450 50  0000 C CNN
F 1 "100" V 3600 3450 50  0000 C CNN
F 2 "" V 3530 3450 50  0001 C CNN
F 3 "" H 3600 3450 50  0001 C CNN
	1    3600 3450
	0    1    1    0   
$EndComp
$Comp
L PIC12C508A-I/SN U?
U 1 1 5D651FAD
P 2900 2650
F 0 "U?" H 2350 3200 50  0000 L CNN
F 1 "PIC12C508A-I/SN" H 2350 3100 50  0000 L CNN
F 2 "" H 2900 2650 50  0001 C CNN
F 3 "" H 2900 2650 50  0001 C CNN
	1    2900 2650
	1    0    0    -1  
$EndComp
$Comp
L MYCONN3 J?
U 1 1 5D6522B6
P 2650 3350
F 0 "J?" H 2600 2950 60  0000 C CNN
F 1 "MYCONN3" H 2650 3350 60  0000 C CNN
F 2 "" H 2650 3350 60  0001 C CNN
F 3 "" H 2650 3350 60  0001 C CNN
	1    2650 3350
	1    0    0    -1  
$EndComp
$Comp
L LED D?
U 1 1 5D6522F1
P 3950 2050
F 0 "D?" H 3950 2150 50  0000 C CNN
F 1 "LED" H 3950 1950 50  0000 C CNN
F 2 "" H 3950 2050 50  0001 C CNN
F 3 "" H 3950 2050 50  0001 C CNN
	1    3950 2050
	1    0    0    -1  
$EndComp
$EndSCHEMATC
