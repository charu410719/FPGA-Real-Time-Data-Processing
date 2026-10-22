module ethernet_interface (
    input wire clk,
    input wire reset,
    input wire tx_valid,
    input wire [7:0] tx_data,
    input wire tx_last,
    output reg [7:0] debug_last_byte,
    output reg debug_valid
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            debug_last_byte <= 0;
            debug_valid <= 0;
        end
        else begin
            debug_valid <= tx_valid;

            if (tx_valid)
                debug_last_byte <= tx_data;
        end
    end

endmodule