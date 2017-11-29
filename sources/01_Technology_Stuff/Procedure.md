## Preparation
**1.** Disassemble your ThinkPad completely. The BIOS chips are on the inner side of the motherboard
(the side the CPU is on), which makes you need to remove the complete casing cage around it to be able to reach them.
They are hidden under some of the black foil but should find them  without big trouble, when searching.
They are next to the GPU or the empty spot, where a GPU couldve been.
(ADDME: Example Foto)

###In case you want to use a Raspberry Pi as an SPI flasher:
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
