module ethernet_frame_generator (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [15:0] sample_data,
    output wire busy,
    output wire tx_valid,
    output wire [7:0] tx_data,
    output wire tx_last
);

    udp_tx u1 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .sample_data(sample_data),
        .busy(busy),
        .tx_valid(tx_valid),
        .tx_data(tx_data),
        .tx_last(tx_last)
    );

endmodule