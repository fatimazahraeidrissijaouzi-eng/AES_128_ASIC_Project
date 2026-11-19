# AES-128 Hardware Accelerator — RTL Design and ASIC Physical Implementation

AES-128 encryption accelerator in **SystemVerilog**, with functional testbenches, **Yosys** synthesis and a physical-design run performed using **OpenROAD Flow Scripts** on the **Nangate45** platform.

> **Status:** RTL, synthesis and a complete physical-design flow have been run. Final physical sign-off, reproducibility artifacts and full verification evidence still need to be documented. This is an educational open-source ASIC flow, not a fabricated or sign-off-qualified chip.

## Tools

- RTL: SystemVerilog
- Functional simulation: ModelSim / Questa
- Logic synthesis: Yosys
- Physical implementation: OpenROAD (floorplanning, placement, clock tree synthesis and routing)
- Timing analysis: OpenROAD STA / OpenSTA-compatible SDC constraints
- Technology platform used in the reported run: Nangate45

## Repository contents

- `rtl/` — nine AES-128 RTL modules, including the accelerator, core, key expansion and round transformations
- `tb/` — eleven SystemVerilog testbenches and an S-box reference file
- `synthesis/aes_128_synth.v` — Yosys-generated synthesis netlist
- `reports/synthesis.log` — synthesis log
- `physical_design/STATUS.md` — physical-design evidence and remaining checks

## Verification

The repository contains an accelerator testbench with reset, busy, done, ciphertext and return-to-idle checks. The advanced testbench additionally checks repeated encryption, reset during operation and behavior while busy.

Two known-answer cases are encoded in `tb/tb_aes_128_advanced.sv`:

| Plaintext | Key | Expected ciphertext |
| --- | --- | --- |
| `00112233445566778899aabbccddeeff` | `000102030405060708090a0b0c0d0e0f` | `69c4e0d86a7b0430d8cdb78070b4c55a` |
| `00000000000000000000000000000000` | `00000000000000000000000000000000` | `66e94bd4ef8a2c3b884cfa59ca342b2e` |

**Note:** Testbench source files are present; a committed simulator transcript showing all tests passing is still needed. Test presence is not proof of successful execution.

## Implementation status

| Stage | Evidence / status |
| --- | --- |
| AES-128 RTL | Nine source modules committed |
| Yosys synthesis | Generated netlist and synthesis log committed; design check previously reported 0 problems |
| Floorplanning and placement | Executed locally in OpenROAD; logs/configuration not yet committed |
| Clock tree synthesis (CTS) | Executed locally; evidence not yet committed |
| Global and detailed routing | Executed locally; detailed-routing log and output database observed |
| STA / SDC | Finish report inspected locally; original constraints and complete timing reports not yet committed |
| DRC / physical sign-off | **Not yet cleared/established**; short-circuit markers and other checks need reconciliation |
| Functional simulation | Testbenches committed; passing run logs pending |

## Physical-design observations

See [physical_design/STATUS.md](physical_design/STATUS.md) for values transcribed from the local OpenROAD terminal captures, including timing, routing and remaining violations. These values should not be interpreted as final sign-off.

## Next steps

1. Commit the **actual** OpenROAD configuration, SDC constraints, relevant scripts and concise logs/reports from the local machine.
2. Commit ModelSim/Questa test results for the AES-128 known-answer vectors.
3. Investigate remaining physical violations and confirm final DRC and routing connectivity.
4. Review final timing constraints and setup/hold reports; document reproducible commands.
5. Export final layout artifacts only if useful and suitably sized for the repository.

## License

MIT — see [LICENSE](LICENSE).
