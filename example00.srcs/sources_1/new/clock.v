// `define DEBUG
module clock(
    input clk,
    input [13:0] sw,
    input [4:0] btn,
    output [31:0] seg_content,
    output [7:0] seg_dp,
    output [7:0] seg_en
);

    assign seg_en = 8'b00111111;

    assign seg_content[31:24] = 0;
    reg second, one_tenth_second;
    
    reg [9:0] cache_l1, cache_l2;
    
    initial begin
        cache_l1 = 0;
        cache_l2 = 0;
        second = 0;
        one_tenth_second = 0;
    end
    
    always @(posedge clk) begin
        if (cache_l1 == 10'd49) begin
            one_tenth_second <= ~one_tenth_second;
            cache_l1 <= 0;
        end else begin
            cache_l1 <= cache_l1 + 1;
            one_tenth_second <= one_tenth_second;
        end
    end
    
    always @(posedge one_tenth_second) begin
        if (cache_l2 == 10'd9) begin
            second <= 1;
            cache_l2 <= 0;
        end else begin
            cache_l2 <= cache_l2 + 1;
            second <= 0;
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
        
    wire m_c, s_c;
    
    register24_decimal reg_h(
        .clk(one_tenth_second),
        .add(h_add),
        .sub(h_sub),
        .rst(1'b0),
        .hold(1'b0),
        .low(seg_content[19:16]),
        .high(seg_content[23:20]),
        .cout()
    );
    
    register60_decimal reg_m(
        .clk(one_tenth_second),
        .add(m_add),
        .sub(m_sub),
        .rst(1'b0),
        .hold(1'b0),
        .low(seg_content[11:8]),
        .high(seg_content[15:12]),
        .cout(m_c)
    );
    
    register60_decimal reg_s(
        .clk(one_tenth_second),
        .add(s_add),
        .sub(s_sub),
        .rst(1'b0),
        .hold(1'b0),
        .low(seg_content[3:0]),
        .high(seg_content[7:4]),
        .cout(s_c)
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
`ifndef DEBUG
            s_add = second;
`else
            s_add = clk;
`endif
            s_sub = 0;
        end
    end
    
    always @(*) begin
        if (m_set) begin
            m_add = b_up;
            m_sub = b_down;
        end else if (s_set) begin
            m_add = 0;
            m_sub = 0;
        end else begin
            m_add = s_c;
            m_sub = 0;
        end
    end
    
    always @(*) begin
        if (h_set) begin
            h_add = b_up;
            h_sub = b_down;
        end else if (m_set) begin
            h_add = 0;
            h_sub = 0;
        end else begin
            h_add = m_c;
            h_sub = 0;
        end
    end
    
    reg splash;
    
    initial begin
        splash = 0;
    end

`ifdef DEBUG
    always @(posedge clk) begin
`else
    always @(posedge second) begin
`endif
        if (setting) begin
            splash <= 0;
        end else begin
            splash <= ~splash;
        end
    end
    
    assign seg_dp[0] = splash;
    assign seg_dp[2] = splash;
    assign seg_dp[4] = splash;
    assign {seg_dp[7:5], seg_dp[3], seg_dp[1]} = 0;
endmodule
