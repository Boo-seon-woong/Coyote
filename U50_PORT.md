# Alveo U50 port (fork-local)

Upstream deprecated the U50 in `4b9dd2a4` (2025-02). This fork re-adds it on top of `0fbc94ba`.

## Changes
- `cmake/FindCoyoteHW.cmake`: `FDEV_NAME=u50` (xcu50-fsvh2104-2-e, HBM 8 GB = `HBM_SIZE 33`, `MC_SIZE 28`, 32 stripe channels); added to `HBM_DEV`.
- `hw/bd/ultrascale_plus/cr_pci.tcl`: U50 XDMA = same config as U280/U55C, `select_quad GTY_Quad_227`. PCIe block `PCIE4C_X1Y1` (CR X7Y3), as on U55C; the legacy U50 flow used `PCIE4C_X1Y0` (CR X7Y0), which sits in the row the shell needs for HBM AXI ports 25-31.
- `hw/constraints/u50/`: static/shell/dynamic constraints. Pins taken from `hw/constraints/LEGACY/u50/` (PCIe, HBM refclk, `fpga_burn`, QSFP0). No perst pin (master has no perst port).
- `hw/constraints/u50/fplan/u50_static_floorplan.xdc`: shell pblock, derived from the U55C floorplan (the U50 die is the bottom two SLRs of the U55C, same site coordinates). Static = CR X6..X7 / Y1..Y5 and I/O bank 68 (CR X4Y4, `fpga_burn`); the shell gets everything else, incl. HBM and QSFP0/CMAC (X0Y7).
- `hw/constraints/u50/static/impl/u50_static_pcie_pblock.xdc`: keeps the PCIe pipe logic in SLR0 (CR X6Y1..X7Y3). Without it, part of the 512-bit interface was placed in SLR1 and missed timing (-0.240 ns) on its paths to the hard block.
- `fpga_burn` (J18, HBM CATTRIP) is driven to 0 by the static, as on U280 (`hw/templates/common/cyt_top_tmplt.txt`, `u50_static_base.xdc`). I/O in an RP is tri-stated during reconfiguration (UG909), and the card treats a floating J18 as CATTRIP and cuts power (UG1371), so J18 must stay out of the shell. Bank 68 is kept out of the shell pblock; snapping also takes one CLB column (`SLICE_X117`, Y240-299).
- `hw/checkpoints/static_routed_locked_u50.dcp`: rebuilt from `1416711a` (below). The one from `f0ff99a7` had J18 in the shell and is superseded; shells built for it do not fit this one.
- `hw/templates/common/*`: leftover `u50d` branches renamed to `u50`.

## Locked static (`1416711a`, 2026-11-20, Vivado 2022.1, built on sven)
Built from `examples/09_perf_rdma`: `cmake ../ -DFDEV_NAME=u50 -DBUILD_STATIC=1 -DBUILD_SHELL=0 -DEN_SHELL_PBLOCK=1 && make project && make bitgen` (CMAC license present, bitgen ran). 76,016,626 B, sha256 `ad07cd68ad4317348422fc5cfab4c5ea85ccd3acdb9533478ac1b0bfaa88dd5e`.
- Full design (static + 09 shell, HBM 450 MHz): all timing met (WNS 0.013, WHS 0.009), 0 routing errors, bitstream DRC 67 warnings / 0 errors. After link the only critical warning is Opt 31-430, as before.
- Locked dcp: `inst_shell` black box (reconfigurable); `fpga_burn` is a static OBUF at `IOB_X0Y219` (J18, bank 68) driven by GND; bank 68 and the X4Y4 I/O and clocking sites are outside the shell pblock; PCIe `PCIE4CE4_X1Y1`, ICAP `CONFIG_SITE_X0Y0`, GTY X1Y0..X1Y15; 0 unplaced static cells; `report_drc` 0 errors (PPURQ-1 CATTRIP 0).
- Not yet run on this dcp: shell-flow builds (07, 09) and `pr_verify`.

## Earlier locked static (`f0ff99a7`, 2026-11-20, Vivado 2022.1; superseded, J18 in the shell)
Built from `examples/09_perf_rdma`: `cmake ../ -DFDEV_NAME=u50 -DBUILD_STATIC=1 -DBUILD_SHELL=0 -DEN_SHELL_PBLOCK=1 && make project && make bitgen` (bitgen fails without a CMAC license; the checkpoint is written before it). sha256 `9954e5eb2f7f8748a093fc9a86694b4d07184ddabaf0a26195823b9ee250cfbc`.
- Full design (static + 09 shell, HBM 450 MHz): all timing met (WNS 0.000, WHS 0.005), 0 routing errors, bitstream DRC 67 warnings / 0 errors.
- Locked dcp: `inst_shell` black box (reconfigurable), both pblocks kept, PCIe `PCIE4CE4_X1Y1`, GTY X1Y0..X1Y15, ICAP `CONFIG_SITE_X0Y0`; all static cells placed, 0 routing errors.
- Shell-flow link test (`BUILD_STATIC=0` link of the 09 shell onto this dcp): all clocks present (`pcie_ref_clk`, `xclk`, `gt0_refclk_p`, `hbm_clk_clk_p`, ...); static-internal setup slack >= 0.013 ns.
- Second shell on this dcp (`examples/07_perf_fpga`, cmake defaults = shell flow): timing met (WNS 0.011, WHS 0.009), 0 routing errors, bitstream DRC 0 errors, bitgen writes `cyt_top.bit` and `shell_top.bin`. `pr_verify` against the 09 full design above: compatible.
- Static uses ~80k LUT / 96 BRAM of the ~134k / 180 in its region.

## Earlier check, no floorplan (2026-11-13, `examples/07_perf_fpga`, `EN_SHELL_PBLOCK=0`, PCIe X1Y0)
- Build rc 0, timing met (WNS 0.075 ns), bitstream DRC 0 errors. XDMA IP matched the legacy U50 build (`46298860`, link seen up at 8GT/s x16 on a real U50) apart from master's own changes (BAR sizes, AXI-Lite BAR, DMA channels, user IRQs, MSI-X).
- Driver (`driver/`, `TARGET_PLATFORM=ultrascale_plus`) builds unmodified for Linux 6.2 and 6.8.0-138. Host software builds; `make sim` READ/WRITE runs (64 B - 4 KiB) complete.

## Not verified (needs a card)
PCIe block X1Y1 on a real U50 (only X1Y0 was seen working), link training, BIOS enumeration / BAR assignment, driver probe, DMA, shell/app PR, throughput.
