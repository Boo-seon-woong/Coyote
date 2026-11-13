# Alveo U50 port (fork-local)

Upstream deprecated the U50 in `4b9dd2a4` (2025-02). This fork re-adds it on top of `0fbc94ba`.

## Changes
- `cmake/FindCoyoteHW.cmake`: `FDEV_NAME=u50` (xcu50-fsvh2104-2-e, HBM 8 GB = `HBM_SIZE 33`, `MC_SIZE 28`, 32 stripe channels); added to `HBM_DEV`.
- `hw/bd/ultrascale_plus/cr_pci.tcl`: U50 XDMA = same config as U280/U55C, with `pcie_blk_locn PCIE4C_X1Y0`, `select_quad GTY_Quad_227` (from the legacy U50 flow).
- `hw/constraints/u50/`: static/shell/dynamic constraints. Pins taken from `hw/constraints/LEGACY/u50/` (PCIe, HBM refclk, `fpga_burn`, QSFP0). No perst pin (master has no perst port).
- `hw/templates/common/*`: leftover `u50d` branches renamed to `u50`.

## Status
- **No floorplan yet** (`hw/constraints/u50/fplan` missing). Only `BUILD_STATIC=1 -DEN_SHELL_PBLOCK=0` works; shell PR / `BUILD_SHELL` flow is not available on U50 until a floorplan is written.
- No prebuilt `static_routed_locked_u50.dcp` (upstream never shipped one).

## Verified without hardware (2026-11-13, Vivado 2022.1, `examples/07_perf_fpga`)
`cmake ../ -DFDEV_NAME=u50 -DBUILD_STATIC=1 -DBUILD_SHELL=0 -DEN_SHELL_PBLOCK=0 && make project && make bitgen`
- Build: rc 0 (about 70 min, 8 threads). Bitstream `cyt_top.bit` generated.
- Timing met: WNS 0.075 ns, WHS 0.009 ns, 0 failing endpoints. Routing: 0 nets with routing errors.
- Utilization: LUT 12.40 %, FF 9.27 %, BRAM 10.86 %, URAM 0, DSP 0.
- Bitstream DRC: 60 warnings, 0 errors (PDCN-1569, REQP-1857/1858, RTSTAT-10).
- 25 critical warnings, all generic flow messages (empty `set_clock_groups`, OOC black boxes, IP XDC scoping, debug bridge clk); none U50-specific.
- XDMA IP vs the legacy U50 build (`46298860`, link observed up at 8GT/s x16 on a real U50): same `PCIE4C_X1Y0`, `GTY_Quad_227`, 8GT/s x16, 100 MHz refclk, device ID 903F, class 070001. Differences are master's design: bypass BAR 1 GB -> 256 MB, AXI-Lite BAR added, 3 DMA channels, 16 user IRQs, MSI-X in BAR_3:2.
- Routed design vs legacy routed design: identical PCIe pins (66), PCIe site `PCIE4CE4_X1Y0`, GTY channels X1Y0..X1Y15, `fpga_burn` J18. HBM refclk BC18/BB18 (new; legacy perf_fpga had no HBM).
- Driver (`driver/`, `TARGET_PLATFORM=ultrascale_plus`) builds unmodified for Linux 6.2 and 6.8.0-138.
- Host software builds (hardware and `EN_SIM=ON`). `make sim` OK; simulated READ and WRITE runs (64 B - 4 KiB) complete.

## Not verified (needs a card)
Link training, BIOS enumeration / BAR assignment, driver probe, DMA, throughput.
