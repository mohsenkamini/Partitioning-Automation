#!/bin/bash

# BASIC DIRECTORIES AND VARIABLES AND PACKAGES

apt-get install parted -y || yum install parted -y
tmp_dir=/tmp/fdisk.sh                                   # note that it does not end in a /
mkdir -p $tmp_dir 2> /dev/null

# FUNCTIONS SECTION #######################################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function purify_inputfile {                             # recieves the input file & deletes the first line, whcih is unnecessary
                                                        # final returned value is $input
echo 'please enter the input file name'
read 'inputfile'

nl=$(wc -l < $inputfile )
((nl=nl-1))                                             # calculates numberline-1 and tail the file
cat $inputfile | tail -n $nl > $tmp_dir/inputfile
input=$tmp_dir/inputfile
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function array_them {                                   # spliting input file into an array
local i=1
for ((i=1; i<11; i++))
do
        awk "{print \$$i}" $input > $tmp_dir/column$i
        readarray array$i < $tmp_addr/column$i
done
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function find_nop {                                     # finds number of partitions defined in input based on physical addr.


((nop=$(grep -c "$PA" $input)+nop))

# for the sake of simplification, i change this concept to be the numbers of the partitions of a currently
# being processed PA in the script + number of all the previous made partitions.
# this makes it easier to handle the loop in the script.

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function format_it {
if [ ${array5[$i]} = swap ]
then
mkswap $PA${array10[$i]}                        # To make it easier we'll just swapon it right away,
swapon $PA${array10[$i]}                        # right here
else
mkfs -t ${array5[$i]} $PA
uuid=$( blkid | grep "$PA${array10[$i]}" | awk '{print $2}' | sed -e 's/UUID="//' | sed -e 's/"//')
fi
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function update_fstab {

echo "UUID=$uuid        ${array6[$i]}   ${array5[$i]}   ${array7[$i]}   ${array8[$i]}   ${array9[$i]}" >> /etc/fstab
mount -a

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function init_partitioning_gpt {

(echo g; echo n; echo ""; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA
partprobe
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function continue_partitioning_gpt {

(echo n; echo ""; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA
partprobe

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function partitioning_mbr {

(echo n; echo ${array3[$i]}; echo ""; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA
partprobe

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



# MAIN SECTION ############################################################################################

# Basically the for loop is in charge of choosing disks and while loop works the partiotions on it.

nop=0
for ((i=0; $nop < $nl; ))               # $i will always be the working row (=being processed partition)
do
        PA=${array1[$nop]}
        find_nop                        # we find the value of nop here because we want $i to go on untill
                                        # we get to the next PA -untill we are finished with the current PA
        counter=0                       # this is used for gpt. because when we use "g" in fdisk it'll delete
                                        # the already existing partitions and is only used when initializing.

        while [ $i -lt $nop ]
        do
                case ${array2[$i]} in
                        gpt)
                        if [ $counter -eq 0]
                        then
                        init_partitioning_gpt
                        format_it
                        update_fstab
                        ((counter++))
                        else
                        continue_partitioning_gpt
                        format_it
                        update_fstab
                        fi
                        ;;
                        mbr)
                        partitioning_mbr
                        format_it
                        update_fstab
                        ;;
                esac
                ((i++))
        done
done

# END #####################################################################################################

# Here's some explanation about the script:
# The loop above will deal with the input file as multiple groups of rows. It works like this: each
# group is defined based on physical addr. The "find_nop" function is in charge of that. It'll find the
# first PA, calculates how many partitions will be put into this disk, and simply spots the next PA.
# The index $i, which specifies the current, row will be incremented untill its value reaches $nop
# then it's time to work on the next PA; so $nop gets calculated and $i will try to reach its value again.

