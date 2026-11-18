
`timescale 1ns/1ps

module tb_aes_round;

    logic [127:0] data_in;
    logic [127:0] round_key;
    wire  [127:0] data_out;

    integer tests;
    integer errors;

    // Device Under Test
    aes_round dut (
        .data_in(data_in),
        .round_key(round_key),
        .data_out(data_out)
    );

    // Task de verification
    task automatic check(
        input [127:0] input_state,
        input [127:0] input_key,
        input [127:0] expected
    );
        begin
            data_in   = input_state;
            round_key = input_key;

            #20;

            tests = tests + 1;

            if (data_out !== expected) begin
                errors = errors + 1;

                $display("FAIL TEST %0d", tests);
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
        round_key = 128'h0;

        $display("==============================");
        $display("AES ROUND VERIFICATION");
        $display("==============================");

        // Test 1 : Premiere ronde AES-128
        // Vecteur de reference FIPS-197

        check(
            128'h00102030405060708090a0b0c0d0e0f0,
            128'hd6aa74fdd2af72fadaa678f1d6ab76fe,
            128'h89d810e8855ace682d1843d8cb128fe4
        );

        $display("==============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES ROUND TEST PASSED");
        else
            $display("AES ROUND TEST FAILED");

        $display("==============================");

        $finish;

    end

endmodule