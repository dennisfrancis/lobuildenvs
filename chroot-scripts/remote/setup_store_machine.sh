#!/bin/bash

source ../envvars.sh

ssh root@storemc "df -hl -t ext4 | grep /media/extra" > /dev/null
if [ $? -eq 0 ]
then
	echo "storemc init already done! : The extra device is already setup and mounted."
	echo ""
	ssh root@storemc "df -hl -t ext4"
	exit 0
fi

ssh root@storemc "[ -b ${STOREMC_EXTRA_BLKDEV} ]"
if [ $? -ne 0 ]
then
	echo "Error : Block device file ${STOREMC_EXTRA_BLKDEV} not found! Enable the device by editing the profile."
	exit -1
fi

echo "Found extra device file ${STOREMC_EXTRA_BLKDEV}"


#-----------------------------------------------------------
# add fstab entry

ssh root@storemc "grep ${STOREMC_EXTRA_BLKDEV} /etc/fstab" > /dev/null
if [ $? -eq 0 ]
then
	echo "Error : There is an ${STOREMC_EXTRA_BLKDEV} entry in the fstab already. Login and check if this is the extra disk."
	exit -1
fi

ssh root@storemc "mkdir -p ${STOREMC_EXTRA_MOUNT_DIR}"
if [ $? -ne 0 ]
then
	echo "Cannot create ${STOREMC_EXTRA_MOUNT_DIR}"
	exit -1
fi

FSTAB_LINE="${STOREMC_EXTRA_BLKDEV}       ${STOREMC_EXTRA_MOUNT_DIR}     ext4    defaults          0      1"

ssh root@storemc "echo \"${FSTAB_LINE}\" >> /etc/fstab"

echo "Added extra device to fstab :"
grep ${STOREMC_EXTRA_BLKDEV} /etc/fstab
echo ""

#-----------------------------------------------------------
# Mount extra device

ssh root@storemc "mount ${STOREMC_EXTRA_MOUNT_DIR}"

if [ $? -ne 0 ]
then
	errcode=$?
	echo "mounting failed! mount cmd retcode = ${errcode}"
	exit -1
fi

echo "Mounted extra device(${STOREMC_EXTRA_BLKDEV}) under ${STOREMC_EXTRA_MOUNT_DIR}"
echo ""
ssh root@storemc "df -hl -t ext4"
echo ""

