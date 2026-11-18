`timescale 1ns/1ps

module tb_aes_key_expansion;

    logic [127:0] key_in;
    wire [1407:0] round_keys;

    integer tests;
    integer errors;
    integer i;

    logic [127:0] reference [0:10];

    aes_key_expansion dut (
        .key_in(key_in),
        .round_keys(round_keys)
    );

    initial begin
        tests = 0;
        errors = 0;

        // AES-128 reference key
        key_in = 128'h000102030405060708090A0B0C0D0E0F;

        reference[0]  = 128'h000102030405060708090A0B0C0D0E0F;
        reference[1]  = 128'hD6AA74FDD2AF72FADAA678F1D6AB76FE;
        reference[2]  = 128'hB692CF0B643DBDF1BE9BC5006830B3FE;
        reference[3]  = 128'hB6FF744ED2C2C9BF6C590CBF0469BF41;
        reference[4]  = 128'h47F7F7BC95353E03F96C32BCFD058DFD;
        reference[5]  = 128'h3CAAA3E8A99F9DEB50F3AF57ADF622AA;
        reference[6]  = 128'h5E390F7DF7A69296A7553DC10AA31F6B;
        reference[7]  = 128'h14F9701AE35FE28C440ADF4D4EA9C026;
        reference[8]  = 128'h47438735A41C65B9E016BAF4AEBF7AD2;
        reference[9]  = 128'h549932D1F08557681093ED9CBE2C974E;
        reference[10] = 128'h13111D7FE3944A17F307A78B4D2B30C5;

        #20;

        $display("================================");
        $display("AES-128 KEY EXPANSION TEST");
        $display("================================");

        for (i = 0; i < 11; i = i + 1) begin
            tests = tests + 1;

            if (round_keys[1407-128*i -: 128] !== reference[i]) begin
                errors = errors + 1;
                $display("FAIL ROUND %0d", i);
                $display("OUTPUT   = %032h",
                         round_keys[1407-128*i -: 128]);
                $display("EXPECTED = %032h", reference[i]);
            end
            else begin
                $display("PASS ROUND %0d", i);
            end
        end

        $display("================================");
        $display("TOTAL TESTS  = %0d", tests);
        $display("TOTAL ERRORS = %0d", errors);

        if (errors == 0)
            $display("AES KEY EXPANSION TEST PASSED");
        else
            $display("AES KEY EXPANSION TEST FAILED");

        $display("================================");

        $finish;
    end

endmodule