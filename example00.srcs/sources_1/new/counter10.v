module counter10(
    input in,
    input rst,
    output reg [3:0] count,
    output reg out
);
    parameter MAX = 10, MIN = 0;

    initial begin
        count = 0;
        out = 0;
    end
    
    always @(posedge in or posedge rst) begin
        if (rst) begin
            count <= 0;
            out <= 0;
        end else if (count == MAX - 1) begin
            out <= 1;
            count <= 0;
        end else begin
            out <= 0;
            count = count + 1;
        end
    end
endmodule
