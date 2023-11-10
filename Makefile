# Main Makefile
# When calling make, please provide PLATFORM = {NVDL, VIVADO}, MODE = {SIM, EVAL}

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

$(shell mkdir -p $(BUILD_DIR))

VSRC_PATTERN = -name "*.v" -or -name "*.sv"
CSRC_PATTERN = -name "*.c" -or -name "*.cc" -or -name "*.cpp"

VSRCS += $(shell find $(abspath $(VSRCS_DIR)) $(VSRC_PATTERN)) 
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

.PHONY: clean
clean:
	@echo "### CLEAN ###"
	rm -rf $(BUILD_DIR)
