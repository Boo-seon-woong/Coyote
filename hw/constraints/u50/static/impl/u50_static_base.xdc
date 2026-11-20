# Power constraint (U50 board budget, from LEGACY/u50/u50_base.xdc)
set_operating_conditions -design_power_budget 63

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design];

# fpga_burn (U50: J18, Bank 68; from LEGACY/u50/u50_base.xdc)
set_property PACKAGE_PIN J18      [get_ports fpga_burn];
set_property IOSTANDARD  LVCMOS18 [get_ports fpga_burn];
set_property PULLDOWN TRUE        [get_ports fpga_burn];

# CMAC clock
create_clock -period 6.206 -name gt0_refclk_p [get_ports gt0_refclk_p];

# HBM (100 MHz)
create_clock -period 10.000 -name hbm_clk_clk_p [get_ports  hbm_clk_clk_p];
