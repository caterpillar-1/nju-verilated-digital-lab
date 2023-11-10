module clkgen(
    input in,
    output reg out
);

parameter freq_in = 100000000, freq_out = 1000;
parameter limit = freq_in/2/freq_out - 1;

reg [31:0] cnt;

initial begin
    cnt = 0;
end

always @(posedge in) begin
    if (cnt >= limit) begin
        out <= ~out;
        cnt <= 0;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule
