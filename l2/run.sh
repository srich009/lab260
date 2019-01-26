#!/bin/bash

function main()
{
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
    echo

    echo "Testing: /bin/ls"; echo
    $PIN $LS
    echo
    cat mypintool.out
    echo

    echo "Testing: /bin/ps"; echo
    $PIN $PS
    echo
    cat mypintool.out
    echo

    # test example01

    echo "Testing: example01 with correct password (\"goodpass\")"; echo
    $PIN $EX1 <<< "goodpass"
    echo
    cat mypintool.out
    echo

    echo "testing example01 with incorrect password (\"abcdefg\")"; echo
    $PIN $EX1 <<< "abcdefg"
    echo
    cat mypintool.out
    echo

    echo "Testing: example01 with overflow ('a'*80)"; echo
    $PIN $EX1 <<< "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    echo
    cat mypintool.out
    echo
}

#----------------------------------------

main
