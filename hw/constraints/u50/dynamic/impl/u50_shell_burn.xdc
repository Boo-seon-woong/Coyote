# fpga_burn (U50: J18, Bank 68, clock region X4Y4; from LEGACY/u50/u50_base.xdc)
# Owned by the shell, as on the U55C, because J18 lies inside the shell pblock
set_property PACKAGE_PIN J18      [get_ports fpga_burn];
set_property IOSTANDARD  LVCMOS18 [get_ports fpga_burn];
set_property PULLDOWN TRUE        [get_ports fpga_burn];
