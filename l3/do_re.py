import angr    #the main framework
import claripy #the solver engine

proj = angr.Project("re", auto_load_libs=False) # auto_load_libs False for improved performance

state = proj.factory.entry_state() # states

simgr = proj.factory.simulation_manager(state) # simulation manager

find_addr = 0x00400a8d    # mov edi, str.ConYourcapturetheflag

simgr.explore(find=find_addr)

if simgr.found:
    found = simgr.found[0].posix.dumps(0)                  # A state that reached the find condition from explore
    print(found)




