#!/bin/bash
# FUNCTIONS SECTION #######################################################################################

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function purify_inputfile {                             # recieves the input file & deletes the first line, whcih is unnecessary
                                                        # final returned value is $input
echo '==================================================================================================
'
echo -n 'Please enter the input file name :   '
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
        awk "{print \$$i}" $input | sed -e 's/^[ \t]*//' | sed '/^$/d' |  sed -e 's/[ \t]*$//' > $tmp_dir/column$i
        # sed statements will delete all the whitespaces (leading/trailing/empty lines)
        readarray -t array$i < $tmp_dir/column$i
done
}
# here's what each array represents :
# array1 : PA           array2 : disk label type        array3 : P/E/L          array4 : size         array5 : fstype
# array6 : mountpoint   array7 : options in fstab       array8 : dump backup    array9 : fscheck      array10: part.no. 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function find_nop {                                     # finds number of partitions defined in input based on physical addr.

nup=$(grep -c "$PA" $input)
((nop=nop+nup))

# for the sake of simplification, i change this concept to be the numbers of the partitions of a currently
# being processed PA in the script + number of all the previous made partitions.
# this makes it easier to handle the loop in the script.

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function init_partitioning_gpt {

(echo g; echo n; echo ${array10[$i]}; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA
wait
partprobe
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function continue_partitioning_gpt {

(echo n; echo ${array10[$i]}; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA
wait
partprobe

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function partitioning_mbr {

(echo n; echo ${array3[$i]}; echo ${array10[$i]}; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA
wait
partprobe

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function format_it {
if [ ${array5[$i]} = swap ]
then
        mkswap $PA${array10[$i]}                        # To make it easier we'll just swapon it right away,
        swapon $PA${array10[$i]}                        # right here
else
        mkfs -t ${array5[$i]} $PA${array10[$i]}
fi
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function mkdir_mnt {

mkdir -p ${array6[$i]} 2> /dev/null

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function update_fstab {

if [ ${array3[$i]} != e ]
then
        uuid=$( blkid | grep -w "$PA${array10[$i]}" | awk '{print $2}' | sed -e 's/UUID="//' | sed -e 's/"//')
        echo "UUID=$uuid ${array6[$i]} ${array5[$i]} ${array7[$i]} ${array8[$i]} ${array9[$i]}" >> /etc/fstab
        mount -a
fi
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function report {

echo "########################################## FINAL REPORT ##########################################
"
echo "=========================================== MADE PARTITIONS ======================================
"
lsblk
echo "========================================== MOUNTED PARTITIONS ====================================
"
df -h
echo "=========================================== SWAP PARTITIONS ======================================
"
cat /proc/swaps

echo "##################################################################################################
"
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
