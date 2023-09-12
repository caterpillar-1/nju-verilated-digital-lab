module lab03_basic_timer_top(
    input [15:0] SW,
    output [15:0] LED,
    output reg CA, CB, CC, CD, CE, CF, CG, DP,
    output reg [7:0] AN,
    input BTNC, BTNU, BTNL, BTNR, BTND,
    input CLK100MHZ
);
    
    wire [7:0] raw_low, raw_high;
    reg sel;
    
    basic_timer timer(
        .clk(CLK100MHZ), 
        .rst(SW[0]), 
        .start(SW[1]), 
        .stop(SW[2]), 
        .raw_low_display(raw_low), 
        .raw_high_display(raw_high), 
        .out(LED[0])
    );
    
    initial begin
        sel = 0;
    end
    
    always @(posedge CLK100MHZ) begin
        if (sel) begin
            AN <= 8'b11111110;
            {DP, CG, CF, CE, CD, CC, CB, CA} <= ~raw_low;
        end else begin
            AN <= 8'b11111101;
            {DP, CG, CF, CE, CD, CC, CB, CA} <= ~raw_high;
        end
        sel <= ~sel;
    end
endmodule
