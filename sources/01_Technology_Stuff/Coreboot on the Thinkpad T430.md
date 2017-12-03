# Installing Coreboot on the Lenovo Thinkpad T430

## Intro 
**This is NOT a guide, is this a documentation**, but when you read it, you might get quite some extra infos I collected while doing so.
Big thanks to [jn](https://github.com/neuschaefer), TobiX (Link possibly coming soon) and the rest of [@CCCAC](https://twitter.com/CCCAC) for helping me out with giving a shitload of info, experience, (hardware-)resources, strong nerves and a shitload of Club Mate.

The Thinkpad T430 uses two BIOS Chips, which are summarized to use one 12MB storage pool together.
The first chip is a 4MB MX25L3205D and the second chip is a 8MB Winbond and  protocol-compatible chip.
In my case the second chip was a [WIP]. All (or at least most) chips should be compatible with flashrom, which I used to transfer data onto the chips.
[Coreboot-ThinkPads](https://github.com/bibanon/Coreboot-ThinkPads/wiki) 
who created a guide for a whitelist removal for the T430 and a guide on [how to flash the BIOS chips of the ThinkPad T/X60 and the Macbook 2,1](https://github.com/bibanon/Coreboot-ThinkPads/wiki/Hardware-Flashing-with-Raspberry-Pi)

Thanks at this point to [bibanon](https://github.com/bibanon) not just for these guides but also for giving me the knowledge that gave me the balls to try this project in the first place.

**OBLIGATORY DISCLAIMER:**

Your warranty is now void. I am not responsible for bricked devices, dead SD cards/harddrives/hardware in general, thermonuclear war, or you getting fired because anything related to this guide failed. Please do some research if you have any concerns about any procedure steps included in this guide before following it blindly! **YOU** are choosing to make these modifications and when you mess up your device it is not my fault!



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
  * For getting and compiling flashrom and coreboot you need the following dependencies:
```build-essential pciutils-dev zlib1g-dev  libfti-dev libusb-dev subversion
 git wiringpi libncurses5-dev```
  * [flashrom (I recommend the latest version)](https://www.flashrom.org/Downloads)
  * https://github.com/flashrom/flashrom (A valid git clone url)
  * [The latest version of coreboot](https://www.coreboot.org/Build_HOWTO#Building_coreboot)


## Preparation

**1.** Disassemble your ThinkPad completely. The BIOS chips are on the inner side of the motherboard
(the side the CPU is on), which makes you need to remove the complete casing cage around it to be able to reach them.
They are hidden under some of the black foil but should find them  without big trouble, when searching.
They are next to the GPU or the empty spot, where a GPU couldve been.
(ADDME: Example Foto)

**2.** Setup your Raspberry Pi to run a Linux distro, I used [Raspbian from the Raspberry Pi website](https://www.raspberrypi.org/downloads/raspbian/), the packages listed on the requirements page and install flashrom.
In case you Raspbian, you need to download and compile flashrom yourself, which I recommend to get the latest version (linked on the [requirements page under Software](https://github.com/sellerie98/Coreboot-T430/wiki/Requirements#software)), but that takes a few minutes at max.
* Run ``# raspi-config`` go to advanced options (8) and enable spi 
* Loading the spi kernel modules via ``# modprobe spi_bcm2835``
* ``# modprobe spidev``

**3.** Connect the clamp to the RaspberryPi accordingly.
It is safe to use the [pin layout of bibanon's guide](https://github.com/bibanon/Coreboot-ThinkPads/wiki/Hardware-Flashing-with-Raspberry-Pi#pomona-clip-pinout), but the picture shows the small GPIO layout. You can use the same pins on the big layout, when chosing them relative from the left (outer) side only.
Check the [chip documentation](http://www.macronix.com/Lists/Datasheet/Attachments/4978/MX25L6405D,%203V,%2064Mb,%20v1.5.pdf) once again before connecting the clamp to make sure you got everything right. For orientation there is a small hole on the top side of the chip that marks the position of pin one.
The other positions should also be marked with small numbers on the mainboard itself. When you think that you are sure its correct, check it once again.
Yes, you can get BIOS chip replacements on ebay or on other stores,
but I highly doubt that you want or need to solder out the bios chip and replace it with a new one to make the device work again.

**4.** Now connect the SOIC8 clamp to the first chip (The upper one when looking from the sata port of the Drive/Ultrabay port).
The chip does not need to be instantly fried when you dont get the clamp on the chip correctly in the first try/ies,
but you should make sure to get it on properly to prevent damage to the chip.
[ADDME: PHOTO]

**5.** run ``# ./flashrom -p linux_spi:dev=/dev/spidev0.0`` to check whether the chip is recognized.

In case the chip is not recognized, check your pin connections and whether the pinout is correct on the RasPi side.
Also check whether the clamp seats properly.
As long as VCC is not connected on another pin that is not-VCC, there is no need to worry. (WP and HOLD are pins that are supposed to be pulled up to 3.3V so this is also not critical.

In case it does, you can start dumping the chip with ``# ./flashrom -p linux_spi:dev=/dev/spidev0.0 -r <pathtodumpfile>``
I recommend to create at least 3 dumps and create checksums (sha1 at minimum) of all of them. If they differ, create dumps until you have 3 dumps in a row that all have the same checksum.


**6.** When you successfully created multiple dumps of your bios chips, I recommend creating dumps of both chips and creating copies **OFFSITE** (e.g. on a USB drive), you can now build your coreboot: Git clone the coreboot repo (see the resources page) and type make menuconfig or make nconfig. It is recommended to define the device under Mainboard first to use optimized defaults. Set the chip size to 4MB. 

**7.** After checking the file size (It needs to be exactly 4M in size),
flash the coreboot.rom file to your 4MB chip with
``# ./flashrom -p linux_spi:dev=/dev/spidev0.0 -w <pathtoromfile> (-c <Recognized chip> (only needed when flashrom puts out an ambiguity and refuses to continue without the precise chip identifier being named))``.
When this is done, you should be good to go.

Optional:
**8.** Use me_cleaner on a copy of a valid dump file you created off the SECOND (8M) chip and clean the Intel ME on it to a point where it is basically unfunctional.
Now flash the image back to the second chip with the command from the step above.
When this is done: Congratulations, you successfully installed coreboot and cleaned the Intel ME!



## My personal thoughts about chosing the right payload

### SeaBIOS

When installing CB for the first time, I recommend not going for GRUB2 or Linux instantly.
It shows proper graphics and is not complicated to use.
IMO it is the best for testing the installation and getting comfortable with your coreboot installation.

### GRUB2
This is the payload I personally prefer, but I did quite some configuring to it to make it work better and more personalized.
I recommend going for this in the long run in case you update your kernel more often and therefore it should stay on the harddrive.
It accelerates the boot procedure a lot and is minimal, plus you can set a boot password and integrate it right into the flash.

The only thing that I dont like about it is that finding a proper menuentry example for secondary payloads that I got from another cb user in the end.

In case someone doesnt find a proper one:

menuentry '<payload name, freely choosable>' {
chainloader (cbfsdisk)/img/<name of payload>
}

When you are not sure about the name, you can check it with cbfstool in the built image.

###Tianocore/EDK2

No, just no.
We went such a long way to get rid of UEFI, and now you try to get it that way?
There is just far too much unaudited code for this to be a recommendable payload,
especially since it is not properly working on coreboot yet, so the only way to get it working properly is to use it via a virtual floppy from seaBIOS. This is not beautiful IMO. Just...better leave that thing alone.
