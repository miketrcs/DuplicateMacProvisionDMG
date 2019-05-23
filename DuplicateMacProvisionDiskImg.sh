#!/bin/sh
# DuplicateMacProvisionDiskImg.sh
# Use sudo sh ./DuplicateMacProvisionDiskImg.sh to run
# *** Read info below before using!!! ***
# Mike Thompson, JMT, 4/2019, Rutherford County Schools

# This is a niche quick and dirty script for those wanting to speed up the process of duplicating Mac Provisioning USB Flash drives
# for Reimaging Apple/Mac computers. If you do not know what Mac Provisioner is (tool provided by Apple) you do not need this.
# Why did I do this? I needed a quicker way to mass duplicate Mac Provisioner USB drives for technicians in RCS. 
# The Mac Provisioner creates a multi-partition drive that you can option boot a MacBook/iMac/other and automatically install
# macOS. (Brief desc.) I did not right off find an easy way to seamlessly duplicate the multi-partition drive. Single partition
# can be easily duplicated with Disk Utility/other GUI utilities but from what I found not multi-partition (at the time of this
# writing). This script is looped, unmounts and asks you if you want to do another after duplication is finished. 
# Instructions:
# Make sure your partitions are correct by using "diskutil list" with your disk media below mounted and USB flash drive.
# Make sure you change the MacProvImageLoc to the dmg name you create. Mac Provisioner can create erase installs and upgrade installs
# so I name the dmg appropriately. You create the DMG file AFTER you create a USB flash drive with Mac to your liking. In
# disk utility GUI you can dismount the USB drive (both partitions) then right click on the dismounted flash drive inside 
# disk utility and create a DMG file (will create both partition inside the file. Email me if needed. 
# You could in theory use this for any multiple purpose multi-partition duplication, edit for your own purposes. 

# ************* Danger, /dev locations must be modified for your Mac/setup, if not you could destroy a partition!!! **************


#Create looped menu for making multiple duplications. 

#Clear screen

clear

diskutil list
#Loop Menu Variables
break='Continue Quit'
PS3='Type 1 then press Enter to Continue or 2 then Enter to Exit! *** Danger!! This script could wipe usable partitions if the disk locations are not changed in this script!!! ***'

#I recommend at least using a 32GB flash drive. Change the below variable needed to vary the size of the 1st partition
#Recommended flash drive ($9.xx from Amazon) Samsung USB 3.1 32GB FIT drives. Great heavy duty drives for the price!

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

#Finished, give time to let asr finish up, unmount flash drive

sleep 15

diskutil unmountDisk $FlashDriveLoc

done

clear
echo Disk copy Finished

diskutil list

exit 0

