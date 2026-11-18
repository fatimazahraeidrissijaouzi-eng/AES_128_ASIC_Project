`timescale 1ns/1ps

module tb_aes_shift_rows;

    logic [127:0] data_in;
    logic [127:0] data_out;

    integer tests;
    integer errors;

    aes_shift_rows dut (
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
        $display("AES SHIFTROWS VERIFICATION");
        $display("==============================");

        // Test 1 : zeros
        check(
            128'h00000000000000000000000000000000,
            128'h00000000000000000000000000000000
        );

        // Test 2 : FF
        check(
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF,
            128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        );

        // Test 3 : vecteur progressif
        check(
            128'h000102030405060708090A0B0C0D0E0F,
            128'h00050A0F04090E03080D02070C01060B
        );

        // Test 4 : vecteur AES standard
        check(
            128'h63CAB7040953D051CD60E0E7BA70E18C,
            128'h6353E08C0960E104CD70B751BACAD0E7
        );

        $display("==============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES SHIFTROWS TEST PASSED");
        else
            $display("AES SHIFTROWS TEST FAILED");

        $display("==============================");

        $finish;
    end

endmodule