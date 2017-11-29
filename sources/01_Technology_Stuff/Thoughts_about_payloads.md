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
