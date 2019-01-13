#!/bin/bash

# DISABLE ASLR
# echo 0 > /proc/sys/kernel/randomize_va_space

# ENABLE ASLR
# echo 2 > /proc/sys/kernel/randomize_va_space

gcc -g -fno-stack-protector -m32 -z execstack -o example01 example01.c

