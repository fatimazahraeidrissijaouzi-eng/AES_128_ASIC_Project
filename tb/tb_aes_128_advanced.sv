
`timescale 1ns/1ps

module tb_aes_128_advanced;

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

    localparam logic [127:0] KEY1 =
        128'h000102030405060708090a0b0c0d0e0f;

    localparam logic [127:0] DATA1 =
        128'h00112233445566778899aabbccddeeff;

    localparam logic [127:0] EXPECTED1 =
        128'h69c4e0d86a7b0430d8cdb78070b4c55a;

    localparam logic [127:0] KEY2 =
        128'h00000000000000000000000000000000;

    localparam logic [127:0] DATA2 =
        128'h00000000000000000000000000000000;

    localparam logic [127:0] EXPECTED2 =
        128'h66e94bd4ef8a2c3b884cfa59ca342b2e;

    aes_128_accelerator dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .plaintext(plaintext),
        .cipher_key(cipher_key),
        .ciphertext(ciphertext),
        .busy(busy),
        .done(done)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;

    task automatic check(
        input logic condition,
        input string test_name
    );
        begin
            tests = tests + 1;

            if (condition === 1'b1)
                $display("PASS %s", test_name);
            else begin
                errors = errors + 1;
                $display("FAIL %s", test_name);
            end
        end
    endtask

    task automatic reset_dut;
        begin
            @(negedge clk);
            rst = 1'b1;
            start = 1'b0;

            repeat (2) @(negedge clk);
            rst = 1'b0;
        end
    endtask

    task automatic encrypt_and_check(
        input logic [127:0] data,
        input logic [127:0] key,
        input logic [127:0] expected,
        input string test_name
    );
        integer timeout_count;
        begin
            @(negedge clk);

            plaintext = data;
            cipher_key = key;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            timeout_count = 0;

            while (done !== 1'b1 &&
                   timeout_count < 20) begin
                @(negedge clk);
                timeout_count = timeout_count + 1;
            end

            check(done === 1'b1,
                  {test_name, " DONE"});

            check(ciphertext === expected,
                  {test_name, " CIPHERTEXT"});

            check(busy === 1'b0,
                  {test_name, " BUSY LOW"});

            @(negedge clk);

            check(done === 1'b0,
                  {test_name, " DONE CLEARED"});
        end
    endtask

    initial begin

        tests = 0;
        errors = 0;

        rst = 1'b1;
        start = 1'b0;
        plaintext = 128'b0;
        cipher_key = 128'b0;

        $display("==============================");
        $display("AES-128 ADVANCED VERIFICATION");
        $display("==============================");

        // TEST 1 : RESET INITIAL

        repeat (2) @(negedge clk);

        check(
            busy === 1'b0 &&
            done === 1'b0 &&
            ciphertext === 128'b0,
            "INITIAL RESET"
        );

        rst = 1'b0;

        // TEST 2 : FIRST ENCRYPTION

        encrypt_and_check(
            DATA1,
            KEY1,
            EXPECTED1,
            "ENCRYPTION 1"
        );

        // TEST 3 : SECOND ENCRYPTION

        encrypt_and_check(
            DATA2,
            KEY2,
            EXPECTED2,
            "ENCRYPTION 2"
        );

        // TEST 4 : REPEAT FIRST ENCRYPTION

        encrypt_and_check(
            DATA1,
            KEY1,
            EXPECTED1,
            "REPEAT ENCRYPTION"
        );

        // TEST 5 : RESET DURING OPERATION

        @(negedge clk);
        plaintext = DATA1;
        cipher_key = KEY1;
        start = 1'b1;

        @(negedge clk);
        start = 1'b0;

        check(busy === 1'b1,
              "BUSY BEFORE RESET");

        // Reset before the operation finishes
        #2;
        rst = 1'b1;
        #1;

        check(
            busy === 1'b0 &&
            done === 1'b0 &&
            ciphertext === 128'b0,
            "RESET DURING OPERATION"
        );

        @(negedge clk);
        rst = 1'b0;

        // TEST 6 : RECOVERY AFTER RESET

        encrypt_and_check(
            DATA1,
            KEY1,
            EXPECTED1,
            "RECOVERY AFTER RESET"
        );

        // TEST 7 : IGNORE START WHILE BUSY

        @(negedge clk);
        plaintext = DATA1;
        cipher_key = KEY1;
        start = 1'b1;

        @(negedge clk);

        // Keep start high while changing inputs.
        // The current transaction must not change.
        plaintext = DATA2;
        cipher_key = KEY2;

        @(negedge clk);
        start = 1'b0;

        @(negedge clk);

        check(
            done === 1'b1 &&
            ciphertext === EXPECTED1,
            "IGNORE START WHILE BUSY"
        );

        @(negedge clk);

        check(
            done === 1'b0 &&
            busy === 1'b0,
            "FINAL IDLE"
        );

        // FINAL RESULTS

        $display("==============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES ADVANCED TEST PASSED");
        else
            $display("AES ADVANCED TEST FAILED");

        $display("==============================");

        $finish;

    end

endmodule