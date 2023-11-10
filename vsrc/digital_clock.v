module digital_clock(
    input clk, // 1Khz
    input [15:0] sw,
    input [4:0] btn,
    output reg [31:0] seg_content, 
    output reg [7:0] seg_dp,
    output reg [7:0] seg_en,
    output reg [15:0] led
);
    wire [1:0] mode;
    assign mode = sw[15:14];
    
    reg [13:0] c_sw, t_sw, a_sw;
    reg [4:0] c_btn, t_btn, a_btn;
    
    wire [31:0] c_content, t_content, a_content;
    wire [7:0] c_dp, t_dp, a_dp;
    wire [7:0] c_en, t_en, a_en;
    
    
    clock clock(.clk(clk), .sw(c_sw), .btn(c_btn), .seg_content(c_content), .seg_dp(c_dp), .seg_en(c_en));
    timer timer(.clk(clk), .sw(t_sw), .btn(t_btn), .seg_content(t_content), .seg_dp(t_dp), .seg_en(t_en));
    alarm alarm(.clk(clk), .sw(a_sw), .btn(a_btn), .seg_content(a_content), .seg_dp(a_dp), .seg_en(a_en));
    
    always @(*) begin
        case (mode)
            2'b00: begin seg_content = 0; seg_dp = 0; seg_en = 0; end
            2'b01: begin seg_content = c_content; seg_dp = c_dp; seg_en = c_en; end
            2'b10: begin seg_content = t_content; seg_dp = t_dp; seg_en = t_en; end
            2'b11: begin seg_content = a_content; seg_dp = a_dp; seg_en = a_en; end
            default: begin seg_content = 0; seg_dp = 0; seg_en = 0; end
        endcase
    end
    
    always @(*) begin
        if (mode == 2'b01) begin
            c_btn = btn;
            c_sw = sw[13:0];
        end else begin
            c_btn = 0;
            c_sw = 0;
        end
    end
    
    always @(*) begin
        if (mode == 2'b10) begin
            t_btn = btn;
            t_sw = sw[13:0];
        end else begin
            t_btn = 0;
            t_sw = 0;
        end
    end
    
    always @(*) begin
        if (mode == 2'b11) begin
            a_btn = btn;
            a_sw = sw[13:0];
        end else begin
            a_btn = 0;
            a_sw = 0;
        end
    end
    
    always @(*) begin
        if (c_content[23:8] == a_content[23:8]) begin
            led = ~16'b0;
        end else begin
            led = 16'b0;
        end
    end
    
endmodule
