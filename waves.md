# LCD Waves

From the gbdev Discord chat.

> gekkio — 17.01.2024 20:33
```
re: the LCD discussion. Here are two GB-BENCH traces from turning the PPU off at two different lines. One of them is "bad" because it's done at LY=100 and one of them is "good" because it's done at LY=144 (vblank)
There's a slight difference in how CPL/FR signals behave before settling to their "idle toggling" state, but otherwise the traces look similar
```

![lcd1](/imgstore/lcd1.png)  ![lcd2](/imgstore/lcd2.png)

> dnariq — 17.01.2024 20:50
huh, how come FR keeps toggling if the GB loses track of frames?

> gekkio — 17.01.2024 21:38
```
there's a fallback mechanism for both CPL and FR that keep them toggling even if the PPU is turned off
but that involves the internal system prescalers so DIV writes will affect it -> if the goal is to have perfect 50% duty cycle for FR/CPL at this point, that's easily disrupted by a DIV write
-> we need to understand how exactly the row/column drivers use FR/CPL in order to understand what the requirements for them are
Also, system reset (either by a cartridge, or system shutdown) is also interesting: that can happen on any scanline. Why is it safe?
```

> lidnariq — 17.01.2024 22:48
```
Because the LCD segment is still connected to the supply rails, and the supply rails collapse, so that discharges the segment
doesn't explain anything else though
```

> Sono — 18.01.2024 11:50
```
@gekkio (sorry for the ping, just doing so so you can search back this message), I have analyzed your captures, and I think I see the culprit: CPL gets toggled with no data shifted in, and I think it's what causes all black to be displayed, I think what's happening is that that resetting the shift register without shifting new data in causes all ones to be loaded into the shift register, meaning that once CPL goes falling-edge(?), it will latch in all those ones into the column driver, while at the same time not advancing the row shift register (probably via HSync), and it results in this behavior
however what I don't get is why it would actually burn in, when FR is being toggled
I think Nintendo/SHARP did actually think about this being an issue, but what I don't get is why it still burns in if FR is toggled
perhaps what I said earlier in general, that rows don't like being driven outside of their rated duty cycle, and probably being driven harder than usual to compensate for said duty cycle mismatch (otherwise the entire screen would just dim, this is why PWM to dim LEDs works) 
oh, as a sidenote, whoever at SHARP came up with these pin names is absolutely horrid
```

> Sono — 18.01.2024 11:58
```
here is what I could decode, just from their abbreviation, signal characteristics, and observable behavior:
CP - pixel shift register latch, Clock Pulse
CPG - I think this is the Gamma/Gray pulse? it smells like this is what drives the gray levels
CPL - line latch, latches the shift register contents into the column drivers, Clock Pulse Line/Latch ?
FR - some sort of Vcom inversion perhaps? I'd be surprised if the polarity of this didn't invert every frame for every 2nd scanline, `<something F>` Reverse?
HSync - I think all this would do is just shift the row driver's shift register
VSync - pretty sure it'd do nothing but reset the row driver shift register, and possibly something pre-frame, it's hard to say without this signal being present in the captures, so I'd rather not guess too much about this one
it would be interesting to spam DIV writes with a perfectly timed LCD off to see if the last scanline's contents could be kept on the display instead of all black, just to prove if my observation about CPL is correct or not
yeah, I can't see any difference between lcd1.png and lcd2.png
so if my observations are wrong, then I'm also out of ideas :(
although the weird thing is is that CP pulses start happening while HSync is high, not sure what's the deal with that :<
I thought all signals here are supposed to be falling edge
```

> Sono — 18.01.2024 12:08
```
actually, now that I thinnk about it, this display may be so old that it has the row and column polarity reversed compared to what I know, so in the case of the DMG screen, I wonder if row is positive, and columns pull the voltage
or if the signals are inverted in some way, we could test that by altering the timing of the CPG pin pulses to change the gray level linearity
actually, the more I think about it, I think Nintendo/SHARP made an oopsie, I think they maybe meant to hook DIV to HSync instead of CPL to shift the row driver shift register off the screen as to stop driving the row, but nobody actually bothered to fix it
in fact, it seems like you could probably even do this as a hardware mod, to just hook CPL to HSync, and disconnect the actual HSync line coming from the SoC
```

> gekkio — 18.01.2024 18:28
```
it smells like this is what drives the gray levels
```
```
The 2-bit color is in LD[1:0]. In this test there wasn't anything on the screen so it was always 0b11
FR indeed plays a role in the drive voltage polarity, although it's not clear how exactly it works...for example, is it used combinationally so any change would immediately get reflected to the current drive voltage, or is it sampled somehow
I've got loads of Sharp LCD driver datasheets, an FR is often present with a description like this
```
![fr](/imgstore/fr.png)

> gekkio — 18.01.2024 18:39
```
also worth noting: the signal names in the traces are old, because GB-BENCH is old. HSYNC/VSYNC are known as ST/S in e.g. my schematics
and a caveat about GB-BENCH: it captures traces synchronously (= all pins are sampled before sending a clock edge to the DUT), so non-synchronous glitches can't be seen. I don't think there are any intentional ones in the LCD output signals, but I can't rule out the possibility that there's a combinational glitch that affects the LCD driver somehow
```
