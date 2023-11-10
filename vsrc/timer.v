// verilator lint_off SYNCASYNCNET
// verilator lint_off UNUSED
// verilator lint_off PINCONNECTEMPTY
module timer(
    input clk, // 1Khz
    input [13:0] sw,
    input [4:0] btn,
    output [31:0] seg_content,
    output [7:0] seg_dp,
    output [7:0] seg_en
);
    assign seg_en = 8'b11111111;
    assign seg_dp = 8'b00000100;
    
    reg clk_1_100_second;
    reg [3:0] cache;
    
    initial begin
        cache = 0;
        clk_1_100_second = 0;
    end
    
    always @(posedge clk) begin
        if (cache == 4'd4) begin
            cache <= 0;
            clk_1_100_second <= ~clk_1_100_second;
        end else begin
            cache <= cache + 1;
            clk_1_100_second <= clk_1_100_second;
        end
    end
    
    wire rst;
    wire b_start_pause, b_reset; 
    
    assign b_start_pause = btn[4];
    assign b_reset = btn[3];
    
    reg running;
    wire hold;
    
    always @(posedge b_reset or posedge b_start_pause) begin
        if (b_reset) begin
            running <= 0;
        end else if (b_start_pause) begin
            running <= ~running;
        end else running <= running;
    end
    
    wire h_in, m_in, s_in;
    wire ms_c, s_c, m_c;
    
    assign hold = ~running;
    
    initial begin 
        running = 0;
    end
    
    
    register100_decimal reg_ms(
        .clk(clk_1_100_second),
        .add(clk_1_100_second),
        .sub(1'b0),
        .rst(b_reset),
        .hold(hold),
        .low(seg_content[3:0]),
        .high(seg_content[7:4]),
        .cout(s_in)
    );
    
    register100_decimal reg_h(
        .clk(clk_1_100_second),
        .add(h_in),
        .sub(1'b0),
        .rst(b_reset),
        .hold(hold),
        .low(seg_content[27:24]),
        .high(seg_content[31:28]),
        .cout()
    );
    
    register60_decimal reg_m(
        .clk(clk_1_100_second),
        .add(m_in),
        .sub(1'b0),
        .rst(b_reset),
        .hold(hold),
        .low(seg_content[19:16]),
        .high(seg_content[23:20]),
        .cout(h_in)
    );
    
    register60_decimal reg_s(
        .clk(clk_1_100_second),
        .add(s_in),
        .sub(1'b0),
        .rst(b_reset),
        .hold(hold),
        .low(seg_content[11:8]),
        .high(seg_content[15:12]),
        .cout(m_in)
    );
    
    
endmodule
// verilator lint_on SYNCASYNCNET
// verilator lint_on UNUSED
// verilator lint_on PINCONNECTEMPTY
