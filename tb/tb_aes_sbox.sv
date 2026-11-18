`timescale 1ns/1ps

module tb_aes_sbox;

    logic [7:0] data_in;
    logic [7:0] data_out;

    integer tests;
    integer errors;
    integer i;

    aes_sbox dut (
        .data_in(data_in),
        .data_out(data_out)
    );

    task automatic check(
        input logic [7:0] input_value,
        input logic [7:0] expected
    );
        begin
            data_in = input_value;
            #10;

            tests = tests + 1;

            if (data_out !== expected) begin
                errors = errors + 1;
                $display(
                    "FAIL input=%h output=%h expected=%h",
                    data_in, data_out, expected
                );
            end
            else begin
                $display(
                    "PASS input=%h output=%h",
                    data_in, data_out
                );
            end
        end
    endtask

    initial begin

        tests  = 0;
        errors = 0;
        data_in = 0;

        $display("==============================");
        $display("AES-128 SBOX VERIFICATION");
        $display("==============================");

        check(8'h00, 8'h63);
        check(8'h01, 8'h7C);
        check(8'h02, 8'h77);
        check(8'h03, 8'h7B);
        check(8'h09, 8'h01);
        check(8'h0F, 8'h76);

        check(8'h10, 8'hCA);
        check(8'h20, 8'hB7);
        check(8'h30, 8'h04);
        check(8'h40, 8'h09);

        check(8'h50, 8'h53);
        check(8'h53, 8'hED);
        check(8'h60, 8'hD0);
        check(8'h70, 8'h51);

        check(8'h80, 8'hCD);
        check(8'h90, 8'h60);
        check(8'hA0, 8'hE0);
        check(8'hB0, 8'hE7);

        check(8'hC0, 8'hBA);
        check(8'hD0, 8'h70);
        check(8'hE0, 8'hE1);

        check(8'hF0, 8'h8C);
        check(8'hFE, 8'hBB);
        check(8'hFF, 8'h16);

        $display("==============================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES SBOX TEST PASSED");
        else
            $display("AES SBOX TEST FAILED");

        $display("==============================");

        $finish;
    end

endmodule