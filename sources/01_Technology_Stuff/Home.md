# Installing Coreboot on the Lenovo Thinkpad T430

## Intro 
**This is NOT a guide, is this a documentation**, but when you read it, you might get quite some extra infos I collected while doing so.
Big thanks to [jn](https://github.com/neuschaefer), TobiX (Link possibly coming soon) and the rest of [@CCCAC](https://twitter.com/CCCAC) for helping me out with giving a shitload of info, experience, (hardware-)resources, strong nerves and a shitload of Club Mate.

The Thinkpad T430 uses two BIOS Chips, which are summarized to use one 12MB storage pool together.
The first chip is a 4MB MX25L3205D and the second chip is a 8MB MX25L6405D or protocol-compatible chip.
In my case the second chip was a [WIP]. All (or at least most) chips should be compatible with flashrom, which I used to transfer data onto the chips.
[Coreboot-ThinkPads](https://github.com/bibanon/Coreboot-ThinkPads/wiki) 
who created a guide for a whitelist removal for the T430 and a guide on [how to flash the BIOS chips of the ThinkPad T/X60 and the Macbook 2,1](https://github.com/bibanon/Coreboot-ThinkPads/wiki/Hardware-Flashing-with-Raspberry-Pi)

Thanks at this point to [bibanon](https://github.com/bibanon) not just for these guides but also for giving me the knowledge that gave me the balls to try this project in the first place.

**OBLIGATORY DISCLAIMER:**

Your warranty is now void. I am not responsible for bricked devices, dead SD cards/harddrives/hardware in general, thermonuclear war, or you getting fired because anything related to this guide failed. Please do some research if you have any concerns about any procedure steps included in this guide before following it blindly! **YOU** are choosing to make these modifications and when you mess up your device it is not my fault!
