@ Test to check the behavior of OS_ExitOS (0x11). Checks the case of the program ending by calling the SWI 0x11.
@ The return code should be 0 when the program ends.

.data

.text
.globl _start
_start:
    swi 0x11

.end
