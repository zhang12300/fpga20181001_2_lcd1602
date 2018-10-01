
## Clock signal
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
create_clock -add -name sys_clk -period 8.00 -waveform {0 4}  [get_ports { clk }];

set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { lcd_rs }]; #IO0
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { lcd_e}]; #IO1
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { lcd_rw }]; #IO2
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports { data[7] }]; #IO29
set_property -dict { PACKAGE_PIN V6   IOSTANDARD LVCMOS33 } [get_ports { data[6] }]; #IO28
set_property -dict { PACKAGE_PIN V5  IOSTANDARD LVCMOS33 } [get_ports { data[5] }]; #IO27
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports { data[4]}]; #IO31
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { data[3]}]; #IO6
set_property -dict { PACKAGE_PIN T15   IOSTANDARD LVCMOS33 } [get_ports { data[2]}];  #IO5
set_property -dict { PACKAGE_PIN V15   IOSTANDARD LVCMOS33 } [get_ports { data[1] }]; #IO4
set_property -dict { PACKAGE_PIN V13   IOSTANDARD LVCMOS33 } [get_ports { data[0] }]; #IO3
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports { pot }]; #IO30
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { rst }]; #BTN0
set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #BTN0
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #BTN0
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { led[2] }]; #BTN0
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { led[3] }]; #BTN0

