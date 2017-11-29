## Requirements:

### Hardware needed:
- A Lenovo Thinkpad T430 mainboard or at least the BIOS chips of/for it
- A Raspberry Pi type B (Rev is not relevant, as long as it has GPIO pins) with an SDcard and a valid GNU/Linux OS
- a display
- a keyboard
- A [SOIC8 chip clamp](https://www.amazon.com/CPT-063-Test-Clip-SOIC8-Pomona/dp/B00HHH65T4) (This one or a similar one)
- 6-8 Female-Female Jumper wires

### Documentation:
  * About the T430:
    * [Thinkwiki article](https://www.thinkwiki.org/wiki/Category:T430)
    * [Lenovo T430 service/maintenance manual](https://download.lenovo.com/ibmdl/pub/pc/pccbbs/mobiles_pdf/t430_t430i_hmm_en_0b48304_04.pdf)
  * About the chip(s) itself: [MX25L3205D/MX25L6405D or compatible](http://www.macronix.com/Lists/Datasheet/Attachments/4978/MX25L6405D,%203V,%2064Mb,%20v1.5.pdf) (The very most SPI SOIC8 chips are identical of pinout)
  * About the Raspberry Pi pins:
    * [Small GPIO bar (26pins)](https://www.raspberrypi.org/documentation/usage/gpio/) (Only version 1)
    * [Big GPIO Bar (40 pins)](https://www.raspberrypi.org/documentation/usage/gpio-plus-and-raspi2/README.md) (version 2 and 3)
 
  * About Coreboot:
    * [How to build coreboot](https://www.coreboot.org/Build_HOWTO)
    * [Chosing the right payload for you](https://www.coreboot.org/Payloads)

### Software
  * For getting and compiling flashrom and coreboot you need the following dependencies: (sudo apt install) ``build-essential pciutils-dev zlib1g-dev  libfti-dev libusb-dev subversion git wiringpi libncurses5-dev``
  * [flashrom (I recommend the latest version)](https://www.flashrom.org/Downloads)
  * https://github.com/flashrom/flashrom (A valid git clone url)
  * [The latest version of coreboot](https://www.coreboot.org/Build_HOWTO#Building_coreboot)
