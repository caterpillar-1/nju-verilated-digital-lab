`timescale 1ns/1ns
module basic_timer_test();
    reg clk, rst, start, stop;
    wire [7:0] low_display, high_display;
    wire out;
    
    basic_timer basic_timer(
        .clk(clk),
        .rst(rst),
        .start(start),
        .stop(stop),
        .raw_low_display(low_display),
        .raw_high_display(high_display),
        .out(out)
    );
    
    initial begin
        clk = 0;
        forever begin
            #1;
            clk = ~clk;
        end
    end
    
    initial begin
        rst = 1;
        #10;
        rst = 0;
        #10;
        start = 1;
        stop = 0;
        #100;
        start = 0;
        repeat (1000)
            #10_0000_0000;
        $finish;
    end
    
endmodule