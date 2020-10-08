## Clock signal
##Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports clk100MHz]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk100MHz]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk100MHz]
	
##Bank = 15, Pin name = IO_L11N_T1_SRCC_15,					Sch name = BTNC
set_property PACKAGE_PIN E16 [get_ports rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports rst]
	
##Bank = 34, Pin name = IO_L21P_T3_DQS_34,					Sch name = SW0
set_property PACKAGE_PIN U9 [get_ports {haz}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {haz}]
##Bank = 34, Pin name = IO_25_34,							Sch name = SW1
set_property PACKAGE_PIN U8 [get_ports {right}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {right}]
##Bank = 34, Pin name = IO_L23P_T3_34,						Sch name = SW2
set_property PACKAGE_PIN R7 [get_ports {left}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {left}]
	
	
## LEDs
##Bank = 34, Pin name = IO_L24N_T3_34,						Sch name = LED0
set_property PACKAGE_PIN T8 [get_ports {lout[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lout[5]}]
##Bank = 34, Pin name = IO_L21N_T3_DQS_34,					Sch name = LED1
set_property PACKAGE_PIN V9 [get_ports {lout[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lout[4]}]
##Bank = 34, Pin name = IO_L24P_T3_34,						Sch name = LED2
set_property PACKAGE_PIN R8 [get_ports {lout[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lout[3]}]
##Bank = 34, Pin name = IO_L23N_T3_34,						Sch name = LED3
set_property PACKAGE_PIN T6 [get_ports {lout[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lout[2]}]
##Bank = 34, Pin name = IO_L12P_T1_MRCC_34,					Sch name = LED4
set_property PACKAGE_PIN T5 [get_ports {lout[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lout[1]}]
##Bank = 34, Pin name = IO_L12N_T1_MRCC_34,					Sch	name = LED5
set_property PACKAGE_PIN T4 [get_ports {lout[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {lout[0]}]