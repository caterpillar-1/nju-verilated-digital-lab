module basic_timer (
    input      clk,
    input      rst,
    input      start,
    input      stop,
    output reg [7:0] raw_low_display,
    output reg [7:0] raw_high_display,
    output reg out
);
    reg low_en, high_en;
    reg counting;
    wire counting_second;

    wire [3:0] low, high;
    
    wire second, done;

    frequency_divider_100Mhz_1Khz frequency_divider_100Mhz_1Khz(
        .in(clk), 
        .rst(rst), 
        .out(milisecond)
    );
    frequency_divider_1Khz_1hz frequency_divider_1Khz_1hz(
        .in(milisecond), 
        .rst(rst), 
        .out(second)
    );
    
    counter60_decimal counter60_decimal(
        .in(counting_second), 
        .rst(rst), 
        .low(low), 
        .high(high), 
        .out(done)
    );
    
    wire [6:0] low_display, high_display;

    led7seg low_seg(
        .in(low), 
        .out(low_display[6:0]),
        .en(low_en)
    );
    
    led7seg high_seg(
        .in(high), 
        .out(high_display[6:0]), 
        .en(high_en)
    );
    
    reg last_done;
    
    always @(posedge done or posedge second) begin
        if (!last_done & done) begin
            out <= 1;
        end else begin
            out <= 0;
        end
        last_done <= done;
    end
    
    initial begin
        raw_low_display[7] = 0;
        raw_high_display[7] = 0;
    end
    
    always @(posedge second) begin
        raw_low_display[7] <= ~raw_low_display[7];
        raw_low_display[6:0] <= low_display;
        raw_high_display[6:0] <= high_display;
    end
    
    initial begin
        low_en = 1;
        high_en = 1;
    end
    
    always @(posedge second) begin
        if (counting) begin
            low_en <= 1;
            high_en <= 1;
        end else begin
            low_en <= ~low_en;
            high_en <= ~high_en;
        end
    end
    
    initial begin
        counting = 0;
    end
    
    always @(posedge second) begin
        if (start) begin
            counting <= 1;
        end else if (stop) begin
            counting <= 0;
        end
     end
     
     assign counting_second = (counting) ? second : 0;

endmodule //basic_timer
