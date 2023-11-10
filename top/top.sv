module top (
  input CLK_INPUT,
  input [15:0] SW,
  input [4:0] BTN,
  output [15:0] LED,
  `ifdef NVDL
    output [7:0] SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7,
  `elsif VIVADO
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG, DP,
  `endif
  input PS2_CLK, PS2_DAT,
  output [3:0] VGA_R, VGA_G, VGA_B,
  `ifdef NVDL
  output VGA_VALID_N,
  `endif
  output VGA_HS, VGA_VS

);

/********************
*   CLK (10MHz)    *
********************/

wire CLK; // RT: 10MHz, PERF: maxinum frequency provided by platform

`ifdef CLK_RT
`ifdef NVDL
assign CLK = CLK_INPUT;
`elsif VIVADO
clkgen #(100000000, 10000000) clk_10khz_gen(.in(CLK_INPUT), .out(CLK));
`endif
`elsif CLK_PERF
assign CLK = CLK_INPUT;
`endif

/***********************************
*   SEG_CONTENT, SEG_DP, SEG_EN    *
***********************************/

wire [31:0] SEG_CONTENT;
wire [7:0] SEG_DP, SEG_EN;

wire [3:0] SEG_CONTENT_BUF [0:7];

genvar i;
generate
for (i = 0; i < 8; i = i + 1) begin
    assign SEG_CONTENT_BUF[i] = SEG_CONTENT[4*i+3:4*i];
end
endgenerate

/*
    +--0--+
    5     1
    +--6--+
    4     2
    +--3--+ 7
*/

`ifdef NVDL

wire [7:0] SEG_DISPLAY_BUF [0:7];

assign SEG0 = ~SEG_DISPLAY_BUF[0];
assign SEG1 = ~SEG_DISPLAY_BUF[1];
assign SEG2 = ~SEG_DISPLAY_BUF[2];
assign SEG3 = ~SEG_DISPLAY_BUF[3];
assign SEG4 = ~SEG_DISPLAY_BUF[4];
assign SEG5 = ~SEG_DISPLAY_BUF[5];
assign SEG6 = ~SEG_DISPLAY_BUF[6];
assign SEG7 = ~SEG_DISPLAY_BUF[7];

generate
for (i = 0; i < 8; i = i + 1) begin
    assign SEG_DISPLAY_BUF[i][7] = SEG_EN[i] & SEG_DP[i];
    led7seg bin_to_raw(
        .in(SEG_CONTENT_BUF[i]), 
        .out(SEG_DISPLAY_BUF[i][6:0]), 
        .en(SEG_EN[i])
    );
end
endgenerate

`elsif VIVADO

wire [7:0] SEG_DISPLAY_BUF;

reg [2:0] select;
assign AN = ~(8'b1 << select);

initial begin
    select = 0;
end


reg clk_1khz;
clkgen #(100000000, 1000) clk_1khz_gen(.in(CLK_INPUT), .out(clk_1khz));

always @(posedge clk_1khz) begin
    select <= select + 1;
end

led7seg bin_to_raw(
    .in(SEG_CONTENT_BUF[select]),
    .out(SEG_DISPLAY_BUF[6:0]),
    .en(SEG_EN[select])
);

assign SEG_DISPLAY_BUF[7] = SEG_DP[select];

assign {DP, CG, CF, CE, CD, CC, CB, CA}
    = ~SEG_DISPLAY_BUF;

`endif

/********************************************
* VGA_VALID, VGA_DATA, VGA_HADDR, VGA_VADDR *
********************************************/


wire [11:0] VGA_DATA;
wire [9:0] VGA_HADDR, VGA_VADDR;

vga_ctrl vga_ctrl(
  .pclk(CLK),
  .reset(1'b0),
  .vga_data(VGA_DATA),
  .h_addr(VGA_HADDR),
  .v_addr(VGA_VADDR),
  .hsync(VGA_HS),
  .vsync(VGA_VS),
  .valid(VGA_VALID_N),
  .vga_r(VGA_R),
  .vga_g(VGA_G),
  .vga_b(VGA_B)
);

`ifndef NVDL
wire VGA_VALID_N;
`endif

/* USERSPACE BEGIN */

wire [2:0] fg_color, bg_color, w_fg_color, w_bg_color;
wire [7:0] ascii, w_ascii;
wire vga_bit;

wire [4:0] r_addr, wr_addr;
wire [6:0] c_addr, wc_addr;
wire [3:0] ir_addr;
wire [3:0] ic_addr;

assign r_addr = VGA_VADDR[8:4];
assign c_addr = VGA_HADDR / 9;
assign ir_addr = VGA_VADDR[3:0];
assign ic_addr = VGA_HADDR % 9;

wire cmem_we;

vga_render vga_render(
  .fg_color(fg_color),
  .bg_color(bg_color),
  .vga_bit(vga_bit),
  .vga_data(VGA_DATA)
);

vga_cmem vga_cmem(
  .clk(CLK),
  .r_addr(r_addr),
  .c_addr(c_addr),
  .ascii(ascii),
  .fg_color(fg_color),
  .bg_color(bg_color),
  .we(cmem_we),
  .wr_addr(wr_addr),
  .wc_addr(wc_addr),
  .w_ascii(w_ascii),
  .w_fg_color(w_fg_color),
  .w_bg_color(w_bg_color)
);

vga_bitmap vga_bitmap(
  .ascii(ascii),
  .ir_addr(ir_addr),
  .ic_addr(ic_addr),
  .vga_bit(vga_bit)
);

wire valid;
wire [7:0] in_ascii;

terminal terminal(
  .clk(CLK),
  .we(cmem_we),
  .wr_addr(wr_addr),
  .wc_addr(wc_addr),
  .fg_color(w_fg_color),
  .bg_color(w_bg_color),
  .w_ascii(w_ascii),
  .in_valid(valid),
  .in_ascii(in_ascii)
);

wire ready, next, overflow;
wire [7:0] data;
wire set_rst;
wire ctrl, alt, shift, caps;
wire [7:0] key;

ps2_keyboard ps2_keyboard(
    .clk(CLK),
    .rst(set_rst),
    .ps2_clk(PS2_CLK),
    .ps2_data(PS2_DAT),
    .next(next),
    .ready(ready),
    .overflow(overflow),
    .data(data)
);

keyboard keyboard(
    .clk(CLK),
    .rst(BTN[4]),
    .ready(ready),
    .overflow(overflow),
    .data(data),
    .set_rst(set_rst),
    .set_next(next),
    .ctrl(ctrl),
    .alt(alt),
    .shift(shift),
    .caps(caps),
    .key(key)
);

keycode_to_ascii conventer(
    .keycode(key),
    .shift(shift | caps),
    .valid(valid),
    .ascii(in_ascii)
);

wire clock_clk;
clkgen #(10000000, 1000) clock_clk_gen(.in(CLK_INPUT), .out(clock_clk));

// Related modules were written when I was a freshman to Verilog
// and are used for demonstration purpose only.
digital_clock digital_clock(
  .clk(clock_clk),
  .sw(SW),
  .btn(BTN),
  .seg_content(SEG_CONTENT),
  .seg_dp(SEG_DP),
  .seg_en(SEG_EN),
  .led(LED)
);

/* USERSPACE END */

endmodule

