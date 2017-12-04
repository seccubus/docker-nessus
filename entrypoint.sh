#!/bin/bash
set -x

for dir in etc sbin var; do
	if [[ ! -d /opt/data/$dir ]]; then
		mkdir /opt/data/$dir
		(cd /opt/nessus/$dir;tar -cf - .)|(cd /opt/data/$dir;tar -xvf - )
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