`timescale 1ns/1ps

module tb_aes_add_round_key;

    logic [127:0] data_in;
    logic [127:0] round_key;
    logic [127:0] data_out;

    integer tests;
    integer errors;
    integer i;

    aes_add_round_key dut (
        .data_in(data_in),
        .round_key(round_key),
        .data_out(data_out)
    );

    task automatic check(
        input logic [127:0] input_value,
        input logic [127:0] key_value,
        input logic [127:0] expected_value
    );
        begin
            data_in   = input_value;
            round_key = key_value;

            #10;
            tests = tests + 1;

            if (data_out !== expected_value) begin
                errors = errors + 1;

                $display("FAIL TEST %0d", tests);
                $display("INPUT    = %032h", data_in);
                $display("KEY      = %032h", round_key);
                $display("OUTPUT   = %032h", data_out);
                $display("EXPECTED = %032h", expected_value);
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
        round_key = 128'h0;

        $display("==============================");
        $display("AES ADDROUNDKEY VERIFICATION");
        $display("==============================");

        // Test 1 : zeros
        check(
            128'h00000000000000000000000000000000,
            128'h00000000000000000000000000000000,
            128'h00000000000000000000000000000000
        );

        // Test 2 : FF XOR FF
        check(
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'h00000000000000000000000000000000
        );

        // Test 3 : zero XOR key
        check(
            128'h00000000000000000000000000000000,
            128'h000102030405060708090A0B0C0D0E0F,
            128'h000102030405060708090A0B0C0D0E0F
        );

        // Test 4 : AES-128 initial AddRoundKey
        check(
            128'h00112233445566778899AABBCCDDEEFF,
            128'h000102030405060708090A0B0C0D0E0F,
            128'h00102030405060708090A0B0C0D0E0F0
        );

        // Test 5 : alternating bits
        check(
            128'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA,
            128'h55555555555555555555555555555555,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        );

        // Tests supplémentaires
        for (i = 0; i < 256; i = i + 1) begin
            check(
                {16{i[7:0]}},
                128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5,
                {16{(i[7:0] ^ 8'hA5)}}
            );
        end

        $display("==============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES ADDROUNDKEY TEST PASSED");
        else
            $display("AES ADDROUNDKEY TEST FAILED");

        $display("==============================");

        $finish;
    end

endmodule