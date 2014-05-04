# kegsy firmware

The kegsy firmware handles low-level sensor interfacing.

# building

[Arduino-Makefile](https://github.com/sudar/Arduino-Makefile) and a skeleton
`Makefile` are used to set hardware parameters and build / upload to the Arduino
from the command line.

More details:
- [Compiling Arduino Sketches Using Makefile](http://hardwarefun.com/tutorials/compiling-arduino-sketches-using-makefile)

## dependancies

- CmdMessenger: https://github.com/thijse/Arduino-Libraries/tree/master/CmdMessenger
- OneWire: (stock arduino lib)

## uploading (flashing)

# hardware details

Use `pro328` for the current hardware, an [Arduino Pro
Mini](http://arduino.cc/en/Main/ArduinoBoardProMini) from
[Sparkfun](https://www.sparkfun.com/products/11114).
