`timescale 1ns/1ps

module aes_sub_bytes (
    input  logic [127:0] data_in,
    output logic [127:0] data_out
);

    genvar i;

    generate
        for (i = 0; i < 16; i = i + 1) begin : GEN_SBOX

            aes_sbox u_sbox (
                .data_in  (data_in[i*8 +: 8]),
                .data_out (data_out[i*8 +: 8])
            );

        end
    endgenerate

endmodule