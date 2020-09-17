This directory contains the programs to test if the mode is reset to user mode after ending a program in a different mode.
For testing all the modes you must run 1 of the programs that changes the mode (abt, fiq, irq, svc, sys or und) and then immediately (without closing the debugger or loading another program) run the program check_mode.
Any of the first programs only changes mode and ends.
The second program checks a new program starts in user mode.
If the mode didn't reset the second program will print an error message.