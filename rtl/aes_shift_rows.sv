`timescale 1ns/1ps

module aes_shift_rows (
    input  logic [127:0] data_in,
    output logic [127:0] data_out
);

    // AES state en ordre colonne :
    // data_in[127:120] = state[0,0]
    // data_in[119:112] = state[1,0]
    // ...
    // data_in[7:0] = state[3,3]

    genvar row, col;

    generate
        for (col = 0; col < 4; col = col + 1) begin : COL
            for (row = 0; row < 4; row = row + 1) begin : ROW

                assign data_out[127 - 8*(4*col + row) -: 8] =
                    data_in[127 - 8*(4*((col + row)%4) + row) -: 8];

            end
        end
    endgenerate

endmodule