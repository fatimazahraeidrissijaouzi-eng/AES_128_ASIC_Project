
`timescale 1ns/1ps

module tb_aes_128_accelerator;

    logic clk;
    logic rst;
    logic start;

    logic [127:0] plaintext;
    logic [127:0] cipher_key;
    logic [127:0] ciphertext;

    logic busy;
    logic done;

    integer tests;
    integer errors;
    integer timeout_count;

    localparam logic [127:0] EXPECTED =
        128'h69c4e0d86a7b0430d8cdb78070b4c55a;

    // =========================================
    // DUT - AES-128 ACCELERATOR
    // =========================================

    aes_128_accelerator dut (
        .clk        (clk),
        .rst        (rst),
        .start      (start),
        .plaintext  (plaintext),
        .cipher_key (cipher_key),
        .ciphertext (ciphertext),
        .busy       (busy),
        .done       (done)
    );

    // =========================================
    // CLOCK : 10 ns
    // =========================================

    initial clk = 1'b0;

    always #5 clk = ~clk;

    // =========================================
    // TESTS
    // =========================================

    initial begin

        tests = 0;
        errors = 0;
        timeout_count = 0;

        rst = 1'b1;
        start = 1'b0;

        plaintext =
            128'h00112233445566778899aabbccddeeff;

        cipher_key =
            128'h000102030405060708090a0b0c0d0e0f;

        $display("==============================");
        $display("AES-128 ACCELERATOR TEST");
        $display("==============================");

        // TEST 1 : RESET

        repeat (2) @(negedge clk);

        tests = tests + 1;

        if (busy !== 1'b0 ||
            done !== 1'b0 ||
            ciphertext !== 128'b0) begin

            errors = errors + 1;
            $display("FAIL RESET");

        end
        else begin
            $display("PASS RESET");
        end

        rst = 1'b0;

        // TEST 2 : START / BUSY

        @(negedge clk);
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        tests = tests + 1;

        if (busy !== 1'b1) begin
            errors = errors + 1;
            $display("FAIL BUSY");
        end
        else begin
            $display("PASS BUSY");
        end

        // TEST 3 : DONE

        while (done !== 1'b1 &&
               timeout_count < 20) begin

            @(negedge clk);
            timeout_count = timeout_count + 1;

        end

        tests = tests + 1;

        if (done !== 1'b1) begin
            errors = errors + 1;
            $display("FAIL DONE TIMEOUT");
        end
        else begin
            $display("PASS DONE");
        end

        // TEST 4 : CIPHERTEXT

        tests = tests + 1;

        if (ciphertext !== EXPECTED) begin

            errors = errors + 1;

            $display("FAIL CIPHERTEXT");
            $display("OUTPUT   = %032h", ciphertext);
            $display("EXPECTED = %032h", EXPECTED);

        end
        else begin
            $display("PASS CIPHERTEXT");
        end

        // TEST 5 : RETURN TO IDLE

        @(negedge clk);

        tests = tests + 1;

        if (done !== 1'b0 ||
            busy !== 1'b0) begin

            errors = errors + 1;
            $display("FAIL RETURN TO IDLE");

        end
        else begin
            $display("PASS RETURN TO IDLE");
        end

        // =========================================
        // FINAL RESULTS
        // =========================================

        $display("==============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES ACCELERATOR TEST PASSED");
        else
            $display("AES ACCELERATOR TEST FAILED");

        $display("==============================");

        $finish;

    end

endmodule