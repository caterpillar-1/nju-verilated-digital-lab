object Elaborate extends App {
  (new chisel3.stage.ChiselStage).emitVerilog(new chiselproject.ChiselTop, args)
}
