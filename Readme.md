# DMG LCD

## Disassembling

![dis_001](/imgstore/dis_001.jpg)

![dis_002](/imgstore/dis_002.jpg)

![dis_003](/imgstore/dis_003.jpg)

![dis_004](/imgstore/dis_004.jpg)

## Sun Burn 🍑

![sun_burn](/imgstore/sun_burn.jpg)

## Cables

(I hope I'm calling them "cables" correctly? It doesn't look like a cable, but in eng literature this word is used for some reason. In ru we call them "шлейфы": https://ru.wikipedia.org/wiki/%D0%9F%D0%BB%D0%BE%D1%81%D0%BA%D0%B8%D0%B9_%D0%BA%D0%B0%D0%B1%D0%B5%D0%BB%D1%8C)

lcd_x_cable: TODO

![lcd_y_cable](/imgstore/lcd_y_cable.jpg)

## ICs

![die_size](/imgstore/die_size.jpg)

### X Driver Chip (908), Bigger

![LH5077F_10x_Fused_sm](/imgstore/LH5077F_10x_Fused_sm.jpg)

### Y Driver Chip (907), Smaller

![LH5076F_10x_Fused_sm](/imgstore/LH5076F_10x_Fused_sm.jpg)

![LH5076F_Topo](/imgstore/LH5076F_Topo.jpg)

|![lcd_y_driver_control](/hdl/lcd_y_driver_control.png)|![ydriver_control](/hdl/ydriver_control.png)|
|---|---|

## References

- @Gekkio gb-schematics: https://github.com/Gekkio/gb-schematics/tree/main/DMG-LCD-06
- Some related datasheet (SHARP LH1511/1512): https://www.datasheets360.com/pdf/6856220246305420697
