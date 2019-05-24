<h2>Duplicate Mac Provisioning Flash Disk</h2>

NOTE: Moving development to DuplicateMacProvisionDMGMulti. If there are any issues with this stable I will change otherwise no new features will be added. https://github.com/miketrcs/DuplicateMacProvisionDMGMulti

*** Danger, this can be a destructive script, read below fully, not responsible for data loss!!! Must edit script to change drive locations to match your setup ***

This is a niche quick and dirty script for those wanting to speed up the process of duplicating Mac Provisioning USB Flash drives
for Reimaging Apple/Mac computers. If you do not know what Mac Provisioner is (tool provided by Apple) you do not need this.
Why did I do this? I needed a quicker way to mass duplicate Mac Provisioner created USB drives for technicians in RCS. 
The Mac Provisioner creates a multi-partition drive that you can option boot a MacBook/iMac/other and automatically install
macOS. (Brief desc.) I did not right off find an easy way to seamlessly duplicate the multi-partition drive. Single partition
can be easily duplicated with Disk Utility/other GUI utilities but from what I found not multi-partition (at the time of this
writing). This script is looped, unmounts and asks you if you want to do another after duplication is finished. 

************* Danger if you use Apple Time Capsule!!! If it automounts before you run this it could utilize a /dev/disk that 
was once allocated by a flash drive. Double check diskutil list! (Don't ask me how I know this...)

Instructions:
Make sure your partitions are correct by using "diskutil list" with your disk media below mounted and USB flash drive.
Make sure you change the MacProvImageLoc to the dmg name you create. Mac Provisioner can create erase installs and upgrade installs
so I name the dmg appropriately. You create the DMG file AFTER you create a USB flash drive with Mac Provisioner to your liking. In
disk utility GUI you can dismount the USB drive (both partitions) then right click on the dismounted flash drive inside 
disk utility and create a DMG file (will create both partitions inside the file). Email me if needed. 
You could in theory use this for any multi-partition duplication from DMG to USB flash drives, edit for your own purposes. 
Danger, /dev locations must be modified for your Mac/setup, if not you could destroy a partition!!! You have been warned!

To run from macOS terminal:

sudo su
sh DuplicateMacProvisionDiskImg.sh
