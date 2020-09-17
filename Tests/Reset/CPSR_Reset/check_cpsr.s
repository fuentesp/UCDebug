@ Checks the CPSR has its default value when running a new program.
@ This program should be run after other program which changes some of the flags
@ which this program checks.

.data
Default_CPSR: .word 0x80000110 @ Default value of the CPSR (only care about flags Q, GE, A, I and F)
Error_Msg:	.asciz "There has been an error on the flag: "
Error_Flag: .ascii "FIAGQ"
Success_Msg: .asciz "Test ended succesfully\n"

.text
.globl _start
_start:
	mrs r0,CPSR @ Get value of start CPSR in r0
	ldr r1, =Default_CPSR 
	ldr r1, [r1]
	and r1, r1, r0
	@ Check bit F
	lsr r1, r1, #6
	and r0, r1, #0x1
	mov r4, #0
	cmp r0, #1
	beq error
	@ Check bit I
	lsr r1, r1, #1
	and r0, r1, #0x1
	mov r4, #1
	cmp r0, #1
	beq error
	@ Check bit A
	lsr r1, r1, #1
	and r0, r1, #0x1
	mov r4, #2
	cmp r0, #0
	beq error
	@ Check bit GE[0]
	lsr r1, r1, #8
	and r0, r1, #0x1
	mov r4, #3
	cmp r0, #1
	beq error
	@ Check bit GE[1]
	lsr r1, r1, #1
	and r0, r1, #0x1
	mov r4, #3
	cmp r0, #1
	beq error
	@ Check bit GE[2]
	lsr r1, r1, #1
	and r0, r1, #0x1
	mov r4, #3
	cmp r0, #1
	beq error
	@ Check bit GE[3]
	lsr r1, r1, #1
	and r0, r1, #0x1
	mov r4, #3
	cmp r0, #1
	beq error
	@ Check bit Q
	lsr r1, r1, #8
	and r0, r1, #0x1
	mov r4, #4
	cmp r0, #1
	beq error
Success:
	@ Print the success message
	ldr r0, =Success_Msg
	swi 0x2 @OS_Write0
	swi 0x11

error:
	@ Print the error message
	ldr r0, =Error_Msg
	swi 0x02
	@ Print the name of the flag that failed the check
	ldr r0, =Error_Flag
	add r0, r0, r4
	ldrb r0, [r0]
	swi 0x00
	swi 0x11

.end
