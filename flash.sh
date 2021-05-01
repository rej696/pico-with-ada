#!/bin/bash

if [ $# -eq 0 ]
then
    echo "Need project to flash. Run command ./flash.sh <name-of-project>";
    exit 0;
fi

if [ -d projects/$1 ];
then
    cd build;
    elf2uf2 ../projects/$1/obj/main ./$1.uf2;
    cp $1.uf2 /media/rowan/RPI-RP2/;
    cd ..;
else
    echo "$1 is not a valid project directory";
    exit 0;
fi

