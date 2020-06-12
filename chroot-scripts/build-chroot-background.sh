#!/bin/bash

LOCKFILE=buildchroot.lock
LOGFILE=buildchroot.log

if [ ! -f ${LOCKFILE} ]
then
	echo "starting build-chroot.sh in the background"
	bash ./build-chroot.sh > ${LOGFILE} 2>&1 &
fi

[ -f ${LOCKFILE} ] && echo "build-chroot.sh is running..."
while [ -f ${LOCKFILE} ]
do
	echo -n '...'
	sleep 5s
done

echo ""
echo "Done."
echo ""

echo "tail of build-chroot.sh log:"
tail ${LOGFILE}

