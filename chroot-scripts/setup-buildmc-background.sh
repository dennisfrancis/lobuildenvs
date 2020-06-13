#!/bin/bash

LOCKFILE=setup-buildmc.lock
LOGFILE=setup-buildmc.log

if [ ! -f ${LOCKFILE} ]
then
	rm -f ${LOGFILE}
	echo "starting setup-buildmc.sh in the background"
	bash ./setup-buildmc.sh > ${LOGFILE} 2>&1 &
	while [ ! -f ${LOGFILE} ]
	do
		sleep 1s
	done
fi

[ -f ${LOCKFILE} ] && echo "setup-buildmc.sh is running..."
while [ -f ${LOCKFILE} ]
do
	echo -n '...'
	sleep 5s
done

echo ""
echo "Done."
echo ""

echo "tail of setup-buildmc.sh log:"
echo "----------------------------"
tail ${LOGFILE}
echo "----------------------------"
echo ""

