module frequency_divider_100Mhz_1Khz (
    input in,
    input rst,
    output reg out
);
    reg [9:0] level_0; // output per 1000 ticks
    reg in_level_1;
    reg [6:0] level_1; // output per 1000000 ticks

    initial begin
        level_0 = 0;
        level_1 = 0;
        in_level_1 = 0;
    end

    always @(posedge in) begin
        if (rst) begin
            in_level_1 <= 0;
            level_0 <= 0;
        end else if (level_0 == 10'd999) begin
            in_level_1 <= 1;
            level_0 <= 0;
        end else begin
            in_level_1 <= 0;
            level_0 <= level_0 + 1;
        end 
    end

    always @(posedge in_level_1 or posedge rst) begin
        if (rst) begin
            out <= 0;
            level_1 <= 0;
        end else if (level_1 == 7'd99) begin
            out <= 1;
            level_1 <= 0;
        end else begin
            out <= 0;
            level_1 <= level_1 + 1;
        end
    end
endmodule
