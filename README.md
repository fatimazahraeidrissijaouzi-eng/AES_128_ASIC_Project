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
- `physical/config.mk` and `constraints/constraint.sdc` — committed OpenROAD configuration and SDC
- `reports/physical/` — original floorplan, placement, CTS, routing, finish STA and synthesis-check reports
- `physical_design/STATUS.md` — physical-design evidence and remaining checks

## Verification

The repository contains an accelerator testbench with reset, busy, done, ciphertext and return-to-idle checks. The advanced testbench additionally checks repeated encryption, reset during operation and behavior while busy.

Two known-answer cases are encoded in `tb/tb_aes_128_advanced.sv`:

| Plaintext | Key | Expected ciphertext |
| --- | --- | --- |
| `00112233445566778899aabbccddeeff` | `000102030405060708090a0b0c0d0e0f` | `69c4e0d86a7b0430d8cdb78070b4c55a` |
| `00000000000000000000000000000000` | `00000000000000000000000000000000` | `66e94bd4ef8a2c3b884cfa59ca342b2e` |

**Observed simulation evidence (ModelSim SE-64 10.6d screenshot, 2026-11-19):** the `tb_aes_128_accelerator` simulation transcript displays `TOTAL TESTS = 5`, `TOTAL ERRORS = 0`, and `AES ACCELERATOR TEST PASSED`. This confirms the five checks in that run, but does not independently establish that the separate advanced testbench was executed. A machine-readable transcript has not yet been committed.

## Implementation status

| Stage | Evidence / status |
| --- | --- |
| AES-128 RTL | Nine source modules committed |
| Yosys synthesis | Synthesized netlist, synthesis log, and check report showing 0 problems |
| Floorplanning, placement, CTS | Executed; original reports committed in `reports/physical/` |
| Global and detailed routing | Executed; final detailed-router log screenshot reports 0 violations and 0 antenna violations |
| GDS | Final GDS file generated locally; not committed due to size |
| STA / SDC | SDC and finish report committed; setup violations 0, hold violations 0, TNS max 0.00 |
| Max capacitance | Original finish report has violations (93 reported); repaired ODB exists but has not been verified with post-route extracted parasitics |
| DRC / physical sign-off | Final router iteration reports 0 violations, but earlier 3 metal2 short markers remain in an intermediate report; independent final sign-off not established |
| Functional simulation | ModelSim screenshot shows 5 tests, 0 errors, `AES ACCELERATOR TEST PASSED` for `tb_aes_128_accelerator`; advanced testbench run not confirmed |

## Physical-design observations

See [physical_design/STATUS.md](physical_design/STATUS.md) and the original [OpenROAD reports](reports/physical/) for the evidence. This is an educational implementation, not a sign-off-qualified or fabricated ASIC.

## Remaining tasks for portfolio completion

1. Optionally commit a ModelSim/Questa transcript or screenshot documenting the already observed 5/5 successful accelerator tests; separately verify the advanced testbench if broader coverage is required.
2. Document the remaining max-capacitance limitation; do not claim timing/electrical sign-off.
3. Optionally perform independent final DRC and post-repair parasitic STA if full physical sign-off is required.

## License

MIT — see [LICENSE](LICENSE).
