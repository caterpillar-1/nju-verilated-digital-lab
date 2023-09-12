module alarm(
    input clk,
    input [13:0] sw,
    input [4:0] btn,
    output [31:0] seg_content,
    output [7:0] seg_dp,
    output [7:0] seg_en
);
    assign seg_en = 8'b00111111;
    assign seg_content[31:24] = 0;
    
    reg clk_1_10_second;
    reg [5:0] cache;
    
    initial begin
        cache = 0;
        clk_1_10_second = 0;
    end
    
    always @(posedge clk) begin
        if (cache == 6'd49) begin
            cache <= 0;
            clk_1_10_second <= ~clk_1_10_second;
        end else begin
            cache <= cache + 1;
            clk_1_10_second <= clk_1_10_second;
        end
    end
    
    reg h_add, h_sub, h_set, 
        m_add, m_sub, m_set,
        s_add, s_sub, s_set;

    initial begin
        h_add = 0; h_sub = 0; h_set = 0;
        m_add = 0; m_sub = 0; m_set = 0;
        s_add = 0; s_sub = 0; s_set = 0;
    end

    wire setting = h_set | m_set | s_set;
        
    
    register24_decimal reg_h(
        .clk(clk_1_10_second),
        .add(h_add),
        .sub(h_sub),
        .rst(1'b0),
        .hold(1'b0),
        .low(seg_content[19:16]),
        .high(seg_content[23:20]),
        .cout()
    );
    
    register60_decimal reg_m(
        .clk(clk_1_10_second),
        .add(m_add),
        .sub(m_sub),
        .rst(1'b0),
        .hold(1'b0),
        .low(seg_content[11:8]),
        .high(seg_content[15:12]),
        .cout()
    );
    
    register60_decimal reg_s(
        .clk(clk_1_10_second),
        .add(s_add),
        .sub(s_sub),
        .rst(1'b0),
        .hold(1'b0),
        .low(seg_content[3:0]),
        .high(seg_content[7:4]),
        .cout()
    );
    
    always @(*) begin
        if (sw[0]) begin
            s_set = 1;
            m_set = 0;
            h_set = 0;
        end else if (sw[1]) begin
            s_set = 0;
            m_set = 1;
            h_set = 0;
        end else if (sw[2]) begin
            s_set = 0;
            m_set = 0;
            h_set = 1;
        end else begin  
            s_set = 0;
            m_set = 0;
            h_set = 0;
        end
    end
    
    wire b_center, b_up, b_down, b_left, b_right;
    assign {b_center, b_up, b_down, b_left, b_right} = btn;
    
    
    always @(*) begin
        if (s_set) begin
            s_add = b_up;
            s_sub = b_down;
        end else begin
            s_add = 0;
            s_sub = 0;
        end
    end
    
    always @(*) begin
        if (m_set) begin
            m_add = b_up;
            m_sub = b_down;
        end else begin
            m_add = 0;
            m_sub = 0;
        end
    end
    
    always @(*) begin
        if (h_set) begin
            h_add = b_up;
            h_sub = b_down;
        end else begin
            h_add = 0;
            h_sub = 0;
        end
    end
    
endmodule
