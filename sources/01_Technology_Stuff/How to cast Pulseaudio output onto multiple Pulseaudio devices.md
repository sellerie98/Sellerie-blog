# How to cast Pulseaudio output onto multiple Pulseaudio devices

## Intro
My plan was to make it possible to build some kind of multiroom audio using only Pulseaudio.
This is possible by combining the modules `module-tunnel-sink-new` and `module-combine-sink`.


## Requirements
All devices you want to connect to each other will require a running Pulseaudio server and a network server enabled.
Casting audio over the network seems to be quite network-heavy so using this over a wi-fi connection is not recommended.


## Implementation

You will have to add each pulse endpoint server as sinks:
`pacmd load-module module-tunnel-sink-new server=<IP/FQDN> sink_name=<endpoint_name> channels=2 rate=48000`

After that you might have to unload the module `module-combine-sink` because the default config of e.g. Debian usually configures the module in a way that doesnt support us: <br>
`pacmd unload-module module-combine-sink`
Now the module is configured to combine the network sinks into a simoultaneous output. The list of the just-created local sinks is put behind the `slaves`-directive separated with commata: <br>
`pacmd load-module module-combine-sink slaves=<endpoint,name>`

Now you can run any application and set the output to the combine-sink to cast audio to all network sinks!
