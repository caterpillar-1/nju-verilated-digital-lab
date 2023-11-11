# NVDL platform config

CC := gcc
VERILATOR := verilator
GTKWAVE := gtkwave
PYTHON := python3

VERILATOR_FLAGS = -Wall -Mdir $(BUILD_DIR) -MMD --compiler $(CC) -j 4 --build --exe --cc -sv -DNVDL
VERILATOR_FLAGS += -Wno-declfilename -Wno-widthtrunc -Wno-unusedsignal -Wno-undriven --x-assign unique --x-initial unique 

CFLAGS += -DNVDL -O3
LDFLAGS +=
