/*
    @param in 4-bit binary (0-f)
    @param out 7-bit output (active high)
    
    +--0--+
    5     1
    +--6--+
    4     2
    +--3--+
*/

module led7seg(
    input [3:0] in,
    output reg [6:0] out,
    input en
);
    always @(*) begin
        if (en) begin
        case (in)
            4'd00: out = 7'b0111111;
            4'd01: out = 7'b0000110;
            4'd02: out = 7'b1011011;
            4'd03: out = 7'b1001111;
            4'd04: out = 7'b1100110;
            4'd05: out = 7'b1101101;
            4'd06: out = 7'b1111101;
            4'd07: out = 7'b0000111;
            4'd08: out = 7'b1111111;
            4'd09: out = 7'b1101111;
            4'd10: out = 7'b1110111; // A
            4'd11: out = 7'b1111100; // b
            4'd12: out = 7'b0111001; // C
            4'd13: out = 7'b1011110; // d
            4'd14: out = 7'b1111001; // E
            4'd15: out = 7'b1110001; // F
            default: out = 7'b1001111; // inv E
        endcase
        end else out = 7'd0;
    end
endmodule
