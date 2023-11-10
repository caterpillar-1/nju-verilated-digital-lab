#include "Vtop.h"
#include <verilated.h>
#include <nvboard.h>
#include <unistd.h>
#include <cinttypes>

extern void nvboard_bind_all_pins(Vtop *top);

Vtop *dut;
uint64_t sim_time;
uint32_t clk_cnt;

static uint64_t boot_time = 0;

static uint64_t get_time_internal() {
  struct timespec now;
  clock_gettime(CLOCK_MONOTONIC_COARSE, &now);
  uint64_t ns = now.tv_sec * 1000000000 + now.tv_nsec;
  return ns;
}

static uint64_t get_time() {
  if (boot_time == 0) boot_time = get_time_internal();
  uint64_t now = get_time_internal();
  return now - boot_time;
}

static void nvdl_init(int argc, char **argv) {
  dut = new Vtop;
  nvboard_bind_all_pins(dut);
  nvboard_init();
  Verilated::commandArgs(argc, argv);
  dut->CLK_INPUT = 0;
  sim_time = 0;
  clk_cnt = 0;
}

static void nvdl_destroy() {
  nvboard_quit();
  delete dut;
}

static void nvdl_loop_begin() {
#ifdef CLK_RT
  if (clk_cnt == 0) {
    sim_time = get_time();
    // printf("Start: %lu\n", sim_time);
  }
#endif
  dut->CLK_INPUT ^= 1;
  dut->eval();
}

static void nvdl_loop_end() {
  nvboard_update(); // nvboard should be updated on falling edge
  dut->CLK_INPUT ^= 1;
  dut->eval();
#ifdef CLK_RT
  // ensure that 100000 cycles per 10ms (10^8Hz = 10MHz)
  // uncomment the printf statement to check whether the simulation is running fast enough
  uint64_t now;
  if (clk_cnt == 99999) {
    while ((now = get_time()) < sim_time + 10000000);
    // printf("End  : %lu\n", now);
    clk_cnt = 0;
  } else {
    clk_cnt += 1;
  }
#endif
}

int main(int argc, char *argv[], char *envp[]) {
  nvdl_init(argc, argv);

  dut->CLK_INPUT = 0; // starting on rising edge

  while (true) {
    nvdl_loop_begin();
    nvdl_loop_end();
  }

  nvdl_destroy();
  return 0;
}
