# Introduction
This document helps you with using the script within this repository, which aims to completely automate the process of partitioning.

_Asteroid-belt, dec,2020 | written by Mohsen K. Amini_
# How it works
# Preparing the input file
The script works with an **input file** which contains all the information about the partitions that are to be made.

So the only thing that you are required to do here, is to fill out a file with these information. As expected there are some rules to that. Let's see what's it all about !
here's a sample input file:
~~~
/physical-address       label-type      Primary/extended        size    fstype  mountpoint      options dumpbackup      fscheck partition-number
/dev/sdb                mbr             p                       +300M   ext2    /mnt/mntpoint1  defaults        0       0       1
/dev/sdb                mbr             e                       +303M   -       -               -               -       -       2
/dev/sdb                mbr             l                       +30M    ext4    /mnt/mntpoint5  defaults        0       0       5
/dev/sdb                mbr             l                       +124M   swap    swap            defaults        0       0       6
/dev/sdc                gpt             -                       +2T     ext4    /mnt/mnt1       defaults        0       1       1
/dev/sdd                gpt             -                       +23M    swap    swap            defaults        1       2       125
/dev/sdd                gpt             -                       +2G     ext4    /mnt/mnt7       defaults        1       2       1
~~~
The important things that you must be careful about, in order for the script to work properly are :

- You need to make sure that `mkfs` tool, recognizes the **filesystem type** you're trying to format your partitions.

- You cannot make **swap partitions** that are based on a **file** rather than a disk partitions with this document.

- You need to fill the fields in a format that everything fits in sharp columns. Just like the sample above, as you can see, all the information fit perfectly under defined fields._we recommend you edit this sample to your own fits in notepad or vim_

- As shown in the sample you can't define fstype, mount point, etc, when you're defining an `extended` partition in `mbr` method. -_because simply we don't format them !_

- While you are defining `logical` partitions in `mbr` method, you **have to** stay in the scale of 5-6-7...-15 (in order) **we recommend always stay in order for this matter**

- The fields, parameteres and formats in columns : `label-type` `Primary/extended` `size` could only match with the formats above.

- **DO NOT** leave any parameter empty. like shown above just leave a `-`.

# Running the script
once you're all set up with the input file, you could go ahead and run ` fdisk-automation.sh`. At first the script makes sure that you have the `parted` package installed. After that, it asks for the address where the input file is stored on your machine. Put in the address and hit enter to continue.
~~~
==================================================================================================

Please enter the input file name :
~~~
It'll then automatically make the partitions, format and mount them to the addresses define in the input file.

# Monitor the report
At the end, you'll be provided with a little bit of report of made partitions, mounted ones and swap partitions that you wanted.
You might also want to check out `/etc/fstab` and `blkid` for more.




