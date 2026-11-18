# AES-128 Hardware Accelerator — RTL & ASIC Flow

An AES-128 encryption accelerator developed in **SystemVerilog**, with logic synthesis using **Yosys** and an ASIC physical implementation flow being prepared with **OpenROAD**.

> **Status: Work in progress.** The physical implementation and timing sign-off have **not** yet been completed.

## Toolchain

- RTL: SystemVerilog
- Functional simulation: ModelSim / Questa (testbench results to be documented)
- Logic synthesis: Yosys
- Physical design (in progress): OpenROAD Flow Scripts
- Static timing analysis (planned): OpenSTA / OpenROAD STA

## Current progress

| Stage | Status |
| --- | --- |
| AES-128 RTL modules | Developed |
| Yosys synthesis and design check | Completed (reported 0 problems) |
| Functional verification evidence | To be documented |
| Standard-cell technology mapping | To be completed / verified |
| Floorplanning | Pending |
| Placement | Pending |
| Clock tree synthesis (CTS) | Pending |
| Routing | Pending |
| STA and SDC verification | Pending |

## RTL modules

The local project includes the AES-128 accelerator top, AES core, key expansion, S-box, SubBytes, ShiftRows, MixColumns, AddRoundKey and round logic. Source files will be added to this repository after being transferred from the local development environment.

## Repository structure (planned)

```text
rtl/                 SystemVerilog RTL
 tb/                 Testbenches
synthesis/           Synthesis scripts and selected outputs
constraints/         SDC constraints
reports/             Selected synthesis, physical design and STA reports
physical_design/     OpenROAD configuration and scripts
```

## Next steps

1. Upload and review the actual RTL and testbench files.
2. Validate AES-128 encryption against known-answer test vectors.
3. Prepare an open standard-cell platform and technology-mapped netlist.
4. Run floorplanning, placement, CTS, routing and STA; save reproducible reports.

## License

See the `LICENSE` file in this repository.
