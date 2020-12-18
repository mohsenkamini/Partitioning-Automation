#!/bin/bash

# BASIC DIRECTORIES, VARIABLES AND PACKAGES

apt-get install parted -y || yum install parted || dnf install parted -y 2> /dev/null
tmp_dir=/tmp/fdisk.sh                                   # note that it does not end in a /
mkdir -p $tmp_dir 2> /dev/null

# MAIN SECTION ############################################################################################
source Fdisk-lib.sh
purify_inputfile
array_them
nop=0
for ((i=0; $nop < $nl; ))               # $i will always be the working row (=being processed partition)
do
                                        # Basically the for loop is in charge of choosing disks.
                                        #  and while loop works the partiotions on it
        PA=$(echo ${array1[$nop]})
        find_nop                        # we find the value of nop here because we want $i to go on untill
                                        # we get to the next PA -untill we are finished with the current PA
        counter=0
                                        # this is used for gpt. because when we use "g" in fdisk it'll delete
                                        # the already existing partitions and is only used when initializing.
echo $i $nop
        while [ $i -lt $nop ]
        do
                case ${array2[$i]} in
                        gpt)
                                echo $counter
                                if [ $counter = 0 ]
                                then
                                        init_partitioning_gpt
                                        format_it
                                        mkdir_mnt
                                        update_fstab
                                        ((counter++))
                                else
                                        continue_partitioning_gpt
                                        format_it
                                        mkdir_mnt
                                        update_fstab
                                fi
                        ;;
                        mbr)
                                partitioning_mbr
                                format_it
                                mkdir_mnt
                                update_fstab
                        ;;
                        *)
                                echo "none"
                        ;;
                        esac
                ((i++))
        done
done

report

# END #####################################################################################################

# Here's some explanation about the script:
# The loop above will deal with the input file as multiple groups of rows. It works like this: each
# group is defined based on physical addr. The "find_nop" function is in charge of that. It'll find the
# first PA, calculates how many partitions will be put into this disk, and simply spots the next PA.
# The index $i, which specifies the current, row will be incremented untill its value reaches $nop
# then it's time to work on the next PA; so $nop gets calculated and $i will try to reach its value again.

