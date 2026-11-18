`timescale 1ns/1ps

module aes_add_round_key (
    input  logic [127:0] data_in,
    input  logic [127:0] round_key,
    output logic [127:0] data_out
);

    assign data_out = data_in ^ round_key;

endmodule