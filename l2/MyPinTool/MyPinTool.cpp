#include "pin.H"
#include <stdio.h>
#include <cstdlib>
#include <stack>

// GLOBALS
FILE * trace;
std::stack<VOID*> shadow_stack;

// This function is called before every call instruction is executed and prints the IP
VOID shadow_call(VOID *ip)
{
    //fprintf(trace, "CALL: %p\n", ip);
    shadow_stack.push(ip);
}

// This function is called before every ret instruction is executed and prints the IP
VOID shadow_ret(VOID *ip)
{
    //fprintf(trace, "RET: %p\n", ip);
    if( ip == shadow_stack.top() )
    {
        shadow_stack.pop();
    }
    else
    {
        fprintf(trace, "Error: the return addresses differ, an overflow has been detected.\n");
        fprintf(trace, "Incorrect Addr: %p\tExpected Addr: %p\n", ip, shadow_stack.top() );
        fprintf(trace, "Terminating Program.\n");
        fclose(trace);
        exit(-1);
    }
}

// Pin calls this function every time a new instruction is encountered
VOID Instruction(INS ins, VOID *v)
{
    if( INS_IsCall(ins) )// Insert a call to shadow_call before every call instruction, and pass it the return IP
    {
        INS_InsertCall(ins, IPOINT_TAKEN_BRANCH, (AFUNPTR)shadow_call, IARG_RETURN_IP, IARG_END);
    }
    else if( INS_IsRet(ins) ) // Insert a call to shadow_ret before every ret instruction, and pass it the IP
    {
        INS_InsertCall(ins, IPOINT_BEFORE, (AFUNPTR)shadow_ret, IARG_BRANCH_TARGET_ADDR, IARG_END);
    }
}

// This function is called when the application exits
VOID Fini(INT32 code, VOID *v)
{
    fprintf(trace, "Program ran successfully, no overflows detected\n");
    fclose(trace);
}

/* ===================================================================== */

int main(int argc, char * argv[])
{
    trace = fopen("mypintool.out", "w");

    // Initialize pin
    if (PIN_Init(argc, argv))
    {
        // Help message
        PIN_ERROR("This Pintool prints the IPs\n"
                  + KNOB_BASE::StringKnobSummary() + "\n");
        return -1;
    }

    // Register Instruction to be called to instrument instructions
    INS_AddInstrumentFunction(Instruction, 0);

    // Register Fini to be called when the application exits
    PIN_AddFiniFunction(Fini, 0);

    // Start the program, never returns
    PIN_StartProgram();

    return 0;
}
