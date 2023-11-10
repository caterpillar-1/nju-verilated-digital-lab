module keyboard(
    input clk,
    input rst,
    input ready,
    input overflow,
    input [7:0] data,
    output reg set_rst,
    output reg set_next,
    output reg ctrl,
    output reg alt,
    output reg shift,
    output reg caps,
    output reg [7:0] key
);

parameter S0 = 0, S1 = 1;
parameter k_ctrl = 8'h14, k_alt = 8'h11, k_shift = 8'h12, k_break = 8'hF0, k_caps = 8'h58;

reg [2:0] state;

initial begin
    state = S0;
end

always @(posedge clk) begin
    if (rst) begin
        set_rst <= 1;
        set_next <= 0;
        ctrl <= 0;
        alt <= 0;
        shift <= 0;
        caps <= 0;
        key <= 0;
    end else if (overflow) begin
        set_rst <= 1;
    end else if (set_rst) begin
        set_rst <= 0;
    end else if (set_next) begin
        set_next <= 0;
    end else begin
        if (state == S0) begin  
            if (ready) begin
                set_next <= 1;
                if (data == k_break) begin
                    state <= S1;
                end else if (data == k_ctrl) begin
                    ctrl <= 1;
                    state <= S0;
                end else if (data == k_alt) begin
                    alt <= 1;
                    state <= S0;
                end else if (data == k_shift) begin
                    shift <= 1;
                    state <= S0;
                end else if (data == k_caps) begin
                    caps <= ~caps;
                    state <= S0;
                end else begin
                    key <= data;
                    state <= S0;
                end
             end else begin
                key <= key;
             end
        end else if (state == S1) begin
            if (ready) begin
                set_next <= 1;
                state <= S0;
                if (data == k_break) begin
                    set_rst <= 1;
                end else if (data == k_ctrl) begin
                    ctrl <= 0;
                end else if (data == k_alt) begin
                    alt <= 0;
                end else if (data == k_shift) begin
                    shift <= 0;
                end else if (data == k_caps) begin
                    caps <= caps;
                end else begin
                    key <= 0;
                end
            end else begin
                key <= key;
            end
        end else begin
            state <= S0;
            key <= 0;
        end
    end
end
        
endmodule
