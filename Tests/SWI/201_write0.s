@ Test to check the behavior of OS_Write0 (0x02)
@ We load the address of the first string and call the SWI. This should update the address,
@ which now should point to the second string. We call the SWI again to check that this has happened.

.data

String1: .asciz "Test "
String2: .asciz "Text "
String3: .asciz "1@* +;[_Ftñáçº"

.text
.globl _start
_start:
    ldr r0, =String1
    swi 0x02
    swi 0x02
    swi 0x02
    swi 0x11
