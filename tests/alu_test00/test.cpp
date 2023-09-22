#include "Valu.h"
#include <iostream>
#include <stdlib.h>
#include <verilated.h>
#include <verilated_vcd_c.h>

#define MAX_SIM_TIME 20
vluint64_t sim_time = 0;

extern void nvboard_bind_all_pins(Valu *top);

int main(int argc, char **argv, char **env) {
  Verilated::commandArgs(argc, argv);

  Valu *dut = new Valu;

  Verilated::traceEverOn(true);
  VerilatedVcdC *m_trace = new VerilatedVcdC;
  dut->trace(m_trace, 5);
  m_trace->open("alu.vcd");

  // nvboard_bind_all_pins(dut);
  // nvboard_init();

  while (sim_time < MAX_SIM_TIME) {
    dut->rst = 0;
    if (sim_time > 1 && sim_time < 5) {
      dut->rst = 1;
      dut->a_in = 0;
      dut->b_in = 0;
      dut->op_in = 0;
      dut->in_valid = 0;
    }

    dut->eval();
    dut->clk ^= 1;
    dut->eval();
    // nvboard_update();
    m_trace->dump(sim_time);
    sim_time++;
    std::cout << "sim_time: " << sim_time << std::endl;
  }

  m_trace->close();
  // nvboard_quit();
  delete dut;
  exit(EXIT_SUCCESS);
}
