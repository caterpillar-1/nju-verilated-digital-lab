module register100_decimal(
    input clk,
    input add,
    input sub,
    input rst,
    input hold,
    output reg [3:0] low, high,
    output reg cout
);
    initial begin
        low = 0;
        high = 0;
        cout = 0;
    end

    always @(posedge clk) begin
        if (rst) begin
            high <= 0;
            low <= 0;
            cout <= 0;
        end else if (hold) begin
            high <= high;
            low <= low;
            cout <= cout;
        end else begin
        if (add) begin
            if (low == 4'd9 && high != 4'd9) begin
                high <= high + 1;
                low <= 0;
                cout <= 0;
            end else if (low == 4'd9 && high == 4'd9) begin
                high <= 0;
                low <= 0;
                cout <= 1;
            end else if (low != 4'd9) begin
                low <= low + 1;
                high <= high;
                cout <= 0;
            end else begin
                low <= low;
                high <= high;
                cout <= 0;
            end
        end else if (sub) begin
            if (low == 4'd0 && high == 4'd0) begin
                high <= 9;
                low <= 9;
            end else if (low == 4'd0 &&high != 4'd0) begin
                high <= high - 1;
                low <= 9;
            end else begin
                high <= high;
                low <= low - 1;
            end
            cout <= 0;
        end else begin
            high <= high;
            low <= low;
            cout <= 0;
        end
        end
    end

endmodule
