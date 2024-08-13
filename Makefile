# Makefile

# defaults
#SIM ?=icarus
#waves is only valid for icarus: iverilog
#WAVES=1

SIM ?= verilator
# extra args is valid only for verilator, it requries to set the dumpvars, dumpfile in the module
EXTRA_ARGS += --trace-fst --trace-structs
TOPLEVEL_LANG ?= verilog


VERILOG_SOURCES += $(PWD)/ring_osc.sv
VERILOG_SOURCES += $(PWD)/race_arbiter.sv
VERILOG_SOURCES += $(PWD)/puf_parallel_subblock.sv
VERILOG_SOURCES += $(PWD)/post_mux_counter.sv
VERILOG_SOURCES += $(PWD)/mux_16to1.sv
VERILOG_SOURCES += $(PWD)/puf_parallel.sv
VERILOG_SOURCES += $(PWD)/DE0_Nano.sv
# use VHDL_SOURCES for VHDL files

# TOPLEVEL is the name of the toplevel module in your Verilog or VHDL file
TOPLEVEL = DE0_Nano

# MODULE is the basename of the Python test file
MODULE = test_my_puf

# include cocotb's make rules to take care of the simulator setup
include $(shell cocotb-config --makefiles)/Makefile.sim
include cleanall.mk