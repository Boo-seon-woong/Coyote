# PCIe
create_clock -period 10.000 [get_ports pcie_clk_clk_p];

# HBM
create_clock -period 10.000 [get_ports  hbm_clk_clk_p];

# CMAC clock (U50 has a single QSFP28 cage)
create_clock -period 6.206 [get_ports gt0_refclk_p];

# Debug
connect_debug_port inst_static/inst_debug_hub/inst/xsdbm/clk [get_nets inst_static/dclk]
