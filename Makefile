# Main Makefile
# When calling make, please provide PLATFORM = {NVDL, VIVADO}, MODE = {SIM, EVAL}
NVDL_HOME = ${HOME}/.local/opt/nvdl
$(shell mkdir -p $(NVDL_HOME))

# Project type, PROJ_TYPE = {VERILOG, CHISEL}
PROJ_TYPE = VERILOG
# Used for NVDL, verilog dut. There should be exact one main() in $(TESTS_DIR)/$(TEST_NAME).
SIM_TOP = alu
# Used for VIVADO, verilog testbench name
SIM_TB = alu_test
# The current active test. Both the C++ testbench and verilog testbench should be in the corresponding directory.
TEST_NAME = alu_test00
# The unified top_module for evaluation on board.
EVAL_TOP = top
# Type of clk. RT: provide CLK (10KHz), PERF: provide the fastest avaliable clk.
CLOCK_TYPE = RT



# the design verilog files
VSRCS_DIR = ./vsrc
# C++ classes used to design testbenches
CSRCS_DIR = ./csrc
# C++ header files
INCLUDE_DIR = ./include
# C++ and verilog top files
TOP_DIR = ./top
# unified constrain files. DO NOT MODIFY.
CONSTR_DIR = ./constr
# contain test folders
TESTS_DIR = ./tests
TEST_DIR := $(TESTS_DIR)/$(TEST_NAME)
# the scripts for different platforms
SCRIPTS_DIR = ./scripts

# the build directory
BUILD_DIR = ./build
ifeq ($(PROJ_TYPE),CHISEL)
# generated verilog source for chisel modules
VSRC_GEN_DIR = ./vsrc_gen
endif

export PATH := $(PATH):$(abspath ./utils)

$(shell mkdir -p $(BUILD_DIR))

VSRC_PATTERN = -name "*.v" -or -name "*.sv"
CSRC_PATTERN = -name "*.c" -or -name "*.cc" -or -name "*.cpp"

VSRCS += $(shell find $(abspath $(VSRCS_DIR)) $(VSRC_PATTERN))
ifeq ($(PROJ_TYPE),CHISEL)
VSRCS += $(shell find $(abspath $(VSRC_GEN_DIR)) $(VSRC_PATTERN)) 
endif
CSRCS += $(shell find $(abspath $(CSRCS_DIR)) $(CSRC_PATTERN))
NXDC_FILE = $(CONSTR_DIR)/$(EVAL_TOP).nxdc
INCLUDE_PATH = $(INCLUDE_DIR)

ifeq ($(PLATFORM), NVDL)
ifeq ($(MODE), SIM)
	include $(SCRIPTS_DIR)/nvdl_sim.mk
else 
	include $(SCRIPTS_DIR)/nvdl_eval.mk
endif
else
ifeq ($(MODE), EVAL)
	include $(SCRIPTS_DIR)/vivado_eval.mk
else
	include $(SCRIPTS_DIR)/vivado_sim.mk
endif
endif

ifeq ($(PROJ_TYPE),CHISEL)
test:
	mill -i __.test

verilog:
	mkdir -p $(VSRC_GEN_DIR)
	mill -i __.test.runMain Elaborate -td $(VSRC_GEN_DIR)

bsp:
	mill -i mill.bsp.BSP/install

reformat:
	mill -i __.reformat

checkformat:
	mill -i __.checkFormat
endif

clean:
	@echo "### CLEAN ###"
	-rm -rf $(VSRC_GEN_DIR) $(BUILD_DIR)

nvdl_install:
	@echo "Welcome to nju-verilated-digital-lab!"
	@echo "Installing NVboard."
	PREFIX=$(NVDL_HOME) bash scripts/install.sh nvboard
	@echo "Installing Verilator."
	PREFIX=$(NVDL_HOME) bash scripts/install.sh verilator
	@echo "Done."

.PHONY: test verilog bsp reformat checkformat clean

