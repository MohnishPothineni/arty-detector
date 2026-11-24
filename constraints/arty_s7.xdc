## Clock: 12 MHz oscillator
set_property -dict { PACKAGE_PIN F14 IOSTANDARD LVCMOS33 } [get_ports { CLK12MHZ }];
create_clock -add -name sys_clk_pin -period 83.333 -waveform {0 41.667} [get_ports { CLK12MHZ }];

## Green LEDs
set_property -dict { PACKAGE_PIN E18 IOSTANDARD LVCMOS33 } [get_ports { led[0] }];
set_property -dict { PACKAGE_PIN F13 IOSTANDARD LVCMOS33 } [get_ports { led[1] }];
set_property -dict { PACKAGE_PIN E13 IOSTANDARD LVCMOS33 } [get_ports { led[2] }];
set_property -dict { PACKAGE_PIN H15 IOSTANDARD LVCMOS33 } [get_ports { led[3] }];

## RGB LEDs
set_property -dict { PACKAGE_PIN J15 IOSTANDARD LVCMOS33 } [get_ports { led0_r }];
set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { led0_g }];
set_property -dict { PACKAGE_PIN F15 IOSTANDARD LVCMOS33 } [get_ports { led0_b }];
set_property -dict { PACKAGE_PIN E15 IOSTANDARD LVCMOS33 } [get_ports { led1_r }];
set_property -dict { PACKAGE_PIN F18 IOSTANDARD LVCMOS33 } [get_ports { led1_g }];
set_property -dict { PACKAGE_PIN E14 IOSTANDARD LVCMOS33 } [get_ports { led1_b }];

## Buttons
set_property -dict { PACKAGE_PIN G15 IOSTANDARD LVCMOS33 } [get_ports { btn[0] }];
set_property -dict { PACKAGE_PIN K16 IOSTANDARD LVCMOS33 } [get_ports { btn[1] }];
set_property -dict { PACKAGE_PIN J16 IOSTANDARD LVCMOS33 } [get_ports { btn[2] }];
set_property -dict { PACKAGE_PIN H13 IOSTANDARD LVCMOS33 } [get_ports { btn[3] }];

## USB-UART
set_property -dict { PACKAGE_PIN R12 IOSTANDARD LVCMOS33 } [get_ports { uart_rxd_out }];
set_property -dict { PACKAGE_PIN V12 IOSTANDARD LVCMOS33 } [get_ports { uart_txd_in }];

## Configuration (needed to boot from flash)
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
