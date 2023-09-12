`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2023 03:29:25 PM
// Design Name: 
// Module Name: static_output_test
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


module static_output_test(
    input [15:0] sw,
    output [15:0] led,
    input [4:0] btn,
    output [31:0] seg_content,
    output [7:0] seg_dp
);
    assign led = sw | {11'b0, btn};
    
    assign seg_content = 32'h0a1b2c3d;
    assign seg_dp = 8'b10101010;
endmodule
