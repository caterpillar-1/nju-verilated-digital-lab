`timescale 1ns / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2023 09:03:48 AM
// Design Name: 
// Module Name: clk_second_test
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


module clk_second_test();
    reg in;
    wire out;
    
    clk_second clk_second(.in(in), .out(out));
    
    initial begin
        in = 0;
        forever begin
            #10;
            in = ~in;
        end
    end
        
endmodule
