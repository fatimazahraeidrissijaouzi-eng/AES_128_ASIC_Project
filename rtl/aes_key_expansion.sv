`timescale 1ns/1ps

module aes_key_expansion (
    input  logic [127:0] key_in,
    output wire  [1407:0] round_keys
);

    wire [31:0] w [0:43];
    wire [31:0] transformed [1:10];

    function automatic [31:0] rotword(input [31:0] x);
        rotword = {x[23:0], x[31:24]};
    endfunction

    function automatic [31:0] rcon(input integer n);
        case (n)
            1: rcon = 32'h01000000;
            2: rcon = 32'h02000000;
            3: rcon = 32'h04000000;
            4: rcon = 32'h08000000;
            5: rcon = 32'h10000000;
            6: rcon = 32'h20000000;
            7: rcon = 32'h40000000;
            8: rcon = 32'h80000000;
            9: rcon = 32'h1b000000;
            10:rcon = 32'h36000000;
            default: rcon = 32'h00000000;
        endcase
    endfunction

    assign w[0] = key_in[127:96];
    assign w[1] = key_in[95:64];
    assign w[2] = key_in[63:32];
    assign w[3] = key_in[31:0];

    genvar i, b, r;

    generate
        for (i = 4; i < 44; i = i + 1) begin : GEN_WORD
            if ((i % 4) == 0) begin : GEN_CORE
                wire [31:0] rotated;

                assign rotated = rotword(w[i-1]);

                for (b = 0; b < 4; b = b + 1) begin : GEN_SBOX
                    aes_sbox u_sbox (
                        .data_in(rotated[31-8*b -: 8]),
                        .data_out(transformed[i/4][31-8*b -: 8])
                    );
                end

                assign w[i] = w[i-4] ^
                              transformed[i/4] ^
                              rcon(i/4);
            end
            else begin : GEN_XOR
                assign w[i] = w[i-4] ^ w[i-1];
            end
        end

        for (r = 0; r < 11; r = r + 1) begin : GEN_KEYS
            assign round_keys[1407-128*r -: 128] = {
                w[4*r], w[4*r+1],
                w[4*r+2], w[4*r+3]
            };
        end
    endgenerate

endmodule