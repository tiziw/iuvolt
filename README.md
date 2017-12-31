# iuvolt
Script to undervolt Intel CPUs

This script takes voltage offsets (parameters or from config) and converts them to the right HEX values then writes them to the registers responsible for undervolting using wrmsr from the msr-tools package.

The script takes either voltage offsets as parameters, or it'll automatically load them from /etc/iuvolt.cfg
The config file only needs 1 variable of type array with the name voltages. Example:
```
voltages=(90.8 80.1 90.8)
```
Everytime iuvolt is ran it'll automatically load the values if the config is present

If you use systemd you can put systemd-iuvolt.service into /etc/systemd/system/ and then enable it using 
```
systemctl enable systemd-iuvolt.service
```
As for making the script run after sleep, you can make a tiny script that runs iuvolt and put it in /usr/lib/systemd/system-sleep/. (Note that this is a hack)
Example that can be used without config:
```
#!/bin/bash
iuvolt 90.8 80.1 90.8
```

##Credits

The method to calculate the right values, what register to write to using what command to was taken from https://github.com/mihic/linux-intel-undervolt and from http://forum.notebookreview.com/threads/undervolting-e-g-skylake-in-linux.807953 the json and python scripts posted there were very useful. 

All credits go to the notebookreview community, they did pretty much all the work.

All pull requests are welcome.

##TODO
Make the systemd script work in all scenarios.

##IDEAS
Implement per-cpu profiles. Users can contribute offsets they've tested on their CPU and found to be safe. That way it saves time for new users with a same CPU.
