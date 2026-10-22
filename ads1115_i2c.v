module ads1115_i2c (
    input wire clk,
    input wire reset,
    inout wire sda,
    output reg scl,
    output reg [15:0] adc_data,
    output reg adc_valid
);

    assign sda = 1'bz;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            scl <= 1'b1;
            adc_data <= 16'd0;
            adc_valid <= 1'b0;
        end
        else begin
            scl <= ~scl;
            adc_valid <= 1'b0;
        end
    end

endmodule