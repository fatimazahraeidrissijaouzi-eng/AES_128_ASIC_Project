
`timescale 1ns/1ps

module aes_sbox (
    input  logic [7:0] data_in,
    output logic [7:0] data_out
);

    logic [127:0] row;

    always_comb begin
        case (data_in[7:4])
            4'h0: row = 128'h76ABD7FE2B670130C56F6BF27B777C63;
            4'h1: row = 128'hC072A49CAFA2D4ADF04759FA7DC982CA;
            4'h2: row = 128'h1531D871F1E5A534CCF73F362693FDB7;
            4'h3: row = 128'h75B227EBE28012079A059618C323C704;
            4'h4: row = 128'h842FE329B3D63B52A05A6E1B1A2C8309;
            4'h5: row = 128'hCF584C4A39BECB6A5BB1FC20ED00D153;
            4'h6: row = 128'hA89F3C507F02F94585334D43FBAAEFD0;
            4'h7: row = 128'hD2F3FF1021DAB6BCF5389D928F40A351;
            4'h8: row = 128'h73195D643D7EA7C41744975FEC130CCD;
            4'h9: row = 128'hDB0B5EDE14B8EE4688902A22DC4F8160;
            4'hA: row = 128'h79E4959162ACD3C25C2406490A3A32E0;
            4'hB: row = 128'h08AE7A65EAF4566CA94ED58D6D37C8E7;
            4'hC: row = 128'h8A8BBD4B1F74DDE8C6B4A61C2E2578BA;
            4'hD: row = 128'h9E1DC186B95735610EF6034866B53E70;
            4'hE: row = 128'hDF2855CEE9871E9B948ED9691198F8E1;
            4'hF: row = 128'h16BB54B00F2D99416842E6BF0D89A18C;
            default: row = 128'h0;
        endcase

        data_out = row[data_in[3:0]*8 +: 8];
    end

endmodule