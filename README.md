# Introduction
This document helps you with using the script within this repository, which aims to completely automate the process of partitioning.

_Asteroid-belt, dec,2020 | written by Mohsen K. Amini_
# How it works
The script works with an **input file** which contains all the information about the partitions that are to be made.

So the only thing that you are aquired to do here, is to fill out a file with these information. As expected there are some rules to that. Let's what's it all about !
here's a sample input file:
~~~
/physical-address       label-type      Primary/extended        size    fstype  mountpoint      options dumpbackup      fscheck partition-number
/dev/sdb                mbr             p                       +300M   ext2    /mnt/mntpoint1  defaults        0       0       1
/dev/sdb                mbr             e                       +303M   -       -               -               -       -       2
/dev/sdb                mbr             l                       +30M    ext4    /mnt/mntpoint5  defaults        0       0       5
/dev/sdb                mbr             l                       +124M   swap    swap            defaults        0       0       6
/dev/sdc                gpt             -                       +2G     ext4    /mnt/mnt1       defaults        0       1       1
/dev/sdd                gpt             -                       +23M    swap    swap            defaults        1       2       125
/dev/sdd                gpt             -                       +2G     ext4    /mnt/mnt7       defaults        1       2       1
~~~
