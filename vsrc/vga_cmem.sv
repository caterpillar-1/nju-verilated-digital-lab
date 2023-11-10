module vga_cmem (
  input clk,
  input [4:0] r_addr, // [0, 29)
  input [6:0] c_addr, // [0, 69)
  output [7:0] ascii,
  output [2:0] fg_color,
  output [2:0] bg_color,
  input we,
  input [4:0] wr_addr,
  input [6:0] wc_addr,
  input [7:0] w_ascii,
  input [2:0] w_fg_color,
  input [2:0] w_bg_color
  `ifdef VIVADO
  ,
  output [2:0] test_cfg,
  output [2:0] test_cbg
  `endif
);

reg [7:0] mem [2239:0];
reg [2:0] fg_mem[2239:0];
reg [2:0] bg_mem[2239:0];

wire [11:0] index, w_index;
assign index = {c_addr, r_addr};
assign w_index = {wc_addr, wr_addr};

assign ascii = mem[index];
assign fg_color = fg_mem[index];
assign bg_color = bg_mem[index];

`ifdef NVDL
always @(posedge clk) begin
`elsif else
always @(negedge clk) begin
`endif
  if (we) begin
    mem[w_index] <= w_ascii;
    fg_mem[w_index] <= w_fg_color;
    bg_mem[w_index] <= w_bg_color;
  end
end

`ifdef VIVADO
assign test_cfg = fg_mem[0];
assign test_cbg = bg_mem[0];
`endif
endmodule
