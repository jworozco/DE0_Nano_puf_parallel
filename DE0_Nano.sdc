#**************************************************************
# This .sdc file is created by Terasic Tool.
# Users are recommended to modify this file to match users logic.
#**************************************************************

#**************************************************************
# Create Clock
#**************************************************************
create_clock -period 20 [get_ports CLOCK_50]
#create_clock -name ro_clk -period 10.000 [get_pins {fsm:puf_fsm|ps[0]}]

#**************************************************************
# Create Generated Clock
#**************************************************************
derive_pll_clocks



#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty



#**************************************************************
# Set Input Delay
#**************************************************************

set_input_delay -clock CLOCK_50 -max 0.5 [all_inputs] 
set_input_delay -clock CLOCK_50 -min 0.1 [all_inputs] 
 
#**************************************************************
# Set Output Delay
#**************************************************************

set_output_delay -clock CLOCK_50 -max 0.5 [all_outputs] 
set_output_delay -clock CLOCK_50 -min 0.1 [all_outputs] 

#**************************************************************
# Set Clock Groups
#**************************************************************



#**************************************************************
# Set False Path
#**************************************************************
#set_false_path -from [get_clocks CLOCK_50] -to [get_clocks ro_clk]
#set_false_path -to [get_clocks ro_clk] 
#set_false_path -from [get_clocks ro_clk] 


#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************



#**************************************************************
# Set Load
#**************************************************************



