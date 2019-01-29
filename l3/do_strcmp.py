#!/usr/bin/env python3

import angr    #the main framework

import os
from subprocess import Popen, PIPE

proj = angr.Project("afl_strcmp", auto_load_libs=False) # auto_load_libs False for improved performance

state = proj.factory.entry_state() # states

simgr = proj.factory.simulation_manager(state) # simulation manager

find_addr = 0x004007f9 #  mov edi, str.You_got_the_crash

simgr.explore(find=find_addr)

if simgr.found:
    found = simgr.found[0].posix.dumps(0) # A state that reached the find condition from explore
    print(found.decode())
    p = Popen('./afl_strcmp', stdin=PIPE) # start the exe
    p.stdin.write(found)                  # cause the crash by giving the flag
