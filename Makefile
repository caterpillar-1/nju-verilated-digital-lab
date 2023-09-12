# Main makefile
# copied and modified from nvboard example project
# wave generation code inspired by rijuyuezhu

VIVADO_PROJ_NAME = lab03
TOPNAME = top
NXDC_FILES = constr/top.nxdc
INC_PATH ?=

VERILATOR = verilator
VERILATOR_CFLAGS += -MMD --build -cc  \
				-O3 --x-assign fast --x-initial fast --noassert -DNVDL=1

BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj_dir
BIN = $(BUILD_DIR)/$(TOPNAME)
SIMBIN = $(BUILD_DIR)/SIM_$(TOPNAME)
WAVE = $(BUILD_DIR)/wave.vcd

.PHONY: default all run clean nv sim wave syntax

default: $(BIN)

$(shell mkdir -p $(BUILD_DIR))

# constraint file
SRC_AUTO_BIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
$(SRC_AUTO_BIND): $(NXDC_FILES)
	python3 $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

# project source
VSRCS = $(shell find $(abspath ./$(VIVADO_PROJ_NAME).srcs) -name "*.v")
VSRCS += $(shell find $(abspath ./vsrc) -name "*.v")
CSRCS = $(shell find $(abspath ./csrc) -name "*.c" -or -name "*.cc" -or -name "*.cpp")
CSRCS += $(SRC_AUTO_BIND)

# rules for NVBoard
include $(NVBOARD_HOME)/scripts/nvboard.mk

# rules for verilator
INCFLAGS = $(addprefix -I, $(INC_PATH))
CFLAGS += $(INCFLAGS) -DTOP_NAME="\"V$(TOPNAME)\""
LDFLAGS += -lSDL2 -lSDL2_image

$(BIN): $(VSRCS) $(CSRCS) $(NVBOARD_ARCHIVE)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(BIN))

$(SIMBIN): $(VSRCS) $(CSRCS)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) --trace --build \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		--Mdir $(OBJ_DIR) --exe -o $(abspath $(SIMBIN))

all: default

run: $(BIN)
	@$^

clean:
	rm -rf $(BUILD_DIR)

nv: $(BIN)

wave: sim
	gtkwave $(WAVE)


sim: $(SIMBIN)
	@$^

syntax: $(VSRCS)
	@rm -rf $(OBJ_DIR)
	$(VERILATOR) $(VERILATOR_FLAGS) --trace \
		--top-module $(TOPNAME) $^ \
		$(addprefix -CFLAGS , $(CFLAGS) -DNVBOARD -DTRACE) $(addprefix -LDFLAGS , $(LDFLAGS)) \
		-Mdir $(OBJ_DIR)
	bear -- make -C $(OBJ_DIR) -f V$(TOPNAME).mk
