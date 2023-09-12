`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2023 03:09:20 PM
// Design Name: 
// Module Name: digital_clock_test
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


module digital_clock_test();
    reg clk;
    reg [15:0] sw;
    reg [4:0] btn;
    wire [31:0] seg_content;
    wire [7:0] seg_dp;
    
    digital_clock digital_clock(
        .clk(clk),
        .sw(sw),
        .btn(btn),
        .seg_content(seg_content),
        .seg_dp(seg_dp),
        .seg_en(),
        .led()
    );
    
    initial begin
        clk = 0;
        sw = 0;
        sw[14] = 1;
        btn = 0;
        forever begin
            #10;
            clk = ~clk;
        end
    end
endmodule
