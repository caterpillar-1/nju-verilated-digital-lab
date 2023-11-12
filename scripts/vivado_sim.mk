# Behavioral simulation on Vivado

include scripts/vivado.mk
.DEFAULT_GOAL = simulate

WAVE = $(TEST_NAME)_snapshot.wdb
SNAPSHOT = $(TEST_NAME)_snapshot
VIVADO_SIM_SCRIPT = $(SCRIPTS_DIR)/vivado_sim.tcl
ELAB_TIMESTAMP = $(BUILD_DIR)/.elab.timestamp
COMP_TIMESTAMP = $(BUILD_DIR)/.comp.timestamp

VSRCS += $(shell find $(abspath $(TEST_DIR)) $(VSRC_PATTERN))

CFLAGS += -DSIM

VIVADO_FLAGS += --nolog 



.PHONY: wave
wave: $(WAVE)
	@echo "### WAVEFORM ###"
	$(XSIM) $(VIVADO_FLAGS) --gui $(WAVE)

$(WAVE): $(ELAB_TIMESTAMP)
	@echo "### SIMULATION ###"
	$(XSIM) $(VIVADO_FLAGS) $(SNAPSHOT) --tclbatch $(VIVADO_SIM_SCRIPT)

$(ELAB_TIMESTAMP): $(COMP_TIMESTAMP)
	@echo "### ELABORATION ###"
	$(XELAB) $(VIVADO_FLAGS) -debug all -top $(SIM_TB) -snapshot $(SNAPSHOT)
	touch $(ELAB_TIMESTAMP)

$(COMP_TIMESTAMP): $(VSRCS)
	@echo "### COMPILATION ###"
	$(XVLOG) $(VIVADO_FLAGS) -d SIM --sv --incr --relax $(VSRCS)
	touch $(COMP_TIMESTAMP)

.PHONY: compile
compile: $(COMP_TIMESTAMP)

.PHONY: elaborate
elaborate: $(ELAB_TIMESTAMP)

.PHONY: simulate
simulate: $(WAVE)
