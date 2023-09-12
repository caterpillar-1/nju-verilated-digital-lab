`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2023 11:36:39 PM
// Design Name: 
// Module Name: digital_clock_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//`define DEBUG

`ifdef DEBUG
`define DUMMY_CLK
`endif

module digital_clock_top(
`ifndef NVBOARD
`ifndef DUMMY_CLK
    input CLK100MHZ,
`endif
`endif
    input [15:0] SW,
    input BTNC, BTNU, BTNL, BTNR, BTND,
    input CPU_RESETN,
    output [15:0] LED,
`ifndef NVBOARD
    output CA, CB, CC, CD, CE, CF, CG, DP,
    output [7:0] AN,
`else
    output [7:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7,
`endif
    output [3:0] VGA_R, VGA_G, VGA_B,
    output VGA_HS, VGA_VS,
    output PS2_CLK, 
    output PS2_DATA
);

`ifdef DEBUG
    assign SW = 16'b0100_0000_0000_0000;
    assign BTNC = 0;
    assign BTNU = 0;
    assign BTND = 0;
    assign BTNL = 0;
    assign BTNR = 0;
`endif


/**********
    CLK
***********/

`ifdef NVBOARD
    reg CLK;
    initial begin
        CLK = 0;
        forever begin
            #10;
            CLK = ~CLK;
        end
    end
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
`else

    wire CLK; // 1Khz
    
    frequency_divider_100Mhz_1Khz g_milisecond(
        .in(CLK100MHZ),
        .out(CLK),
        .rst(1'b0)
    );
`endif

/*******************************************
    [3:0] SEG_CONTENT [0:7], SEG_DP [0:7]
********************************************/

    // Modify the type of SEG_CONTENT as needed (wire / reg) 
    wire [31:0] SEG_CONTENT;
    wire [3:0] SEG_CONTENT_BUF [0:7];
    assign SEG_CONTENT_BUF[0] = SEG_CONTENT[3:0];
    assign SEG_CONTENT_BUF[1] = SEG_CONTENT[7:4];
    assign SEG_CONTENT_BUF[2] = SEG_CONTENT[11:8];
    assign SEG_CONTENT_BUF[3] = SEG_CONTENT[15:12];
    assign SEG_CONTENT_BUF[4] = SEG_CONTENT[19:16];
    assign SEG_CONTENT_BUF[5] = SEG_CONTENT[23:20];
    assign SEG_CONTENT_BUF[6] = SEG_CONTENT[27:24];
    assign SEG_CONTENT_BUF[7] = SEG_CONTENT[31:28];
    
    wire [7:0] SEG_DP;
    wire [7:0] SEG_EN;
    // BINARY NUMBER ARRAY,
    // SEG_CONTENT[0] for the rightmost digit
    // the rendering is handled by the framework
    /* the segment in SEG_CONTENT (ACTIVE LOW)
    
        +--0--+
        5     1
        +--6--+
        4     2
        +--3--+ 7
    
    */
    
    
    
`ifndef NVBOARD // nexysa7

    reg [2:0] select;
    
    initial begin
        select = 0;
    end
    
    assign AN = ~(8'b1 << select);
    
    always @(posedge CLK) begin
        select <= select + 1;
    end
    
    wire [6:0] raw_digit;
    led7seg binary_to_raw(.in(SEG_CONTENT_BUF[select]), .out(raw_digit), .en(SEG_EN[select]));
    
    assign {DP, CG, CF, CE, CD, CC, CB, CA} = ~{SEG_DP[select] & SEG_EN[select], raw_digit};
    
//    assign AN = 8'b11111110;
//    wire [6:0] raw_seg;
//    led7seg binary_to_raw(.in(SEG_CONTENT[3:0]), .out(raw_seg), .en(1'b1));
//    assign DP = SEG_DP[0];
//    assign {CG, CF, CE, CD, CC, CB, CA} = ~raw_seg;
    
    
    
    
//    reg [7:0] digit_selector;
//    initial begin
//        digit_selector = 8'b1;
//    end
    
//    wire [7:0] full_display;
//    wire [6:0] raw_display;
//    assign {DP, CG, CF, CE, CD, CC, CB, CA} = full_display;
//    reg [3:0] binary_content;
//    reg decimal_point;
    
//    led7seg binary_to_raw(.in(binary_content), .out(raw_display), .en(1));
    
//    assign full_display[6:0] = ~raw_display;
    
//    always @(posedge CLK) begin
//        case (digit_selector)
//            8'b00000001: begin binary_content <= SEG_CONTENT_BUF[0]; decimal_point <= SEG_DP[0]; end
//            8'b00000010: begin binary_content <= SEG_CONTENT_BUF[1]; decimal_point <= SEG_DP[1]; end
//            8'b00000100: begin binary_content <= SEG_CONTENT_BUF[2]; decimal_point <= SEG_DP[2]; end
//            8'b00001000: begin binary_content <= SEG_CONTENT_BUF[3]; decimal_point <= SEG_DP[3]; end
//            8'b00010000: begin binary_content <= SEG_CONTENT_BUF[4]; decimal_point <= SEG_DP[4]; end
//            8'b00100000: begin binary_content <= SEG_CONTENT_BUF[5]; decimal_point <= SEG_DP[5]; end
//            8'b01000000: begin binary_content <= SEG_CONTENT_BUF[6]; decimal_point <= SEG_DP[6]; end
//            8'b10000000: begin binary_content <= SEG_CONTENT_BUF[7]; decimal_point <= SEG_DP[7]; end
//            default: begin binary_content <= 0; decimal_point <= 1; end
//        endcase
//        if (digit_selector == 8'b10000000)
//            digit_selector <= 8'b00000001;
//        else
//            digit_selector <= digit_selector << 1;
//    end
    
//    assign AN = digit_selector;
//    assign full_display[7] = decimal_point;

    

`else // nvboard

    wire [6:0] raw_content [0:7];
    genvar i;
    generate
    for (i = 0; i < 8; i = i + 1) begin: g_conventer
        led7seg conventer(.in(SEG_CONTENT_BUF[i]), .out(raw_content[i]), .en(1));
    end
    endgenerate
    
    assign seg0 = {SEG_DP[0], raw_content[0]};
    assign seg1 = {SEG_DP[1], raw_content[1]};
    assign seg2 = {SEG_DP[2], raw_content[2]};
    assign seg3 = {SEG_DP[3], raw_content[3]};
    assign seg4 = {SEG_DP[4], raw_content[4]};
    assign seg5 = {SEG_DP[5], raw_content[5]};
    assign seg6 = {SEG_DP[6], raw_content[6]};
    assign seg7 = {SEG_DP[7], raw_content[7]};
    
`endif



/************
    RESET
*************/

    reg RESET;
    always @(*) begin
        RESET = CPU_RESETN;
    end

/**********
    BTN
***********/

    wire [4:0] BTN;
    assign BTN = {BTNC, BTNU, BTND, BTNL, BTNR};
    
/* USERSPACE BEGIN */

// available ports: 
// CLK (100Mhz), 
// RESET, 
// [15:0] SW,
// [4:0] BTN,
// [3:0] SEG_CONTENT [0:7], [0:7] SEG_DP 
// PS2_CLK, PS2_DATA

    digital_clock digital_clock(
        .clk(CLK),
        .sw(SW),
        .btn(BTN),
        .seg_content(SEG_CONTENT),
        .seg_dp(SEG_DP),
        .seg_en(SEG_EN),
        .led(LED)
    );

//    static_output_test static_output_test(
//        .sw(SW),
//        .led(LED),
//        .btn(BTN),
//        .seg_content(SEG_CONTENT),
//        .seg_dp(SEG_DP)
//    );

/* USERPLACE END */
endmodule
