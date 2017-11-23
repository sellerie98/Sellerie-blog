% Installing Debian on PCEngines APU2

---

**TLDR: Add `console=ttyS0,115200n8` to kernel cmdline**

---

## Download Debian
The PCEngines APU2 is a x86_64 CPU, meaning it can boot standart Desktop Linux distributions execpt for the ability to output graphics. Debian offers a graphical and a textbase installer. Therefor with the later we can install easily. 

Debian Images can be found at [debian.org](https://www.debian.org/distrib/). Choose a version that suits you. "small installation image" is what is generally refered to as "netinstall".

In this guide we go with "debian-9.2.1-amd64-netinst.iso".

## Preare USB Stick
## Windows
Use [Win32DiskImager](https://sourceforge.net/projects/win32diskimager/) to copy the Image to your stick.

## Linux
To copy the image to an install stick we use `dd` to copy it:

`dd if=debian-9.2.1-amd64-netinst.iso of=/dev/sdX bs=4M`

Replace sdX with your device. You can use `dmesg`shortly after pluggin in to figure it out.

## Establish serial connection
Plug your USB->RS232 adapter into both machines. Based on your preferences you can use any tool you want.

### Windows 
Use [putty](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html) to establish a serial connection with 115200 Baud (Speed) to **COMX** where **X** refers to your adapter.

### Linux
We will cover two **alternative** tools here:

#### busybox microcom
Run as **root** or use **sudo**:

`busybox microcom /dev/ttyUSB0 -s115200`

#### screen
Run as **root** or use **sudo**:

`screen /dev/ttyUSB0 115200`

## Booting the APU2
Connect the USB stick, power and monitor the serial output. You should see something like this:

Press F10, choose your USB stick and hit enter.

![](tech/0x00/bootup.png "bootup")

In the now opening boot menu we need to modify the kernel cmdline. Choose `Install` and hit `TAB`.
Now add **`console=ttyS0,115200n8`** after the `quiet`. Hit enter to boot the system.

![](tech/0x00/bootup_menu.png "menu")

## Post Boot
Follow the installation process and dont forget to enable **SSH-Server** if you want to control your device remotly after installation.

![](tech/0x00/installer.png "installer")


The Debian Stretch Installer will copy the kernel boot parameter so you should end up with a system outputting to serial after installation finished.

![](tech/0x00/installing.png "installing")

Reboot and enjoy!


