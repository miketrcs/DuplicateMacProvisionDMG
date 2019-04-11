#!/bin/sh
#DuplicateMacProvisionDiskImg.sh
#Use sudo sh ./DuplicateMacProvisionDiskImg.sh to run
#Partition flash drive
#Mike Thompson, JMT, 2019, Rutherford County Schools

# This is a niche quick and dirty script for those wanting to speed up the process of duplicating Mac Provisioning USB Flash drives
# for Reimaging Apple/Mac computers. If you do not know what Mac Provisioner is (tool provided by Apple) you do not need this.
# Why did I do this? Needed a quicker way to mass duplicate Mac Provisioner USB drives for technicians in RCS. Since it is a multi-
# partition usb flash drive after creation there was not a streamlined way I could find to duplicate "quickly" without creating something 
# on my own. 
#
# Make sure your partitions are correct by using "diskutil list" with your disk media below mounted and USB flash drive.

# ************* Danger, /dev locations must be modified for your Mac/setup, if not you could destroy a partition!!! **************


#Create looped menu for making multiple duplications. 

#Clear screen

clear

diskutil list
#Loop Menu Variables
break='Continue Quit'
PS3='Type 1 to Continue and 2 to Exit! *** Danger!! This script could wipe usable partitions if the disk locations are not changed in this script!!! ***'

#Can Leave. Change if needed to vary the size of the 1st partition
DrivePartSize1='16g'

: '
Danger!!! You need to do a diskutil list at the CLI to make sure the below is correct. Mount the DMG you created from your USB
 key the provisioner built to confirm the below will be correct on your Mac setup.
 Make sure you rename the Provisioning Image with a shortfile name. (otherwise it will need to be escaped out)
'

FlashDriveLoc='/dev/disk3'
MacProvImageLoc='/Users/thompsonmike/Desktop/MacProvisioning/MacProvErase.dmg'
DiskImgPart1='/dev/disk4s2'
DiskImgPart2='/dev/disk4s3'
FlashPart1='/dev/disk3s2'
FlashPart2='/dev/disk3s3'


select name in $break
do
	if [ $name == 'Quit' ]
	then
		break
	fi

echo
echo
echo

#Creates 2 partitions on a 32GB+ Flash Drive/other, 16GB for the first one and then use the rest for the second one. 
#Can change the size below if needed. 
diskutil partitionDisk $FlashDriveLoc GPT JHFS+ First $DrivePartSize1 JHFS+ Second 0b

#Mount Disk Image previously made with Disk Utility from flash drive read only (Example location)

hdiutil mount -readonly $MacProvImageLoc

#Restore partition #1
sudo asr restore --erase --noprompt -source $DiskImgPart1 --target $FlashPart1

#Restore partition #2
sudo asr restore --erase --noprompt -source $DiskImgPart2  --target $FlashPart2

#Finished, unmount flash drive

sleep 5

diskutil unmountDisk /dev/disk3

done

clear
echo Disk copy Finished

diskutil list

exit 0

