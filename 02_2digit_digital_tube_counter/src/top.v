//---------- BCD counter with enable ----------//
module bcd_counter
(
    input clk,
    input reset,
    input enable,
    output [3:0] o_q
);

reg [3:0] r_q = 4'b0;

always @ (posedge clk or posedge reset) begin
    if (reset)
        r_q <= 4'b0;
    else
        if (enable)
            r_q <= (r_q == 4'd9) ? 4'd0 : r_q + 1'b1;
end

assign o_q = r_q;

endmodule


//---------- top ----------//
module digital_tube_counter
(
    input clk,  // 50MHz clock
    input reset,  // reset from button
    output o_digit_sel,  // select one of two digits
    output [6:0] o_digit_pins  // GFEDCBA
);

reg r_digit_sel = 1'b0;
reg [6:0] r_digit_pins = 7'b1111111;

reg clk_1hz = 1'b0;
reg [31:0] counter_clk_1hz = 32'b0;
localparam COUNTER_CLK_1HZ_MAX = 24_999_999;

wire [3:0] digit_ones;
wire [3:0] digit_tens;
wire enable_tens;

reg clk_1k = 1'b0;
reg [23:0] counter_clk_1k = 24'b0;
localparam COUNTER_CLK_1K_MAX = 24_999;


//---------- Digital Tube for Number 0~9 ----------//
localparam DIGIT_NUM0 = 7'b1000000;
localparam DIGIT_NUM1 = 7'b1111001;
localparam DIGIT_NUM2 = 7'b0100100;
localparam DIGIT_NUM3 = 7'b0110000;
localparam DIGIT_NUM4 = 7'b0011001;
localparam DIGIT_NUM5 = 7'b0010010;
localparam DIGIT_NUM6 = 7'b0000010;
localparam DIGIT_NUM7 = 7'b1111000;
localparam DIGIT_NUM8 = 7'b0000000;
localparam DIGIT_NUM9 = 7'b0010000;


//---------- 1Hz clk ----------//
always @ (posedge clk or posedge reset) begin
    if (reset)
        clk_1hz = 1'b0;
    else begin
        if (counter_clk_1hz < COUNTER_CLK_1HZ_MAX)
            counter_clk_1hz <= counter_clk_1hz + 1'b1;
        else begin
            counter_clk_1hz <= 32'b0;
            clk_1hz <= ~clk_1hz;
        end
    end
end


//---------- 1kHz clk ----------//
always @ (posedge clk) begin
    if (counter_clk_1k < COUNTER_CLK_1K_MAX)
        counter_clk_1k <= counter_clk_1k + 1'b1;
    else begin
        counter_clk_1k <= 24'b0;
        clk_1k <= ~clk_1k;
    end
end


//---------- digit ones and tens ----------//
bcd_counter u_digit_ones ( clk_1hz, reset, 1'b1, digit_ones[3:0] );
bcd_counter u_digit_tens ( clk_1hz, reset, enable_tens, digit_tens[3:0] );
assign enable_tens = (digit_ones[3:0] == 4'd9);


//---------- Display 2 digits ----------//
always @ (posedge clk_1k) begin
    r_digit_sel <= ~r_digit_sel;
end

always @ (posedge clk_1k) begin
    if (r_digit_sel) begin
        case (digit_tens)
            4'd0: r_digit_pins <= DIGIT_NUM0;
            4'd1: r_digit_pins <= DIGIT_NUM1;
            4'd2: r_digit_pins <= DIGIT_NUM2;
            4'd3: r_digit_pins <= DIGIT_NUM3;
            4'd4: r_digit_pins <= DIGIT_NUM4;
            4'd5: r_digit_pins <= DIGIT_NUM5;
            4'd6: r_digit_pins <= DIGIT_NUM6;
            4'd7: r_digit_pins <= DIGIT_NUM7;
            4'd8: r_digit_pins <= DIGIT_NUM8;
            4'd9: r_digit_pins <= DIGIT_NUM9;
            default: r_digit_pins <= 7'b1111111;
        endcase
    end
    else begin
        case (digit_ones) 
            4'd0: r_digit_pins <= DIGIT_NUM0;
            4'd1: r_digit_pins <= DIGIT_NUM1;
            4'd2: r_digit_pins <= DIGIT_NUM2;
            4'd3: r_digit_pins <= DIGIT_NUM3;
            4'd4: r_digit_pins <= DIGIT_NUM4;
            4'd5: r_digit_pins <= DIGIT_NUM5;
            4'd6: r_digit_pins <= DIGIT_NUM6;
            4'd7: r_digit_pins <= DIGIT_NUM7;
            4'd8: r_digit_pins <= DIGIT_NUM8;
            4'd9: r_digit_pins <= DIGIT_NUM9;
            default: r_digit_pins <= 7'b1111111;
        endcase
    end
end


assign o_digit_pins = r_digit_pins;
assign o_digit_sel = r_digit_sel;

endmodule