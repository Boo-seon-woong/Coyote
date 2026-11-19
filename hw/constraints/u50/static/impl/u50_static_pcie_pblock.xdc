# PCIe pipe logic (512-bit interface, 500 MHz) stays in SLR0 next to PCIE4CE4_X1Y1. The static region spans both SLRs;
# unconstrained, part of it landed in SLR1 and missed timing on the paths to the hard block. GTs (down to CR X7Y0) are not included.
create_pblock pblock_static_pcie
add_cells_to_pblock [get_pblocks pblock_static_pcie] [get_cells -quiet [list inst_static/inst_int_static/xdma_0/inst/pcie4c_ip_i/inst/design_static_xdma_0_0_pcie4c_ip_pcie_4_0_pipe_inst]]
resize_pblock [get_pblocks pblock_static_pcie] -add {CLOCKREGION_X6Y1:CLOCKREGION_X7Y3}
set_property IS_SOFT FALSE [get_pblocks pblock_static_pcie]
