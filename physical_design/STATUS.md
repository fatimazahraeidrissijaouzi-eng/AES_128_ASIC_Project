# OpenROAD Physical Design — Status and Evidence

This file records **observations from user-provided local terminal screenshots**, not files independently reproduced or re-run from this GitHub repository.

## Flow

- Platform: `nangate45`
- Design: `aes_128_accelerator`
- Variant: `base`
- Local OpenROAD Flow Scripts directory: `~/OpenROAD-flow-scripts`
- Reports directory: `flow/reports/nangate45/aes_128_accelerator/base/`
- Logs directory: `flow/logs/nangate45/aes_128_accelerator/base/`
- Results directory: `flow/results/nangate45/aes_128_accelerator/base/`

## Observed results

| Check | Observed value | Interpretation |
| --- | --- | --- |
| Nets in routing database | 128,659 | Local Tcl query |
| Nets with wire objects | 128,267 | 392-net difference; **not** by itself a reliable count of unrouted nets |
| Detailed router, final iteration | 0 reported violations | Router iteration log, **not** a final full-chip DRC sign-off |
| Antenna check | 0 net violations, 0 pin violations | As reported in `5_2_route.log` |
| Finish setup violation count | 0 | From `6_finish.rpt` |
| Finish hold violation count | 0 | From `6_finish.rpt` |
| Finish max capacitance violation count | **93** | **Outstanding issue** in the inspected finish report |
| Finish max slew violation count | 0 | From `6_finish.rpt` |
| Finish max fanout violation count | 0 | From `6_finish.rpt` |
| Worst slack max | 1.03 | Unit and constraint context need confirmation from full report |
| Post-repair OpenDB | `6_repaired.odb` (205 MB) | File existence observed locally |
| Post-repair SDC | `6_repaired.sdc` (38 KB) | File existence observed locally |

A local report `5_route_drc.rpt-5.rpt` listed **three metal2 short markers** involving nets such as `_047342_`, `_047346_` and `_047343_`. This needs reconciliation with the router's final iteration reporting zero violations; neither observation alone proves a clean final DRC.

The inspected `5_route_drc.rpt` was empty. The final layout database and final full-chip DRC result have not been independently checked in this repository.

## Remaining checks

1. Confirm whether the 93 max-capacitance violations persist in the latest repaired design.
2. Run/collect final DRC results and investigate the reported metal2 shorts.
3. Verify connectivity and whether the 392-net difference includes special nets or legitimate nets without routed wire objects.
4. Review complete STA reports, clock definitions, timing paths and actual SDC constraints.
5. Add original OpenROAD design configuration and scripts, SDC, selected reports and run instructions.
6. Confirm reproducibility of the physical flow from committed sources.

**No claim of zero final DRC violations, complete sign-off, or tapeout readiness is made.**
