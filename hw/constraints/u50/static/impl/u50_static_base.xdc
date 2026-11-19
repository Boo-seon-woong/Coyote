# Power constraint (U50 board budget, from LEGACY/u50/u50_base.xdc)
set_operating_conditions -design_power_budget 63

set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design];

# CMAC clock
create_clock -period 6.206 -name gt0_refclk_p [get_ports gt0_refclk_p];

# HBM (100 MHz)
create_clock -period 10.000 -name hbm_clk_clk_p [get_ports  hbm_clk_clk_p];
