`timescale 1ns/1ps
module top (
    input clk,
    input rst,
    input [15:0] SW,
    input ps2_clk,
    input ps2_data,
    output [15:0] LED,
    output VGA_CLK,
    output VGA_HSYNC,
    output VGA_VSYNC,
    output VGA_BLANK_N,
    output [7:0] VGA_R,
    output [7:0] VGA_G,
    output [7:0] VGA_B,
    output [7:0] seg0,
    output [7:0] seg1,
    output [7:0] seg2,
    output [7:0] seg3,
    output [7:0] seg4,
    output [7:0] seg5,
    output [7:0] seg6,
    output [7:0] seg7
);

    wire [2:0] result;
    wire valid;
    priority83 priority83(.in(SW[7:0]), .en(SW[8]), .out(result), .valid(valid));
    
    assign LED[2:0] = result;
    assign LED[4] = valid;
    
    wire [6:0] raw_display;
    
    led7seg led7seg(.in({1'b0, result}), .out(raw_display), .en(valid));
    
    assign seg0 = {1'b1, ~raw_display};

    // assign seg0 = 8'b11111110;
    // assign seg1 = 8'b11111101;
    // assign seg2 = 8'b11111011;
    // assign seg3 = 8'b11110111;
    // assign seg4 = 8'b11101111;
    // assign seg5 = 8'b11011111;
    // assign seg6 = 8'b10111111;
    // assign seg7 = 8'b01111111;

endmodule
