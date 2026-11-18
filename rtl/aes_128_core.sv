
`timescale 1ns/1ps

module aes_128_core (
    input  wire [127:0] plaintext,
    input  wire [127:0] cipher_key,
    output wire [127:0] ciphertext
);

    // 11 round keys, 128 bits each
    wire [1407:0] round_keys;

    // State after initial AddRoundKey and each round
    wire [127:0] state [0:10];

    wire [127:0] final_sub;
    wire [127:0] final_shift;

    // Key Expansion
    aes_key_expansion u_key_expansion (
        .key_in(cipher_key),
        .round_keys(round_keys)
    );

    // Initial AddRoundKey
    aes_add_round_key u_initial_key (
        .data_in(plaintext),
        .round_key(round_keys[1407 -: 128]),
        .data_out(state[0])
    );

    // Rounds 1 to 9
    genvar r;

    generate
        for (r = 1; r <= 9; r = r + 1) begin : GEN_ROUNDS

            aes_round u_round (
                .data_in(state[r-1]),
                .round_key(round_keys[1407-128*r -: 128]),
                .data_out(state[r])
            );

        end
    endgenerate

    // Final round: NO MixColumns
    aes_sub_bytes u_final_sub (
        .data_in(state[9]),
        .data_out(final_sub)
    );

    aes_shift_rows u_final_shift (
        .data_in(final_sub),
        .data_out(final_shift)
    );

    aes_add_round_key u_final_key (
        .data_in(final_shift),
        .round_key(round_keys[127:0]),
        .data_out(state[10])
    );

    assign ciphertext = state[10];

endmodule