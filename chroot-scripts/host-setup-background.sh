#!/bin/bash

LOCKFILE=hostsetup.lock
LOGFILE=hostsetup.log

if [ ! -f ${LOCKFILE} ]
then
	echo "starting setup in the background"
	bash ./host-setup.sh > ${LOGFILE} 2>&1 &
fi

[ -f ${LOCKFILE} ] && echo "setup is running..."
while [ -f ${LOCKFILE} ]
do
	echo -n '...'
	sleep 10s
done

echo ""
echo "Done."
echo ""

echo "tail of the setup log:"
tail ${LOGFILE}
