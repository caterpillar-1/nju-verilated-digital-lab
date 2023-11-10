# scripts/nvdl_eval.mk
# Evaluate on NVDL using nvboard

include scripts/nvdl.mk

BIN = V$(EVAL_TOP)_eval
INCLUDE_PATH += $(NVBOARD_HOME)/include

VERILATOR_FLAGS += --top $(EVAL_TOP) -DEVAL
CSRCS += $(shell find $(abspath $(TOP_DIR)) $(CSRC_PATTERN))
VSRCS += $(shell find $(abspath $(TOP_DIR)) $(VSRC_PATTERN))

CFLAGS += $(addprefix -I,$(INCLUDE_PATH)) -DTOP_NAME="\"V$(EVAL_TOP)\""L
LDFLAGS += $(NVBOARD_ARCHIVE) -lSDL2 -lSDL2_image

# Clock type
ifeq ($(CLOCK_TYPE),RT)
	CFLAGS += -DCLK_RT
	VERILATOR_FLAGS += -DCLK_RT
else
	CFLAGS += -DCLK_PERF
	VERILATOR_FLAGS += -DCLK_PERF
endif

include $(NVBOARD_HOME)/scripts/nvboard.mk

SRC_AUTOBIND = $(abspath $(BUILD_DIR)/auto_bind.cpp)
CSRCS += $(SRC_AUTOBIND)
$(SRC_AUTOBIND): $(NXDC_FILE)
	$(PYTHON) $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

.PHONY: nvboard
nvboard: compile
	@echo "### EVALUATION ###"
	@cd $(BUILD_DIR) && ./$(BIN)

$(BUILD_DIR)/$(BIN): $(VSRCS) $(CSRCS) nvboard-archive
	@echo "VSRCS: " $(VSRCS)
	@echo "CSRCS: " $(CSRCS)
	$(VERILATOR) $(VERILATOR_FLAGS) \
	$(addprefix -CFLAGS , $(CFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
	$(VSRCS) $(CSRCS) -o $(BIN)

.PHONY: compile
compile: $(BUILD_DIR)/$(BIN)
	@echo "### COMPILATION ###"


