#include "Vtop.h"
#include <nvboard.h>
#include <verilated.h>

extern void nvboard_bind_all_pins(Vtop *top);

int main(int argc, char *argv[], char *envp[]) {
  vluint64_t sim_time = 0;
  Verilated::commandArgs(argc, argv);

  Vtop *dut = new Vtop;

  nvboard_bind_all_pins(dut);
  nvboard_init();

  dut->CLK = 0;
  while (true) {
    dut->CLK ^= 1;
    dut->eval();
    nvboard_update();
    sim_time++;
  }

  nvboard_quit();
  delete dut;
  return 0;
}
