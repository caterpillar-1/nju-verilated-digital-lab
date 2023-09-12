module frequency_divider_1Khz_1hz(
    input in,
    input rst,
    output reg out
);
    reg [9:0] count;

    initial begin
        count = 0;
        out = 0;
    end

    always @(posedge in) begin
        if (rst) begin
            count <= 0;
            out <= 0;
        end else if (count == 10'd999) begin
            out <= 1;
            count <= 0;
        end else begin
            out <= 0;
            count <= count + 1;
        end
    end
endmodule
