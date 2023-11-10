module keycode_to_ascii(
    input [7:0] keycode,
    input shift,
    output valid,
    output [7:0] ascii
);
    reg [7:0] rom [0:255];
    
    wire [7:0] shifted_keycode = keycode | ({7'b0, shift} << 7);
    
    initial begin
        $readmemh("../resources/keycode_to_ascii.mem", rom, 0, 255);
    end
    
    assign ascii = rom[shifted_keycode];
    assign valid = |ascii;
endmodule
