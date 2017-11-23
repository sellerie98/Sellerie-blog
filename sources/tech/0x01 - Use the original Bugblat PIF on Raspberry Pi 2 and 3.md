% Use the original Bugblat Pif Lattice FPGA on Raspberry Pi 2 and 3

---

**TLDR:**

 * Enable I2C and disable SPI in `rasp-config`
 * Update [`C library for Broadcom BCM 2835`](http://www.airspayce.com/mikem/bcm2835/)
 * Rebuild `libpif` with the updated header for Pi 2 and 3 using `clang/clang++`

---

## Resources

Bugblat does not longer list the resources for the original PIF on their site. They can be found here:

 * [Manual](https://www.bugblat.com/products/pif/pif.pdf)
 * [Schematic](https://www.bugblat.com/products/pif/pif_sch.pdf)
 * [Software/Firmware Bundle](https://www.bugblat.com/products/pif/pif.zip)
 * [Github Repo](https://github.com/bugblat/pif)

## Enable I2C and Disable SPI
Run `sudo rasp-config` and choose `5 Interfacing Options` in the menu.
[![](tech/0x01/raspi-config_menu_scaled.jpg "aspi-config menu")](tech/0x01/raspi-config_menu.PNG)

 * Disable SPI
 * Enable I2C

[![](tech/0x01/raspi-config_spi_scaled.jpg "aspi-config menu")](tech/0x01/raspi-config_spi.PNG)
[![](tech/0x01/raspi-config_i2c_scaled.jpg "aspi-config menu")](tech/0x01/raspi-config_i2c.PNG)

## Install i2ctools and check modules
Execute `sudo apt install i2c-tools python-smbus` to install i2c-tools

Check if both `i2c_dev` and `i2c_2708` are present by running `lsmod | grep i2c*` . In case one is mising try to load them with

 * `sudo modprobe i2c_2708`
 * `sudo modprobe i2c_dev`

To auto-load them after reboot add the module name (if necessary) to `/etc/modules`.

## Download Broadcom C wrapper library

**For this library to work correctly on RPI2/3, you MUST have the device tree support enabled in the kernel. Modern Raspbian version have this enabled by default.**

The C library is hosted at [airspace.com](http://www.airspayce.com/mikem/bcm2835). The current version as of writing is 1.52.

We build and install the library:

```
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.52.tar.gz
tar xzvf bcm2835-1.52.tar.gz
cd bcm2835-1.52
./configure
make
sudo make install
cd ..
```


## Build libpif
You can *either* download the [Software/Firmware Bundle](www.bugblat.com/products/pif/pif.zip):

 * `wget www.bugblat.com/products/pif/pif.zip`
 * `unzip pif.zip`

Or clone the [Github Repo](https://github.com/bugblat/pif)

 * `git clone https://github.com/bugblat/pif`

Copy the downloaded bcm2835.{c,h} from the `Broadcom C wrapper library` to the libpif `src` folder:
 `cp bcm2835-1.52/src/bcm2835.* pif/software/src`

Now we try to build (which is most likely to fail):
`cd pif/software/src
make`

If building fails with errors like this:
```
g++ -c -o pif.o -ansi -Wall -g -fPIC -I. -DBUILDING_LIBPIF -fvisibility=hidden -fvisibility-inlines-hidden pif.cpp
pif.cpp: In member function ‘bool Tpif::_progPage(int, const uint8_t*)’:
pif.cpp:320:32: error: taking address of temporary array
   nanosleep((struct timespec[]){{0, (200 * MICROSEC)}}, NULL);
                                ^~~~~~~~~~~~~~~~~~~~~~~
pif.cpp: In member function ‘bool Tpif::setUsercode(uint8_t*)’:
pif.cpp:398:32: error: taking address of temporary array
   nanosleep((struct timespec[]){{0, (200 * MICROSEC)}}, NULL);
                                ^~~~~~~~~~~~~~~~~~~~~~~
makefile:17: recipe for target 'pif.o' failed
make: *** [pif.o] Error 1
```

we will have to modify the `makefile` as modern gcc versions (>=gcc-4) do not support using the address of a temporary array.

To solve this without modifiering the source we can simply use clang:

 * `sudo apt install clang`
 * `sed -i 's/gcc/clang/g' makefile`
 * `sed -i 's/g++/clang++/g' makefile`

Now 

 * `make`
 * `sudo make install`

 should succeed.

## Test configuration

`i2cdetect -y 1` should output something like this:

```
$ i2cdetect -y 1
     0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- --
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
20: 20 -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
70: -- -- -- -- -- -- -- --
```

Lets try to access the pif via libpif:
From within the `pif/software` folder execute:
`sudo python piffind.py`.
Which should prompt: 

```
================= pif find ========================
Using pif library version: 'libpif,Nov 18 2017,22:23:31'

XO2 Device ID: 012bd043  - device is an XO2-7000HC

==================== bye ==========================
```

Congratulations! You can access your pif.
