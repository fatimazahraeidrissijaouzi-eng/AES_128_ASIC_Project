current_design aes_128_accelerator

create_clock -name core_clock -period 10.000 [get_ports clk]

set_input_delay 2.0 -clock core_clock [get_ports {rst start plaintext* cipher_key*}]

set_output_delay 2.0 -clock core_clock [all_outputs]
