module top (
  input CLK,
  input [15:0] SW,
  input [4:0] BTN,
  output [15:0] LED,
  `ifdef NVDL
    output [7:0] SEG0, SEG1, SEG2, SEG3, SEG4, SEG5, SEG6, SEG7,
  `elsif VIVADO
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG, DP,
  `endif
  input PS2_CLK, PS2_DAT
);


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
reg [19:0] clk_1khz_cache;

initial begin
    clk_1khz = 0;
    clk_1khz_cache = 0;
end

always @(posedge CLK) begin
    if (clk_1khz_cache == 20'd49999) begin
        clk_1khz <= ~clk_1khz;
        clk_1khz_cache <= 0;
    end else begin
        clk_1khz_cache <= clk_1khz_cache + 1;
    end
end

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

/* USERSPACE BEGIN */

alu alu(
  .rst(1'b0),
  .clk(CLK),
  .op_in(SW[1:0]),
  .a_in(SW[7:4]),
  .b_in(SW[11:8]),
  .in_valid(SW[2]),
  .out(LED[3:0]),
  .out_valid(LED[15])
);

/* USERSPACE END */

endmodule

