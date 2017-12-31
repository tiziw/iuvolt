# iuvolt
Experimental script to undervolt Intel CPUs

## Disclaimer
This method to undervolt has been found by users at notebookreview forums, no reports of permanent damage have been reported, but it is still experimental. 

## What does this script do?
This script takes voltage offsets (parameters or from config) and converts them to the right HEX values then writes them to the registers responsible for undervolting using the wrmsr command from the msr-tools package.

## Info on undervolting
I suggest you read https://github.com/mihic/linux-intel-undervolt first, especially the info regarding the voltage planes. Also read the thread at notebookreview, link in credits. As far as safety, this method is fairly untested, it's been pretty much reverse engineered by the community so beware. Make sure to read the thread as it contains the experience of others, there have been no reports of permanent damage using this method. 

## How to use

To install the script put it in /usr/bin/iuvolt then use ``` chmod +x ```

The script takes either voltage offsets as parameters, or it'll automatically load them from /etc/iuvolt.cfg
The config file only needs 1 variable of type array with the name voltages. 
Example without config:
```
iuvolt -90.8 -80.1 -90.8
```
Example of config (/etc/iuvolt.cfg)
```
voltages=(-90.8 -80.1 -90.8)
```

Everytime ``` iuvolt ``` without parameters it'll (try to) automatically load the values from the config.

If you use systemd you can put systemd-iuvolt.service into /etc/systemd/system/ and then enable it using 
```
systemctl enable systemd-iuvolt.service
```
The systemd service runs iuvolt without parameters so it's advised that you configure it first.

As for making the script run after sleep, you can make a tiny script that runs iuvolt and put it in /usr/lib/systemd/system-sleep/. (Note that this is a hack)
Example that can be used without config:
```
#!/bin/bash
iuvolt
```

You can also run ``` install.sh ``` that'll do the setup for you, all you have to do is edit the config file with the right undervolt parameters, as it'll be empty by default.

## Credits

The method to calculate the right values, what register to write to using what command to was taken from https://github.com/mihic/linux-intel-undervolt and from http://forum.notebookreview.com/threads/undervolting-e-g-skylake-in-linux.807953 the json and python scripts posted there were very useful. 

All credits go to the notebookreview community, they did pretty much all the work.

All pull requests are welcome.

## TODO
Make the systemd script work in all scenarios.

## IDEAS
Implement per-cpu profiles. Users can contribute offsets they've tested on their CPU and found to be safe. That way it saves time for new users with a same CPU.
