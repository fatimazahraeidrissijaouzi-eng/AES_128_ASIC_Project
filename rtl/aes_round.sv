
`timescale 1ns/1ps

module aes_round (
    input  wire [127:0] data_in,
    input  wire [127:0] round_key,
    output wire [127:0] data_out
);

    wire [127:0] sub_out;
    wire [127:0] shift_out;
    wire [127:0] mix_out;

    // Step 1: SubBytes
    aes_sub_bytes u_sub_bytes (
        .data_in(data_in),
        .data_out(sub_out)
    );

    // Step 2: ShiftRows
    aes_shift_rows u_shift_rows (
        .data_in(sub_out),
        .data_out(shift_out)
    );

    // Step 3: MixColumns
    aes_mix_columns u_mix_columns (
        .data_in(shift_out),
        .data_out(mix_out)
    );

    // Step 4: AddRoundKey
    aes_add_round_key u_add_round_key (
        .data_in(mix_out),
        .round_key(round_key),
        .data_out(data_out)
    );

endmodule