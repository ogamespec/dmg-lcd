# Y Driver Chip (907) aka Common Driver, Smaller

|![LH5076F_Topo](/imgstore/LH5076F_Topo.jpg)|![LH5076F_Topo_Poly](/imgstore/LH5076F_Topo_Poly.jpg)|
|---|---|

Tech process:
- CMOS (bordered GND frame defines the P-pocket boundaries)
- 1 layer of metal (aluminum)
- metal gates
- Package type: TAB

|![topo](/imgstore/topo.jpg)|![pocket](/imgstore/pocket.jpg)|
|---|---|

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

## Common Driver Control

|![ydriver_control_topo](/hdl/ydriver_control_topo.png)|![ydriver_control](/hdl/ydriver_control.png)|
|---|---|

![ydriver_control_schem](/hdl/ydriver_control_schem.png)

|Signal|Where To|Description|
|---|---|---|
|fr_int |Driver Amps | Signal `FR` for Driver Amps |
|n_fr_int |Driver Amps | Complement of `FR` signal for Driver Amps (feature of Amp operation requires a complement input) |
|fr_int_buffed | Driver Lanes| Signal `FR` for Lanes|
|ck1 | Driver Lanes| |
|ck2 | Driver Lanes| |
|ck3 | Driver Lanes| |
|ck4 | Driver Lanes| |
|s_int | Lane 0 | Internal signal `S` |

## Driver Amps

Middle part with giant MOSFETs.

The `FR` signal is used to switch the power supply to the output drivers (high-power inverters). The `FR` signal complement (a pair of `fr_int` + `n_fr_int` signals) is obtained in the control circuit.

![ydriver_amp_tran](/imgstore/ydriver_amp_tran.png)

![ydriver_amp_simpl](/imgstore/ydriver_amp_simpl.png)

## Driver Lane

|![ydriver_lane_topo](/hdl/ydriver_lane_topo.jpg)|![ydriver_lane](/hdl/ydriver_lane.png)|
|---|---|

![ydriver_lane_schem](/hdl/ydriver_lane_schem.png)

Features:
- A shift register of an unfamiliar design: the input bit is fed to a multiplexer and the output is mixed via nand3 with the output of the _next_ bit
- CLK alternates between even and odd bits
- For even bits: ck of the multiplexer is connected to `ck2`, nand3 is connected to `ck4`
- For odd bits: ck of the multiplexer is connected to `ck1`, nand3 is connected to `ck3`
- Signals ck1-ck4 are arbitrarily named and are obtained in the control circuitry (see above)

### Invering Level Shifter (LS)

It pulls the digital ground to the analog ground so that the subsequent super-inverter can operate at the desired voltage levels. The LS output is inverting. The input is in complementary logic (dual rails).

Analysis:

![level_shifter_inv](/imgstore/level_shifter_inv.png)
