# Introduction
This document helps you with using the script within this repository, which aims to completely automate the process of partitioning.

_Written by Mohsen K. Amini, Asteroid-belt | dec,2020_

# How it works
# Preparing the input file
`fdisk-automation.sh` works with an **input file** which contains all the information about the partitions that are to be made.

So the only thing that you are required to do here, is to fill out a file with these information. As expected there are some rules to that. Let's see what's it all about !
here's a sample input file:
~~~
physical-address       label-type      Primary/extended        size    fstype  mountpoint      options dumpbackup      fscheck partition-number
/dev/sdb                mbr             p                       +300M   ext2    /mnt/mntpoint1  defaults        0       0       1
/dev/sdb                mbr             e                       +303M   -       -               -               -       -       2
/dev/sdb                mbr             l                       +30M    ext4    /mnt/mntpoint5  defaults        0       0       5
/dev/sdb                mbr             l                       +124M   swap    swap            defaults        0       0       6
/dev/sdc                gpt             -                       +2T     ext4    /mnt/mnt1       defaults        0       1       1
/dev/sdd                gpt             -                       +23M    swap    swap            defaults        1       2       125
/dev/sdd                gpt             -                       +2G     ext4    /mnt/mnt7       defaults        1       2       1
~~~
The important things that you must be careful about, in order for the script to function properly are :

- This script isn't meant to **edit partitions** on a disk, (although you can do this on `mbr` disks). This script should only be used to initiate partitioning on a disk.

- The field `Primary/extended` should be filled out **only** when defining an `mbr` partition. otherwise you should just leave a `-`.
 
- The `physical addresses` need to be back to back. It means that, when you start partitioning on e.g `/dev/sdb` you need to finish all the partitions on `/dev/sdb` before you go to the next physical disk.

- You need to make sure that `mkfs` tool, recognizes the **filesystem type** you're trying to format your partitions.

- You cannot create **swap partitions** that are based on a **file** rather than a disk partition with this script. [more on that](https://docs.alfresco.com/3.4/tasks/swap-space-lin.html)

- You need to fill the fields in a format that everything fits in sharp columns. Just like the sample above, as you can see, all the information fit perfectly under defined fields._we recommend you edit this sample to your own fits in notepad or_ `vim`

- As shown in the sample you can't define fstype, mount point, etc, when you're defining an `extended` partition in `mbr` method. -_because simply we don't format them !_

- While you are defining `logical` partitions in `mbr` method, you **have to** stay in the scale of 5-6-7...-15 (in order) **we recommend always stay in order for this matter**.

- The fields, parameteres and formats in columns : `label-type` `Primary/extended` `size` could only match with the formats shown in the example.

- **DO NOT** leave any parameter empty. like shown above just leave a `-`.

- You don't need to create the mount point directories you define in the input file. the script will do that automatically for you.

# Running the script
once you're all set up with the input file, you could go ahead and run ` fdisk-automation.sh`. At first the script makes sure that you have the `parted` package installed. After that, it asks for the address where the input file is stored on your machine. Put in the address and hit enter to continue.
~~~
==================================================================================================

Please enter the input file name :
~~~
It'll then automatically make the partitions, format and mount them to the addresses defined in the input file.

# Monitor the report
At the end, you'll be provided with a little bit of report of made partitions, mounted ones and swap partitions that you wanted.
You might also want to check out `/etc/fstab` and `blkid` for more.

The report will look like something like this :
~~~
########################################## FINAL REPORT ##########################################

=========================================== MADE PARTITIONS ======================================

NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0    8G  0 disk
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0    7G  0 part
  ├─centos-root 253:0    0  6.2G  0 lvm  /
  └─centos-swap 253:1    0  820M  0 lvm  [SWAP]
sdb               8:16   0    5G  0 disk
├─sdb1            8:17   0  300M  0 part /mnt/mntpoint1
├─sdb2            8:18   0  301M  0 part /mnt/mntpoint2
├─sdb3            8:19   0    2G  0 part /mnt/mntpoint3
├─sdb4            8:20   0  512B  0 part
├─sdb5            8:21   0   30M  0 part /mnt/mntpoint5
├─sdb6            8:22   0   24M  0 part /mnt/mntpoint6
└─sdb7            8:23   0  124M  0 part [SWAP]
sdc               8:32   0    8G  0 disk
├─sdc1            8:33   0    2G  0 part /mnt/mnt1
├─sdc2            8:34   0  120M  0 part /mnt/mnt2
├─sdc3            8:35   0  120M  0 part /mnt/mnt3
├─sdc4            8:36   0  120M  0 part /mnt/mnt4
├─sdc5            8:37   0  120M  0 part /mnt/mnt5
└─sdc6            8:38   0  120M  0 part /mnt/mnt6
sdd               8:48   0    8G  0 disk
├─sdd1            8:49   0    2G  0 part /mnt/mnt7
└─sdd125        259:0    0   23M  0 part [SWAP]
========================================== MOUNTED PARTITIONS ====================================

Filesystem               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root  6.2G  1.5G  4.8G  25% /
devtmpfs                 485M     0  485M   0% /dev
tmpfs                    496M     0  496M   0% /dev/shm
tmpfs                    496M  7.1M  489M   2% /run
tmpfs                    496M     0  496M   0% /sys/fs/cgroup
/dev/sda1               1014M  132M  883M  13% /boot
tmpfs                    100M     0  100M   0% /run/user/0
/dev/sdb1                291M  2.1M  274M   1% /mnt/mntpoint1
/dev/sdb2                292M  2.1M  275M   1% /mnt/mntpoint2
/dev/sdb3                2.0G  6.0M  1.8G   1% /mnt/mntpoint3
/dev/sdb5                 29M  731K   26M   3% /mnt/mntpoint5
/dev/sdb6                 23M  396K   21M   2% /mnt/mntpoint6
/dev/sdc1                2.0G  6.0M  1.8G   1% /mnt/mnt1
/dev/sdc2                113M  1.6M  105M   2% /mnt/mnt2
/dev/sdc3                113M  1.6M  105M   2% /mnt/mnt3
/dev/sdc4                113M  1.6M  105M   2% /mnt/mnt4
/dev/sdc5                113M  1.6M  105M   2% /mnt/mnt5
/dev/sdc6                113M  1.6M  105M   2% /mnt/mnt6
/dev/sdd1                2.0G  6.0M  1.8G   1% /mnt/mnt7
=========================================== SWAP PARTITIONS ======================================

Filename                                Type            Size    Used    Priority
/dev/dm-1                               partition       839676  0       -2
/dev/sdb7                               partition       126972  0       -3
/dev/sdd125                             partition       23548   0       -4
##################################################################################################

~~~


