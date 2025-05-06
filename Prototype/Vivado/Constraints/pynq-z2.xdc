## Clock
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports {clk}];

## Reset - Switch 0 (placa rosa SW0)
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {reset}]

## Botones (placa rosa BTN0-BTN3)
#set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {botones[2]}]
#set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {botones[1]}]
#set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {botones[0]}]

#Selectores Displays
# Disp4
set_property -dict { PACKAGE_PIN F20   IOSTANDARD LVCMOS33 } [get_ports { selector[0] }]; 
# Disp3
set_property -dict { PACKAGE_PIN U19   IOSTANDARD LVCMOS33 } [get_ports { selector[1] }]; 
# Disp2
set_property -dict { PACKAGE_PIN B19   IOSTANDARD LVCMOS33 } [get_ports { selector[2] }]; 
# Disp1
set_property -dict { PACKAGE_PIN B20   IOSTANDARD LVCMOS33 } [get_ports { selector[3] }]; 

#Segments
#--24 segment 0 (g)
set_property -dict { PACKAGE_PIN Y7    IOSTANDARD LVCMOS33 } [get_ports { segments[0] }]; 
#--20 segment 1 (f)
set_property -dict { PACKAGE_PIN A20   IOSTANDARD LVCMOS33 } [get_ports { segments[1] }]; 
#--14 segment 2 (e)
set_property -dict { PACKAGE_PIN V6    IOSTANDARD LVCMOS33 } [get_ports { segments[2] }];
#--15 segment 3 (d)
set_property -dict { PACKAGE_PIN Y6    IOSTANDARD LVCMOS33 } [get_ports { segments[3] }];
#--23 segment 4 (c)
set_property -dict { PACKAGE_PIN W6    IOSTANDARD LVCMOS33 } [get_ports { segments[4] }];
#--8  segment 5 (b)
set_property -dict { PACKAGE_PIN F19   IOSTANDARD LVCMOS33 } [get_ports { segments[5] }];
#--21 segment 6 (a)
set_property -dict { PACKAGE_PIN Y9    IOSTANDARD LVCMOS33 } [get_ports { segments[6] }];
#punto
set_property -dict { PACKAGE_PIN C20    IOSTANDARD LVCMOS33 } [get_ports { segments[7] }];

#LEDs
#set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33}  [get_ports {leds[0]}];
#set_property -dict { PACKAGE_PIN W19 IOSTANDARD LVCMOS33}  [get_ports {leds[1]}];
#set_property -dict { PACKAGE_PIN Y18 IOSTANDARD LVCMOS33}  [get_ports {leds[2]}]; 
#set_property -dict { PACKAGE_PIN U7  IOSTANDARD LVCMOS33 } [get_ports {leds[3]}]; 
#set_property -dict { PACKAGE_PIN V7  IOSTANDARD LVCMOS33 } [get_ports {leds[4]}];
#set_property -dict { PACKAGE_PIN U8  IOSTANDARD LVCMOS33 } [get_ports {leds[5]}];
#set_property -dict { PACKAGE_PIN V8  IOSTANDARD LVCMOS33 } [get_ports {leds[6]}]; 
#set_property -dict { PACKAGE_PIN V10 IOSTANDARD LVCMOS33 } [get_ports {leds[7]}];

# Entrada analogica
set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports vauxp1];
set_property -dict {PACKAGE_PIN D18 IOSTANDARD LVCMOS33} [get_ports vauxn1]; 
