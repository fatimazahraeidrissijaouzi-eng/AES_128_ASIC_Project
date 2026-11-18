
`timescale 1ns/1ps

module tb_aes_128_core;

    logic [127:0] plaintext;
    logic [127:0] cipher_key;
    wire  [127:0] ciphertext;

    integer tests;
    integer errors;

    // Device Under Test
    aes_128_core dut (
        .plaintext(plaintext),
        .cipher_key(cipher_key),
        .ciphertext(ciphertext)
    );

    // =========================================
    // TEST TASK
    // =========================================
    task automatic check(
        input [127:0] pt,
        input [127:0] key,
        input [127:0] expected
    );
        begin
            plaintext  = pt;
            cipher_key = key;

            #100;

            tests = tests + 1;

            if (ciphertext !== expected) begin
                errors = errors + 1;

                $display("FAIL TEST %0d", tests);
                $display("OUTPUT   = %032h", ciphertext);
                $display("EXPECTED = %032h", expected);
            end
            else begin
                $display("PASS TEST %0d", tests);
            end
        end
    endtask

    // =========================================
    // MAIN VERIFICATION
    // =========================================
    initial begin

        tests  = 0;
        errors = 0;

        plaintext  = 128'h0;
        cipher_key = 128'h0;

        $display("================================");
        $display("AES-128 CORE VERIFICATION");
        $display("================================");

        // TEST 1 - FIPS-197
        check(
            128'h00112233445566778899aabbccddeeff,
            128'h000102030405060708090a0b0c0d0e0f,
            128'h69c4e0d86a7b0430d8cdb78070b4c55a
        );

        // TEST 2 - ZERO KEY / ZERO PLAINTEXT
        check(
            128'h00000000000000000000000000000000,
            128'h00000000000000000000000000000000,
            128'h66e94bd4ef8a2c3b884cfa59ca342b2e
        );

        // TEST 3 - NIST SP 800-38A
        check(
            128'h6bc1bee22e409f96e93d7e117393172a,
            128'h2b7e151628aed2a6abf7158809cf4f3c,
            128'h3ad77bb40d7a3660a89ecaf32466ef97
        );

        $display("================================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES-128 CORE TEST PASSED");
        else
            $display("AES-128 CORE TEST FAILED");

        $display("================================");

        $finish;

    end

endmodule