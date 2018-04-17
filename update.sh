#!/bin/bash
# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
cp iuvolt /usr/bin/
chmod +x /usr/bin/iuvolt
status=disabled

if [ -f /etc/systemd/system/systemd-iuvolt.service ]; then
	status=$(systemctl is-enabled systemd-iuvolt.service)
	systemctl stop systemd-iuvolt.service
	systemctl disable systemd-iuvolt.service
	rm /etc/systemd/system/systemd-iuvolt.service
fi

cp iuvolt.service /etc/systemd/system/
systemctl daemon-reload

if [ "$status" = "enabled" ]; then
	systemctl enable iuvolt.service
fi

systemctl restart iuvolt.service
