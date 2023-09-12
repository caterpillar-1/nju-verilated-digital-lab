`timescale 1ns/1ps
module counter60_decimal_test();
    reg in;
    reg rst;
    wire [3:0] low, high;
    wire out;
    
    counter60_decimal counter60_decimal(
        .in(in), 
        .rst(rst), 
        .low(low), 
        .high(high), 
        .out(out)
    );
    
    initial begin
        in = 0;
        forever begin
            #1;
            in = ~in;
        end
    end
    
    initial begin
        rst = 0;
        #120;
        rst = 1;
        #10;
        rst = 0;
        #200;
        $finish;
    end
endmodule