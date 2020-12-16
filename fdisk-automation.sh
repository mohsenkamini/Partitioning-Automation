#!/bin/bash

# BASIC DIRECTORIES AND VARIABLES

tmp_dir=/tmp/fdisk.sh                                   # note that it does not end in a /

# FUNCTIONS SECTION

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
for ((i=1; i<10; i++))
do
        awk "{print \$$i}" $input > $tmp_dir/column$i
        readarray array$i < $tmp_addr/column$i
done
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function find_nop {                                     # finds number of partitions defined in input based on physical addr.


nop=$(grep -c "$PA" $input)

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function init_partitioning_gpt {

(echo g; echo n; echo ""; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function continue_partitioning_gpt {

(echo n; echo ""; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function partitioning_mbr {

(echo n; echo ${array3[$i]}; echo ""; echo ""; echo ${array4[$i]}; echo w) | fdisk $PA

}

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

mkdir -p $tmp_dir 2> /dev/null



nop=0
for ((i=0; i<10 && $nop <= $nl; i++ ))
do
        PA=${array1[$nop]}
        find_nop
        counter=0
        while [ $i -le $nop ]
        do
                if [ $counter -eq 0]
                then
                (echo n; echo p; echo ""; echo ""; echo +64M; echo w) | fdisk $PA
                fi
                ((i++))
        done
done








