# Making the Nintendo Switch truly yours, aka. how to boot Linux off the Nintendo Switch

#Intro
Just recently, an anonymous person released a [fatal NVIDIA Tegra BootROM bug](https://pastebin.com/4ykNxzU5).
Also, the bootROM itself has been leaked.
Shortly after, [an IDA db file has been released by q3k and G33KatWork](https://twitter.com/q3k/status/988206620005076994)
[(direct link to the file)](https://q3k.org/u/6eac2986691922d02e9b25f3b767fd7ea9c44ca18bf7b792884e5c665df5152a.idc) ,
[mirror](https://aufmachen.jetzt/6eac2986691922d02e9b25f3b767fd7ea9c44ca18bf7b792884e5c665df5152a.idc).
However, because of this, fail0verfow also released their exploit using a patched coreboot and u-boot to run a linux on the Nintendo Switch on [github](https://github.com/fail0verflow).  
So far it has been discovered that using the exploit messes up the Switch's battery calibration, which can cause random shutdowns in SwitchOS under the usual threshold of ~50%.  
However, this bootROM bug is non-patchable and undsicoverable by Nintendo, which means that you cannot get banned from the Nintendo Services when using Linux for the Switch.  
At the moment it is a little buggy, e.g. wifi does not work on the first ever boot of the OS, also the USB-C port is not usable at the moment.  
But if you don't care and want to test it out or want to start debugging/developing for this device, you can do this relatively easily.

I prebaked the needed files (and included files) so you can use it more easily:
[Download](https://aufmachen.jetzt/switch-exploit.tar.bz2)  
Sources are also still included, and I will try to update the included binaries at least weekly.

## Requirements:

### Hardware needed:
- A Nintendo Switch, best when full charged before.
- a ["SwitchX-Pro"](https://twitter.com/fail0verflow/status/988445232445378561), which you can build yourself with [this](https://github.com/fail0verflow/shofel2/tree/master/rcm-jig) and two pins of a male micro-USB cable.
- a USB 3.0 (XHCI) port on your device
- a USB type C cable e.g. the Nintendo Switch Pro Controller cable
- a micro-SD card

### Software:
- either the tar-ed collection mentioned above or the git repos:
	- `git clone https://github.com/fail0verflow/shofel2`
	- `https://github.com/fail0verflow/switch-linux linux`
	- `https://github.com/fail0verflow/switch-coreboot coreboot`
	- `https://github.com/fail0verflow/switch-u-boot`
	- `git clone https://github.com/boundarydevices/imx_usb_loader.git`
- When cloning and compiling yourself, you also need to put this file into the coreboot directory: [Download](https://gruetzkopf.org/tegra_mtc.bin)
You can then start at the 'Run the exploit' section of the readme  file,
found in 'shofel2/README.md'
