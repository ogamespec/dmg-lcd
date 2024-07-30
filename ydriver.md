# Y Driver Chip (907), Smaller

|![LH5076F_Topo](/imgstore/LH5076F_Topo.jpg)|![LH5076F_Topo_Poly](/imgstore/LH5076F_Topo_Poly.jpg)|
|---|---|

Tech process:
- CMOS (It is not very clear how the pockets are formed, most likely the bordered GND frame also defines the pocket boundaries)
- 1 layer of metal (aluminum)
- metal gates

![topo](/imgstore/topo.jpg)

## Pinout

|Port|Direction|Description|
|---|---|---|
|VDD|input|Digital Power |
|GND|input|Digital Ground |
|V0|input|Bias voltage V0. Used as analog Power for output drivers when FR=1; Hardwired to VDD in DMG. |
|V1|input|Bias voltage V1. Used as analog Power for output drivers when FR=0 |
|V4|input|Bias voltage V4. Used as analog Ground for output drivers when FR=1 |
|V5|input|Bias voltage V5. Used as analog Ground for output drivers when FR=0 |
|FR|input|Frame Reset (?) |
|S|input|Select (?) **S**hift Register Input (?) |
|CPL|input|Clock (?) Complement (?) where the names of the signals came from? |
|Y1-Y144|output|LCD drive output|

## Control

|![lcd_y_driver_control](/hdl/lcd_y_driver_control.png)|![ydriver_control](/hdl/ydriver_control.png)|
|---|---|

## Driver Amps

Middle part with giant MOSFETs.

The `FR` signal is used to switch the power supply to the output drivers (high-power inverters). The `FR` signal complement (a pair of `fr_int` + `n_fr_int` signals) is obtained in the control circuit.

![ydriver_amp_tran](/imgstore/ydriver_amp_tran.png)

![ydriver_amp_simpl](/imgstore/ydriver_amp_simpl.png)

## Driver Lane

TBD.
