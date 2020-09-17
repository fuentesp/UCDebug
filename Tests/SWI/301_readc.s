@ Test to check the behavior of OS_ReadC (0x04)
@ This test requires the user input to fully check the functionality of this SWI.

.data

Instruction_message: .asciz "Insert the following characters:\n1@* +;[_Ftñáçº\n"
.equ Num_chars, 14

.text
.globl _start
_start:
    mov r4, #0
	ldr r0, =Instruction_message
	swi 0x2 @ Print the instruction message 
loop:
    swi 0x4 @ Read the character
    swi 0x0 @ Print the character
    add r4, r4, #1
    cmp r4, #Num_chars
    bne loop
    swi 0x11

.end
