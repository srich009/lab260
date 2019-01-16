#!/bin/bash

# need the to have certain dependencies installed or compiler error
# /usr/include/features.h:367:25: fatal error: sys/cdefs.h: No such file or directory
# sudo apt install libc6-dev-i386

# need to be root user to change ASLR
# sudo su

# DISABLE ASLR
# echo 0 > /proc/sys/kernel/randomize_va_space

# ENABLE ASLR
# echo 2 > /proc/sys/kernel/randomize_va_space

gcc -g -fno-stack-protector -m32 -z execstack -o example01 example01.c

