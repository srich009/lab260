#!/bin/bash

function main()
{
    set -e
    buildtool
    testtool
}

#----------------------------------------

function buildtool
{
    if ! [ -f example01 ] ; then
        gcc -g -fno-stack-protector -z execstack -o example01 example01.c
    fi

    cd MyPinTool
    make PIN_ROOT=../pintool obj-intel64/MyPinTool.so > /dev/null
    cd ..
}

function testtool()
{
    PIN="pintool/pin -t MyPinTool/obj-intel64/MyPinTool.so -- "
    EX1="./example01"
    LS="/bin/ls"
    PS="/bin/ps"

    # test bin commands
    echo "testing ls"
    $PIN $LS
    echo

    echo "testing ps"
    $PIN $PS
    echo

    # test example01
    echo "testing example01"
    $PIN $EX1
    echo
}

#----------------------------------------

main
