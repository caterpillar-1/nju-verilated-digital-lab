module alu_test();
  reg clk;
  reg rst;
  reg [3:0] a_in, b_in;
  reg [1:0] op_in;
  reg in_valid;
  wire [3:0] out;
  wire out_valid;

  alu alu(
    .clk(clk),
    .rst(rst),
    .op_in(op_in),
    .a_in(a_in),
    .b_in(b_in),
    .out(out),
    .out_valid(out_valid)
  );

  initial begin
    forever begin
      #10 clk = ~clk;
    end
  end

  initial begin
    rst = 1; #20;
    rst = 0; #20;
    a_in = 4'd9; b_in = 4'd6; in_valid = 1; op_in = 2'b01; #10;
    a_in = 4'd1; b_in = 4'd3; in_valid = 1; op_in = 2'b01; #20;
    a_in = 4'b0; b_in = 4'b1; in_valid = 1; op_in = 2'b10; #20;
    $finish(0);
  end
endmodule
