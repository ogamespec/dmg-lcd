# Y Driver Chip (907), Smaller

Tech process:
- CMOS (It is not very clear how the pockets are formed, most likely the bordered GND frame also defines the pocket boundaries)
- 1 layer of metal (aluminum)
- metal gates

![topo](/imgstore/topo.jpg)

## Pinout

|Port|Direction|Description|
|---|---|---|
|VDD|input|Power |
|GND|input|Ground |
|V1|input|Bias voltage V1 |
|V4|input|Bias voltage V4 |
|V5|input|Bias voltage V5 |
|FR|input|Frame Reset (?) |
|S|input|Select (?) **S**hift Register Input (?) |
|CPL|input|Clock (?) Complement (?) where the names of the signals came from? |
|Y1-Y144|output|LCD drive output|

## Control

|![lcd_y_driver_control](/hdl/lcd_y_driver_control.png)|![ydriver_control](/hdl/ydriver_control.png)|
|---|---|

## Driver Amps

Middle part with giant MOSFETs.

TBD.

## Driver Lane

TBD.