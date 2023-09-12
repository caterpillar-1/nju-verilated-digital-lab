`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2023 01:34:40 PM
// Design Name: 
// Module Name: clock_test
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


module clock_test();
    reg clk;
    reg [13:0] sw;
    reg [4:0] btn;
    wire [31:0] seg_content;
    wire [7:0] seg_dp;
    
    clock clock(.clk(clk), .sw(sw), .btn(btn), .seg_content(seg_content), .seg_dp(seg_dp), .seg_en());
    
    initial begin
        clk = 0;
        sw = 0;
        btn = 0;
        forever begin
            #10;
            clk = ~clk;
        end
    end
endmodule
