#!/bin/bash
#set -x

if [[ -e /opt/data/mac-address.txt ]]; then
	MYMAC=$(ifconfig eth0|grep ether|awk '{ print $2 }')
	LICMAC=$(cat /opt/data/mac-address.txt)
	if [[ "$MYMAC" != "$LICMAC" ]]; then
		echo "Nessus licensing is based on MAC address."
		echo "Previous MAC address: $LICMAC"
		echo "Current MAC address : $MYMAC"
		echo "Run with docker --mac-address $LICMAC"
		echo "Or delete max-address.txt from your data volume"
		exit 255
	fi
else
	ifconfig eth0|grep ether|awk '{ print $2 }' > /opt/data/mac-address.txt
	echo "Nessus licensing is based on MAC address."
	echo "This instance will tied to:"
	cat /opt/data/mac-address.txt
fi


for dir in etc sbin var; do
	if [[ ! -d /opt/data/$dir ]]; then
		mkdir /opt/data/$dir
		(cd /opt/nessus/$dir;tar -cf - .)|(cd /opt/data/$dir;tar -xf - )
		rm -rf /opt/nessus/$dir
		ln -s /opt/data/$dir /opt/nessus/$dir
	fi
done

case $1 in
	"")
		/opt/nessus/sbin/nessus-service
		;;
	*)
		exec $@
		;;
esac