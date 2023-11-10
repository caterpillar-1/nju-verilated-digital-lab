module vga_render(
  input [2:0] fg_color,
  input [2:0] bg_color,
  input vga_bit,
  output [11:0] vga_data
);

reg [11:0] palette [7:0];

initial begin
  $readmemh("../resources/vga_color.txt", palette);
end

assign vga_data = 
  (vga_bit) ? 
  palette[fg_color] : 
  palette[bg_color];

endmodule
