`timescale 1ns/1ps
module counter10_test();
    reg clk;
    reg rst;
    
    wire [3:0] count;
    wire out;
    
    counter10 counter10(.in(clk), .out(out), .rst(rst), .count(count));
    
    initial begin
        clk = 0;
        forever begin
            clk = ~clk;
            #1;
        end
    end
    
    initial begin
        rst = 0;
        #50;
        rst = 1;
        #10;
        rst = 0;
    end
    
endmodule