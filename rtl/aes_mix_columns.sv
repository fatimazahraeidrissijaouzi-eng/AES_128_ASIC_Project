`timescale 1ns/1ps

module aes_mix_columns (
    input  logic [127:0] data_in,
    output logic [127:0] data_out
);

    // Multiplication par 2 dans GF(2^8)
    function automatic [7:0] xtime(input [7:0] a);
        begin
            xtime = {a[6:0], 1'b0} ^
                    (a[7] ? 8'h1B : 8'h00);
        end
    endfunction

    // Multiplication par 3 dans GF(2^8)
    function automatic [7:0] mul3(input [7:0] a);
        begin
            mul3 = xtime(a) ^ a;
        end
    endfunction

    genvar col;

    generate
        for (col = 0; col < 4; col = col + 1) begin : GEN_COL

            wire [7:0] s0, s1, s2, s3;
            wire [7:0] r0, r1, r2, r3;

            assign s0 = data_in[127 - 32*col -: 8];
            assign s1 = data_in[119 - 32*col -: 8];
            assign s2 = data_in[111 - 32*col -: 8];
            assign s3 = data_in[103 - 32*col -: 8];

            assign r0 = xtime(s0) ^ mul3(s1) ^ s2 ^ s3;
            assign r1 = s0 ^ xtime(s1) ^ mul3(s2) ^ s3;
            assign r2 = s0 ^ s1 ^ xtime(s2) ^ mul3(s3);
            assign r3 = mul3(s0) ^ s1 ^ s2 ^ xtime(s3);

            assign data_out[127 - 32*col -: 8] = r0;
            assign data_out[119 - 32*col -: 8] = r1;
            assign data_out[111 - 32*col -: 8] = r2;
            assign data_out[103 - 32*col -: 8] = r3;

        end
    endgenerate

endmodule