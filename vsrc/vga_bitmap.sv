module vga_bitmap(
  input [7:0] ascii,
  input [3:0] ir_addr,
  input [3:0] ic_addr,
  output vga_bit
);

reg [11:0] bitmap [4095:0];

initial begin
  $readmemh("../resources/vga_font.txt", bitmap);
end

wire [11:0] pixel_row;
assign pixel_row = bitmap[{ascii, ir_addr}];
assign vga_bit = pixel_row[ic_addr];

endmodule
