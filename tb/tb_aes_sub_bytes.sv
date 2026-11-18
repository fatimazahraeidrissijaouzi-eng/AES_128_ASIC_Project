`timescale 1ns/1ps

module tb_aes_sub_bytes;

    logic [127:0] data_in;
    logic [127:0] data_out;

    logic [7:0] reference_table [0:255];
    logic [127:0] expected;

    integer tests;
    integer errors;
    integer i;
    integer j;

    aes_sub_bytes dut (
        .data_in(data_in),
        .data_out(data_out)
    );

    task automatic check_block(input logic [127:0] block_in);
        begin
            data_in = block_in;

            for (integer k = 0; k < 16; k = k + 1) begin
                expected[k*8 +: 8] =
                    reference_table[block_in[k*8 +: 8]];
            end

            #10;
            tests = tests + 1;

            if (data_out !== expected) begin
                errors = errors + 1;

                $display("FAIL TEST %0d", tests);
                $display("INPUT    = %032h", data_in);
                $display("OUTPUT   = %032h", data_out);
                $display("EXPECTED = %032h", expected);
            end
            else begin
                $display("PASS TEST %0d", tests);
            end
        end
    endtask

    initial begin
        tests = 0;
        errors = 0;
        data_in = 128'h0;
        expected = 128'h0;

        $readmemh(
            "tb/aes_sbox_reference.hex",
            reference_table
        );

        $display("===============================");
        $display("AES SUBBYTES VERIFICATION");
        $display("===============================");

        // Test 1 : bloc de zeros
        check_block(128'h00000000000000000000000000000000);

        // Test 2 : bloc de FF
        check_block(128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF);

        // Test 3 : valeurs progressives
        check_block(128'h000102030405060708090A0B0C0D0E0F);

        // Test 4 : vecteur de reference AES
        check_block(128'h00102030405060708090A0B0C0D0E0F0);

        // Tests exhaustifs : chaque octet prend les 256 valeurs
        for (i = 0; i < 256; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                data_in[j*8 +: 8] = i[7:0];
            end
            check_block(data_in);
        end

        $display("===============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES SUBBYTES TEST PASSED");
        else
            $display("AES SUBBYTES TEST FAILED");

        $display("===============================");

        $finish;
    end

endmodule