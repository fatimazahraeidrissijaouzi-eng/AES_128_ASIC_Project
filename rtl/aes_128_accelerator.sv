
`timescale 1ns/1ps

module aes_128_accelerator (
    input  logic         clk,
    input  logic         rst,
    input  logic         start,
    input  logic [127:0] plaintext,
    input  logic [127:0] cipher_key,
    output logic [127:0] ciphertext,
    output logic         busy,
    output logic         done
);

    logic [127:0] core_plaintext;
    logic [127:0] core_key;
    logic [127:0] core_ciphertext;

    typedef enum logic [1:0] {
        IDLE,
        COMPUTE,
        FINISH
    } state_t;

    state_t state;

    aes_128_core u_core (
        .plaintext  (core_plaintext),
        .cipher_key (core_key),
        .ciphertext (core_ciphertext)
    );

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state           <= IDLE;
            core_plaintext  <= 128'b0;
            core_key        <= 128'b0;
            ciphertext      <= 128'b0;
            busy            <= 1'b0;
            done            <= 1'b0;
        end
        else begin
            done <= 1'b0;

            case (state)

                IDLE: begin
                    busy <= 1'b0;

                    if (start) begin
                        core_plaintext <= plaintext;
                        core_key       <= cipher_key;
                        busy           <= 1'b1;
                        state          <= COMPUTE;
                    end
                end

                COMPUTE: begin
                    busy  <= 1'b1;
                    state <= FINISH;
                end

                FINISH: begin
                    ciphertext <= core_ciphertext;
                    busy       <= 1'b0;
                    done       <= 1'b1;
                    state      <= IDLE;
                end

                default: begin
                    state <= IDLE;
                    busy  <= 1'b0;
                end

            endcase
        end
    end

endmodule