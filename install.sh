#!/bin/bash
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
cp iuvolt /usr/bin/
chmod +x /usr/bin/iuvolt
cp iuvolt.service /etc/systemd/system/
systemctl enable iuvolt.service
echo "voltages=(0 0 0)" >> /etc/iuvolt.cfg
