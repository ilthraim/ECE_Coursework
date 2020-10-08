##Bank = 15, Pin name = IO_L11N_T1_SRCC_15,					Sch name = BTNC
set_property PACKAGE_PIN E16 [get_ports rst]						
	set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Clock signal
##Bank = 35, Pin name = IO_L12P_T1_MRCC_35,					Sch name = CLK100MHZ
set_property PACKAGE_PIN E3 [get_ports clk100MHz]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk100MHz]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk100MHz]

	
## Switches
    ##Bank = 34, Pin name = IO_L21P_T3_DQS_34,                    Sch name = SW0
    set_property PACKAGE_PIN U9 [get_ports {d4[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d4[0]}]
    ##Bank = 34, Pin name = IO_25_34,                            Sch name = SW1
    set_property PACKAGE_PIN U8 [get_ports {d4[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d4[1]}]
    ##Bank = 34, Pin name = IO_L23P_T3_34,                        Sch name = SW2
    set_property PACKAGE_PIN R7 [get_ports {d4[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d4[2]}]
    ##Bank = 34, Pin name = IO_L19P_T3_34,                        Sch name = SW3
    set_property PACKAGE_PIN R6 [get_ports {d4[3]}]                    
       set_property IOSTANDARD LVCMOS33 [get_ports {d4[3]}]
    ##Bank = 34, Pin name = IO_L19N_T3_VREF_34,                    Sch name = SW4
    set_property PACKAGE_PIN R5 [get_ports {d5[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d5[0]}]
    ##Bank = 34, Pin name = IO_L20P_T3_34,                        Sch name = SW5
    set_property PACKAGE_PIN V7 [get_ports {d5[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d5[1]}]
    ##Bank = 34, Pin name = IO_L20N_T3_34,                        Sch name = SW6
    set_property PACKAGE_PIN V6 [get_ports {d5[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d5[2]}]
    ##Bank = 34, Pin name = IO_L10P_T1_34,                        Sch name = SW7
    set_property PACKAGE_PIN V5 [get_ports {d5[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d5[3]}]
    ##Bank = 34, Pin name = IO_L8P_T1-34,                        Sch name = SW8
    set_property PACKAGE_PIN U4 [get_ports {d6[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d6[0]}]
    ##Bank = 34, Pin name = IO_L9N_T1_DQS_34,                    Sch name = SW9
    set_property PACKAGE_PIN V2 [get_ports {d6[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d6[1]}]
    ##Bank = 34, Pin name = IO_L9P_T1_DQS_34,                    Sch name = SW10
    set_property PACKAGE_PIN U2 [get_ports {d6[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d6[2]}]
    ##Bank = 34, Pin name = IO_L11N_T1_MRCC_34,                    Sch name = SW11
    set_property PACKAGE_PIN T3 [get_ports {d6[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d6[3]}]
    ##Bank = 34, Pin name = IO_L17N_T2_34,                        Sch name = SW12
    set_property PACKAGE_PIN T1 [get_ports {d7[0]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d7[0]}]
    ##Bank = 34, Pin name = IO_L11P_T1_SRCC_34,                    Sch name = SW13
    set_property PACKAGE_PIN R3 [get_ports {d7[1]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d7[1]}]
    ##Bank = 34, Pin name = IO_L14N_T2_SRCC_34,                    Sch name = SW14
    set_property PACKAGE_PIN P3 [get_ports {d7[2]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d7[2]}]
    ##Bank = 34, Pin name = IO_L14P_T2_SRCC_34,                    Sch name = SW15
    set_property PACKAGE_PIN P4 [get_ports {d7[3]}]                    
        set_property IOSTANDARD LVCMOS33 [get_ports {d7[3]}]
        
##7 segment display
        ##Bank = 34, Pin name = IO_L2N_T0_34,                        Sch name = CA
        set_property PACKAGE_PIN L3 [get_ports {segs_l[6]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {segs_l[6]}]
        ##Bank = 34, Pin name = IO_L3N_T0_DQS_34,                    Sch name = CB
        set_property PACKAGE_PIN N1 [get_ports {segs_l[5]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {segs_l[5]}]
        ##Bank = 34, Pin name = IO_L6N_T0_VREF_34,                    Sch name = CC
        set_property PACKAGE_PIN L5 [get_ports {segs_l[4]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {segs_l[4]}]
        ##Bank = 34, Pin name = IO_L5N_T0_34,                        Sch name = CD
        set_property PACKAGE_PIN L4 [get_ports {segs_l[3]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {segs_l[3]}]
        ##Bank = 34, Pin name = IO_L2P_T0_34,                        Sch name = CE
        set_property PACKAGE_PIN K3 [get_ports {segs_l[2]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {segs_l[2]}]
        ##Bank = 34, Pin name = IO_L4N_T0_34,                        Sch name = CF
        set_property PACKAGE_PIN M2 [get_ports {segs_l[1]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {segs_l[1]}]
        ##Bank = 34, Pin name = IO_L6P_T0_34,                        Sch name = CG
        set_property PACKAGE_PIN L6 [get_ports {segs_l[0]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {segs_l[0]}]

        
##Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = AN0
        set_property PACKAGE_PIN N6 [get_ports {an_l[0]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[0]}]
        ##Bank = 34, Pin name = IO_L18P_T2_34,                        Sch name = AN1
        set_property PACKAGE_PIN M6 [get_ports {an_l[1]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[1]}]
        ##Bank = 34, Pin name = IO_L4P_T0_34,                        Sch name = AN2
        set_property PACKAGE_PIN M3 [get_ports {an_l[2]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[2]}]
        ##Bank = 34, Pin name = IO_L13_T2_MRCC_34,                    Sch name = AN3
        set_property PACKAGE_PIN N5 [get_ports {an_l[3]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[3]}]
        ##Bank = 34, Pin name = IO_L3P_T0_DQS_34,                    Sch name = AN4
        set_property PACKAGE_PIN N2 [get_ports {an_l[4]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[4]}]
        ##Bank = 34, Pin name = IO_L16N_T2_34,                        Sch name = AN5
        set_property PACKAGE_PIN N4 [get_ports {an_l[5]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[5]}]
        ##Bank = 34, Pin name = IO_L1P_T0_34,                        Sch name = AN6
        set_property PACKAGE_PIN L1 [get_ports {an_l[6]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[6]}]
        ##Bank = 34, Pin name = IO_L1N_T034,                            Sch name = AN7
        set_property PACKAGE_PIN M1 [get_ports {an_l[7]}]                    
            set_property IOSTANDARD LVCMOS33 [get_ports {an_l[7]}]