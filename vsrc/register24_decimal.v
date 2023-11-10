module register24_decimal(
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
            if (low == 4'd9) begin
                low <= 0;
                high <= high + 1;
                cout <= 0;
            end else if (low == 4'd3 && high == 4'd2) begin
                low <= 0;
                high <= 0;
                cout <= 1;
            end else if (low == 4'd3 && high != 4'd2) begin
                low <= 0;
                high <= high + 1;
                cout <= 0;
            end else begin
                low <= low + 1;
                cout <= 0;
                high <= high;
            end
        end else if (sub) begin
            if (low == 4'd0 && high == 4'd0) begin
                low <= 3;
                high <= 2;
            end else if (low == 4'd0 && high != 4'd0) begin
                low <= 9;
                high <= high - 1;
            end else begin
                low <= low - 1;
                high <= high;
            end
            cout <= 0;
        end else begin
            low <= low;
            high <= high;
            cout <= 0;
        end
        end
    end

//    always @(posedge add) begin
//        if (low == 4'd3 && high == 4'd2 && !set) begin
//            cout <= 1;
//        end else begin
//            cout <= 0;
//        end
//        if (low == 4'd9) begin
//            low <= 0;
//            high <= high + 1;
//        end else if (low == 4'd3) begin
//            if (high == 4'd2) begin
//                high <= 0;
//                low <= 0;
//            end else begin
//                high <= high;
//                low <= low + 1;
//            end
//        end else begin
//            if (add) low <= low + 1;
//            else low <= low;
//        end
//    end
    
//    always @(posedge sub) begin
//        if (!add) begin
//            if (low == 4'd0) begin
//                if (high == 4'd0) begin
//                    high <= 2;
//                    low <= 3;
//                end else begin
//                    high <= high - 1;
//                    low <= 9;
//                end
//            end else begin
//                if (sub) low <= low - 1;
//                else low <= low;
//            end
//        end
//    end
endmodule
