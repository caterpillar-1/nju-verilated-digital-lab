module terminal(
  input clk,
  input in_valid,
  input [7:0] in_ascii,
  output reg we,
  output reg [4:0] wr_addr,
  output reg [6:0] wc_addr,
  output reg [2:0] fg_color,
  output reg [2:0] bg_color,
  output reg [7:0] w_ascii
);

parameter ascii_enter = 8'h0A;

initial begin
  wr_addr = 0;
  wc_addr = 0;
  we = 1;
  w_ascii = 0;
  fg_color = 7;
  bg_color = 0;
end

parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b11;
reg [1:0] state;

initial begin
  state = S0;
end

reg [31:0] cnt;
reg [7:0] last_ascii;

always @(posedge clk) begin
  if (we == 1) begin
    we <= 0;
  end else begin
    if (state == S0) begin
      if (in_valid) begin
        state <= S1;
        last_ascii <= in_ascii;
        if (in_ascii == ascii_enter) begin
          if (wr_addr == 5'd29) begin
            wr_addr <= 0;
          end else begin
            wr_addr <= wr_addr + 1;
          end
          wc_addr <= 0;
        end else begin
          we <= 1;
        end
      end
    end else if (state == S1) begin
      we <= 0;
      state <= S2;
      cnt <= 0;
      if (last_ascii != ascii_enter) begin
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
    end else if (state == S2) begin
      if (!in_valid) begin
        state <= S0;
      end else if ((in_ascii != last_ascii) || cnt == 32'd24999999) begin
        state <= S0;
      end else begin
        cnt <= cnt + 1;
      end
    end
  end
end

assign w_ascii = in_ascii;

endmodule
