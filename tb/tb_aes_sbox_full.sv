`timescale 1ns/1ps

module tb_aes_sbox_full;

    logic [7:0] data_in;
    logic [7:0] data_out;

    logic [7:0] reference_table [0:255];
    logic [7:0] expected;

    integer tests;
    integer errors;
    integer i;

    aes_sbox dut (
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        tests = 0;
        errors = 0;
        data_in = 8'h00;

        $readmemh(
            "tb/aes_sbox_reference.hex",
            reference_table
        );

        $display("=============================");
        $display("AES SBOX FULL VERIFICATION");
        $display("=============================");

        for (i = 0; i < 256; i = i + 1) begin

            data_in = i[7:0];
            expected = reference_table[i];

            #10;

            tests = tests + 1;

            if (data_out !== expected) begin
                errors = errors + 1;

                $display(
                    "FAIL input=%h output=%h expected=%h",
                    data_in, data_out, expected
                );
            end

        end

        $display("=============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES SBOX FULL TEST PASSED");
        else
            $display("AES SBOX FULL TEST FAILED");

        $display("=============================");

        $finish;
    end

endmodule