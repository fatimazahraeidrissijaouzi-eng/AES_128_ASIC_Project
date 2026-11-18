`timescale 1ns/1ps

module tb_aes_mix_columns;

    logic [127:0] data_in;
    logic [127:0] data_out;

    integer tests;
    integer errors;

    aes_mix_columns dut (
        .data_in(data_in),
        .data_out(data_out)
    );

    task automatic check(
        input logic [127:0] input_value,
        input logic [127:0] expected_value
    );
        begin
            data_in = input_value;
            #10;

            tests = tests + 1;

            if (data_out !== expected_value) begin
                errors = errors + 1;

                $display("FAIL TEST %0d", tests);
                $display("INPUT    = %032h", data_in);
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

        $display("==============================");
        $display("AES MIXCOLUMNS VERIFICATION");
        $display("==============================");

        // Test 1 : tous les octets à zéro
        check(
            128'h00000000000000000000000000000000,
            128'h00000000000000000000000000000000
        );

        // Test 2 : tous les octets à FF
        check(
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        );

        // Test 3 : vecteur AES standard (FIPS-197)
        check(
            128'hD4BF5D30E0B452AEB84111F11E2798E5,
            128'h046681E5E0CB199A48F8D37A2806264C
        );

        // Test 4 : deuxième vecteur AES standard
        check(
            128'h6353E08C0960E104CD70B751BACAD0E7,
            128'h5F72641557F5BC92F7BE3B291DB9F91A
        );

        $display("==============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES MIXCOLUMNS TEST PASSED");
        else
            $display("AES MIXCOLUMNS TEST FAILED");

        $display("==============================");

        $finish;
    end

endmodule