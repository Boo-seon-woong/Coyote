# Shell pblock for the Alveo U50 (xcu50-fsvh2104-2-e, 2 SLRs, clock regions X0..X7 / Y0..Y7).
#
# Derived from hw/constraints/u55c/fplan/u55c_static_floorplan.xdc. The U50 die matches the two bottom SLRs of the U55C
# column for column (same SLICE/DSP/RAMB/URAM/LAGUNA/BLI_HBM coordinates per clock region, checked in Vivado 2022.1),
# so this is the U55C pblock restricted to Y0..Y7, without the U55C top-row (Y11) and right-column QSFP (BUFG_GT X1) parts.
#
# Static (outside the pblock): clock regions X6..X7 / Y1..Y5 (X4..X5 / Y3 fabric is shell, added by site ranges as on the U55C).
#   - PCIe hard block PCIE4CE4_X1Y1 (CR X7Y3), PCIe lanes GTY X1Y0..X1Y15 (CR X7Y0..X7Y3), ICAPE3 CONFIG_SITE_X0Y0 (CR X7Y1)
#   - I/O bank 68 (CR X4Y4) with fpga_burn J18 (HBM CATTRIP). I/O in an RP is tri-stated during reconfiguration (UG909) and
#     the card treats a floating J18 as CATTRIP and cuts power (UG1371), so only the X4Y4 fabric is shell (site ranges, as for Y3).
# Shell (inside the pblock):
#   - HBM (bottom row, incl. BLI_HBM ports 25..31 in X6Y0/X7Y0), HBM refclk BB18/BC18 (CR X4Y0)
#   - QSFP0 GTY X0Y28..X0Y31 and CMACE4_X0Y4 (CR X0Y7)
create_pblock pblock_inst_shell
add_cells_to_pblock [get_pblocks pblock_inst_shell] [get_cells -quiet [list inst_shell]]
resize_pblock [get_pblocks pblock_inst_shell] -add {SLICE_X117Y240:SLICE_X145Y299 SLICE_X117Y180:SLICE_X175Y239 SLICE_X176Y0:SLICE_X232Y59}
resize_pblock [get_pblocks pblock_inst_shell] -add {BLI_HBM_APB_INTF_X25Y0:BLI_HBM_APB_INTF_X31Y0}
resize_pblock [get_pblocks pblock_inst_shell] -add {BLI_HBM_AXI_INTF_X25Y0:BLI_HBM_AXI_INTF_X31Y0}
resize_pblock [get_pblocks pblock_inst_shell] -add {DSP48E2_X25Y0:DSP48E2_X31Y17 DSP48E2_X16Y90:DSP48E2_X19Y113 DSP48E2_X16Y66:DSP48E2_X24Y89}
resize_pblock [get_pblocks pblock_inst_shell] -add {LAGUNA_X16Y120:LAGUNA_X19Y239 LAGUNA_X16Y0:LAGUNA_X23Y119}
resize_pblock [get_pblocks pblock_inst_shell] -add {PCIE4CE4_X1Y0:PCIE4CE4_X1Y0}
resize_pblock [get_pblocks pblock_inst_shell] -add {RAMB18_X11Y0:RAMB18_X13Y23 RAMB18_X8Y96:RAMB18_X9Y119 RAMB18_X8Y72:RAMB18_X10Y95}
resize_pblock [get_pblocks pblock_inst_shell] -add {RAMB36_X11Y0:RAMB36_X13Y11 RAMB36_X8Y48:RAMB36_X9Y59 RAMB36_X8Y36:RAMB36_X10Y47}
resize_pblock [get_pblocks pblock_inst_shell] -add {URAM288_X4Y0:URAM288_X4Y15 URAM288_X2Y64:URAM288_X2Y79 URAM288_X2Y48:URAM288_X3Y63}
resize_pblock [get_pblocks pblock_inst_shell] -add {CLOCKREGION_X0Y6:CLOCKREGION_X7Y7 CLOCKREGION_X0Y5:CLOCKREGION_X5Y5 CLOCKREGION_X0Y4:CLOCKREGION_X3Y4 CLOCKREGION_X5Y4:CLOCKREGION_X5Y4 CLOCKREGION_X0Y3:CLOCKREGION_X3Y3 CLOCKREGION_X0Y0:CLOCKREGION_X5Y2}
set_property SNAPPING_MODE ON [get_pblocks pblock_inst_shell]
set_property IS_SOFT FALSE [get_pblocks pblock_inst_shell]
