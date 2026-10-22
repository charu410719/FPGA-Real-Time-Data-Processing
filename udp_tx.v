module udp_tx (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [15:0] sample_data,
    output reg busy,
    output reg tx_valid,
    output reg [7:0] tx_data,
    output reg tx_last
);

    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            busy <= 0;
            tx_valid <= 0;
            tx_data <= 0;
            tx_last <= 0;
        end
        else begin
            tx_valid <= 0;
            tx_last <= 0;

            case (state)
                0: begin
                    busy <= 0;
                    if (start) begin
                        busy <= 1;
                        state <= 1;
                    end
                end

                1: begin
                    tx_data <= sample_data[15:8];
                    tx_valid <= 1;
                    state <= 2;
                end

                2: begin
                    tx_data <= sample_data[7:0];
                    tx_valid <= 1;
                    tx_last <= 1;
                    state <= 0;
                end
            endcase
        end
    end

endmodule