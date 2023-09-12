// `define DEBUG

/*
    This is an example for top module, eliminating differences between nvboard and nexysa7
*/

module top(
`ifdef NVDL
    input clk,
    input rst,
`else
    input CLK100MHZ,
`endif
    input [15:0] SW,
    output [15:0] LED,
    input BTNC, BTNU, BTND, BTNL, BTNR,
`ifdef NVDL
    output [7:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7
`else
    output [7:0] AN,
    output CA, CB, CC, CD, CE, CF, CG, DP
`endif
);



/*********
*  CLK   *
*********/

`ifdef NVDL
    wire CLK, RST;
    assign CLK = clk;
    assign RST = rst;
`endif

`ifdef DEBUG
`define DUMMY_CLK
`endif

`ifdef DUMMY_CLK
    reg CLK;
    initial begin
        CLK = 0;
        forever begin
            #10;
            CLK = ~CLK;
        end
    end
`endif



/***********
*   BTN    *
***********/

wire [4:0] BTN;
assign BTN = {BTNC, BTNU, BTND, BTNL, BTNR};



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

assign seg0 = ~SEG_DISPLAY_BUF[0];
assign seg1 = ~SEG_DISPLAY_BUF[1];
assign seg2 = ~SEG_DISPLAY_BUF[2];
assign seg3 = ~SEG_DISPLAY_BUF[3];
assign seg4 = ~SEG_DISPLAY_BUF[4];
assign seg5 = ~SEG_DISPLAY_BUF[5];
assign seg6 = ~SEG_DISPLAY_BUF[6];
assign seg7 = ~SEG_DISPLAY_BUF[7];

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

`else

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

/*
    AVAILABLE PORTS:
    CLK, // 100Mhz
    [15:0] SW,
    [15:0] LED,
    [4:0] BTN = {BTNC, BTNU, BTND, BTNL, BTNR},
    [31:0] SEG_CONTENT, (ACTIVE HIGH, 32-bit, 8 x 4-bit binary to display on 7seg)
    [7:0] SEG_DP, (ACTIVE HIGH, decimal points on 7seg)
    [7:0] SEG_EN, (ACTIVE HIGH)
*/

/* BEGIN USERSPACE */

digital_clock digital_clock(
    .clk(CLK),
    .sw(SW),
    .btn(BTN),
    .seg_content(SEG_CONTENT),
    .seg_dp(SEG_DP),
    .seg_en(SEG_EN),
    .led(LED)
);

/* END USERSPACE */

/* BEGIN DEBUG */
`ifdef DEBUG

`endif
/* END DEBUG */

endmodule
