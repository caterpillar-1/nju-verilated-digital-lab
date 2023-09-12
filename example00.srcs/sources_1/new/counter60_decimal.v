module counter60_decimal(
    input in,
    input rst,
    output [3:0] low,
    output [3:0] high,
    output out
);
    wire in_high;

    counter10 low_counter(.in(in), .rst(rst), .out(in_high), .count(low));
    counter10 #(.MAX(6)) high_counter(.in(in_high), .rst(rst), .out(out), .count(high));
endmodule
