#!/bin/bash

# INPUT FILE SECTION
## input file contains the info about partiotions

echo 'please enter the input file name'
read 'inputfile'

nl=$(wc -l < $inputfile )
((nl=nl-1))                                     # so that it doesn't read the first line

mkdir -p /tmp/fdisk.sh/ 2> /dev/null
cat $inputfile | tail -n $nl > /tmp/fdisk.sh/inputfile
input=/tmp/fdisk.sh/inputfile

##
