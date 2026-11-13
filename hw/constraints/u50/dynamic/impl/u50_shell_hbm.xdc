# HBM (100 MHz) (U50: BC18/BB18, Bank 64; from LEGACY/u50/u50_base.xdc)
set_property PACKAGE_PIN BC18     [get_ports hbm_clk_clk_n] ;
set_property PACKAGE_PIN BB18     [get_ports hbm_clk_clk_p] ;
set_property IOSTANDARD  LVDS     [get_ports hbm_clk_clk_n] ;
set_property IOSTANDARD  LVDS     [get_ports hbm_clk_clk_p] ;
set_property DQS_BIAS TRUE        [get_ports hbm_clk_clk_p] ;
