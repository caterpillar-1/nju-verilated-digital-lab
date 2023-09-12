module clk_1_8_second(
    input in, // 1Khz
    output reg out
);
    reg [9:0] cache1;
    reg i_cache2;
    reg [9:0] cache2;
    reg i_cache3;
    reg [9:0] cache3;
        
    reg pulse;
    
    initial begin
        cache1 = 0;
        cache2 = 0;
        cache3 = 0;
        pulse = 0;
        i_cache2 = 0;
        i_cache3 = 0;
        out = 0;
    end
    
//    always @(posedge in) begin
//        if (cache1 == 10'd999) begin
//            cache1 <= 0;
//            i_cache2 <= 1;
//        end else begin 
//            cache1 <= cache1 + 1;
//            i_cache2 <= 0;
//        end
//    end
    
//    always @(posedge i_cache2) begin
//        if (cache2 == 10'd999) begin
//            cache2 <= 0;
//            i_cache3 <= 1;
//        end else begin 
//            cache2 <= cache2 + 1;
//            i_cache3 <= 0;
//        end
//    end

    always @(*) begin
        i_cache3 = in;
    end

    
    always @(posedge i_cache3) begin
        if (cache3 == 10'd49) begin
            cache3 <= 0;
            pulse <= 1;
        end else begin 
            cache3 <= cache3 + 1;
            pulse <= 0;
        end
    end
    
    always @(posedge pulse) begin
        out <= ~out;
    end
endmodule
