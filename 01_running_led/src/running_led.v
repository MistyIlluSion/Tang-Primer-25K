module RunningLED
(
    input clk,          // 50M Hz clock
    input rst,          // Reset from button
    output [7:0] oLED   // Output for 8-bit LEDs
);

localparam COUNTER_MAX = 32'd9_999_999;

reg [32:0] counter = 32'b0;
reg [7:0] rLED = 8'b1111_1110;

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        rLED <= 8'b1111_1110;
        counter <= counter + 1'b1;
    end else begin
        if ( counter <= COUNTER_MAX ) begin
            counter <= counter + 1'b1;
        end else begin
            counter <= 32'b0;
            rLED <= {rLED[6:0], rLED[7]};
        end
    end
end

assign oLED = rLED;

endmodule