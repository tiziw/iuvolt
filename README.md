# iuvolt
Experimental script to undervolt Intel CPUs

## Disclaimer
This method to undervolt has been found by users at notebookreview forums, no reports of permanent damage have been reported, but it is still experimental. 

## What does this script do?
This script takes voltage offsets (parameters or from config) and converts them to the right HEX values then writes them to the registers responsible for undervolting using the wrmsr command from the msr-tools package. This mechanism is reverse engineered from the windows program ThrottleStop, it writes to the msr 0x150 register.

## Info on undervolting
I suggest you read https://github.com/mihic/linux-intel-undervolt first, especially the info regarding the voltage planes. Also read the thread at notebookreview, link in credits. As far as safety, this method is fairly untested, it's been pretty much reverse engineered by the community so beware. Make sure to read the thread as it contains the experience of others, there have been no reports of permanent damage using this method. 

## Requirements
This script depends on ``` msr-tools ``` for writing/reading to registers and ``` bc ``` for floating-point arithmetic. Make sure the msr module is loaded using ``` lsmod | grep msr ```. If it's not loaded then you'll have to manually configure it to load on boot, if you want to load it temporarily use ``` modprobe msr ```.

## Supported CPUs
Theoretically, this method of undervolting works only with `3rd gen Intel CPUs` and newer. It's been noted in the notebookreview forum thread that Intel Secure Boot blocks the wrmsr command from working properly and has to be disabled for this method to work.

For Intel CPUs older than 3rd gen the PHC method has to be used. More info on do it can be found at https://wiki.archlinux.org/index.php/PHC.

## Installation
```
git clone https://github.com/tiziw/iuvolt.git
cd iuvolt && sudo chmod +x install.sh
sudo ./install.sh

#Experiment with right values
sudo iuvolt -90 -80 -90

#Save values to config
vi /etc/iuvolt.cfg
```

## How to use

Usage:
```
iuvolt [CORE_OFFSET GPU_OFFSET CACHE_OFFSET UNCORE_OFFSET ANALOGIO_OFFSET DIGITAL_OFFSET]
```
All undervolts are in mV, if you wanna skip an offset, put 0 in its place. The CPU Core and Cache share the same voltage plane. If you define 2 different offsets for them then the highest of the 2 will be chosen. Uncore and AnalogIO are highly experimental and haven't been tested, digital offset is greyed out in ThrottleStop and is either not functional or unsupported.

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
systemctl enable iuvolt.service
```
Systemd will run iuvolt on boot and on/after sleep. The systemd service runs iuvolt without parameters so you'll have to set the values using the config file first.

You can also run ``` install.sh ``` that'll do the setup for you, all you have to do is edit the config file with the right undervolt parameters, as it'll have 0 values by default.

In order to update your version of the script, clone the repository then run update.sh as root.

## Credits

The method to calculate the right values, what register to write to using what command to was taken from https://github.com/mihic/linux-intel-undervolt and from http://forum.notebookreview.com/threads/undervolting-e-g-skylake-in-linux.807953 the json and python scripts posted there were very useful. 

All credits go to the notebookreview community, they did pretty much all the work.

All pull requests are welcome.

## TODO
Make the systemd script work in all scenarios.

## Ideas
Implement per-cpu profiles. Users can contribute offsets they've tested on their CPU and found to be safe. That way it saves time for new users with a same CPU.
