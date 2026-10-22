
module top (
    input wire clk,
    input wire reset,
    inout wire adc_sda,
    output wire adc_scl,
    output wire [7:0] debug_tx_byte,
    output wire debug_tx_valid
);

    wire [15:0] adc_data;
    wire adc_valid;

    wire fifo_full;
    wire fifo_empty;
    wire [15:0] fifo_data;

    wire udp_busy;
    wire tx_valid;
    wire tx_last;
    wire [7:0] tx_data;

    reg fifo_rd_en;

    ads1115_i2c u_adc (
        .clk(clk),
        .reset(reset),
        .sda(adc_sda),
        .scl(adc_scl),
        .adc_data(adc_data),
        .adc_valid(adc_valid)
    );

    fifo u_fifo (
        .clk(clk),
        .reset(reset),
        .wr_en(adc_valid),
        .din(adc_data),
        .rd_en(fifo_rd_en),
        .dout(fifo_data),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            fifo_rd_en <= 1'b0;
        else
            fifo_rd_en <= !fifo_empty && !udp_busy;
    end

    ethernet_frame_generator u_frame (
        .clk(clk),
        .reset(reset),
        .start(fifo_rd_en),
        .sample_data(fifo_data),
        .busy(udp_busy),
        .tx_valid(tx_valid),
        .tx_data(tx_data),
        .tx_last(tx_last)
    );

    ethernet_interface u_eth (
        .clk(clk),
        .reset(reset),
        .tx_valid(tx_valid),
        .tx_data(tx_data),
        .tx_last(tx_last),
        .debug_last_byte(debug_tx_byte),
        .debug_valid(debug_tx_valid)
    );

endmodule
