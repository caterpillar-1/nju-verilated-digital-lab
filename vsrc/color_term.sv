module color_term(
  input clk,
  output reg we,
  output reg [4:0] wr_addr,
  output reg [6:0] wc_addr,
  output reg [2:0] fg_color,
  output reg [2:0] bg_color,
  output reg [7:0] w_ascii
);

initial begin
  wr_addr = 0;
  wc_addr = 0;
  we = 1;
  w_ascii = 0;
  fg_color = 0;
  bg_color = 7;
end

reg clk_slow;
reg [19:0] clk_slow_buf;

initial begin
  clk_slow_buf = 0;
  clk_slow = 0;
end

always @(posedge clk) begin
  if (clk_slow_buf == 20'd49999) begin
    clk_slow_buf <= 0;
    clk_slow <= ~clk_slow;
  end else begin
    clk_slow_buf <= clk_slow_buf + 1;
  end
end

always @(posedge clk_slow) begin
  if (wc_addr == 7'd69) begin
    if (wr_addr == 5'd29) begin
      wc_addr <= 0;
      wr_addr <= 0;
    end else begin
      wc_addr <= 0;
      wr_addr <= wr_addr + 1;
    end
  end else begin
    wc_addr <= wc_addr + 1;
  end
end

reg [7:0] lsfr;

initial begin
  lsfr = 0;
end

always @(posedge clk_slow) begin
//  if (lsfr == 0) begin
//    lsfr <= 1;
//  end else begin
//    lsfr <= {lsfr[4]^lsfr[3]^lsfr[2]^lsfr[0], lsfr[7:1]};
    lsfr <= lsfr + 1;
//  end
  fg_color <= fg_color + 1;
  bg_color <= bg_color - 1;
end

assign w_ascii = lsfr;

endmodule
