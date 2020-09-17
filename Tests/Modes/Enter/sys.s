@ Test to check the behavior of entering system mode

@ The program saves the value of SP, LR and CPSR in the var Context (in the last three words).
@ After that, it overwrites the values of register R0 through R12 with the first thirteen words of the var Context.
@ Then it uses the SWI 0x16 to enter Supervisor mode.
@ Once you are in supervisor mode check register R0-12 maintain their values, registers SP, LR and CPSR have different values that the ones stored in the var Context, and that SPSR is equal to the stored CPSR.
@ If there was an error it will notify the user with a message indicating the first register in which it detected the first error.
@ If there was no error it should end with no message at the end.

.data
.align 2
Context:	.word 0x11111110, 0x22222221, 0xF5823992, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0, 0, 0
Error_Msg:	.asciz "There has been an error on the reg: "
Success_Msg:	.asciz "Test ended successfully\n"

Error_Reg: .ascii "Rg00 Rg01 Rg02 Rg03 Rg04 Rg05 Rg06 Rg07 Rg08 Rg09 Rg10 Rg11 Rg12 RgSP RgLR CPSR"


.text
.globl _start
_start:
	@ Enter OS Mode
	swi 0x16

	@ Store in Context var current values of SP, LR, and CPSR
	ldr r0, =Context+52 @ Address of the 3 last words of Context
	stmia r0!, {sp, lr}
	mrs r1, cpsr
	str r1, [r0]
	@ Bring values from Context (regs 0 - 12) to supervisor mode registers
	ldr r0, =Context
	ldm r0, {r0-r12}



	@ Enter SYS Mode
	mrs r0,CPSR
	and r0,r0,#0x1F
	orr r0,r0,#0x17
	msr CPSR,r0 @ We must use a reg for changing mode

	@ Check the values of registers 1 - r10
	stmdb sp!, {r11-r12} @ Store the value of R11 and R12 for preservation (we need 2 free registers to check the values)
	ldr r11, =Context
	ldr r12, [r11, #4] @ Bring r1 from Context
	add r11, r11, #8 @ Advance pointer to r2
	cmp r1, r12
	movne r0, #1
	bne Error
	ldr r12, [r11], #4 @ Bring r2 from Context, and advance pointer to r3
	cmp r2, r12
	movne r0, #2
	bne Error
	ldr r12, [r11], #4 @ Bring r3 from Context, and advance pointer to r4
	cmp r3, r12
	movne r0, #3
	bne Error
	ldr r12, [r11], #4 @ Bring r4 from Context, and advance pointer to r5
	cmp r4, r12
	movne r0, #4
	bne Error
	ldr r12, [r11], #4 @ Bring r5 from Context, and advance pointer to r6
	cmp r5, r12
	movne r0, #5
	bne Error
	ldr r12, [r11], #4 @ Bring r6 from Context, and advance pointer to r7
	cmp r6, r12
	movne r0, #6
	bne Error
	ldr r12, [r11], #4 @ Bring r7 from Context, and advance pointer to r8
	cmp r7, r12
	movne r0, #7
	bne Error
	ldr r12, [r11], #4 @ Bring r8 from Context, and advance pointer to r9
	cmp r8, r12
	movne r0, #8
	bne Error
	ldr r12, [r11], #4 @ Bring r9 from Context, and advance pointer to r10
	cmp r9, r12
	movne r0, #9
	bne Error
	ldr r12, [r11], #4 @ Bring r10 from Context, and advance pointer to r11
	cmp r10, r12
	movne r0, #10
	bne Error

	@ Check the values of registers r11 - r12
	mov r0, r11
	ldr r1, [r0], #4 @ Bring r11 from Context, and advance pointer to r12
	ldmia sp!, {r11-r12} @ We recover from the stack the stored values of R11 and R12
	cmp r11, r1
	movne r0, #11
	bne Error
	ldr r1, [r0], #4 @ Bring r12 from Context, and advance pointer to sp
	cmp r12, r1
	movne r0, #12
	bne Error

	@ Check the values of sp & lr, they need to be different
	ldr r1, [r0], #4  @ Bring SP from Context, and advance pointer to LR
	cmp r1, sp
	moveq r0, #13
	beq Error
	ldr r1, [r0], #4 @ Bring LR from Context, and advance pointer to CPSR
	cmp r1, lr
	moveq r0, #14
	beq Error
	@ Check the value of CPSR
	ldr r1, [r0] @ Bring CPSR from Context
	@ Check the value of the CPSR is different to the one saved in Context
	mrs r2, cpsr
	cmp r1, r2
	moveq r0, #15
	beq Error

	@ Exit SYS Mode and enter Supervisor mode
	mrs r0,CPSR
	and r0,r0,#0x1F
	orr r0,r0,#0x13
	msr CPSR,r0

	@ Bring value of R0 from Context
	ldr r0, =Context
	ldr r0, [r0]

	@ Re-enter SYS Mode for checking r0
	mrs r1,CPSR
	and r1,r1,#0x1F
	orr r1,r1,#0x17
	msr CPSR,r1

	ldr r1, =Context
	ldr r1, [r1] @ Bring r0 from Context
	cmp r0, r1
	movne r0, #0
	bne Error

	bne Error
NoError:
	@Print the success message
	ldr r0, =Success_Msg
	swi 0x2 @OS_Write0
	swi 0x11

@Print the error and exit the program
Error:
	mov r1, #5
	mul r4, r0, r1
	ldr r1, =Error_Reg @ Load the string with the names of the registers
	add r4, r4, r1 @ Get the position of the reg name
	@ Print the error message
	ldr r0, =Error_Msg
	swi 0x2 @OS_Write0
	@ Print the name of the register that failed the check
	ldrb r0, [r4]
	swi 0x00 @OS_WriteC
	add r4, r4, #1
	ldrb r0, [r4]
	swi 0x00
	add r4, r4, #1
	ldrb r0, [r4]
	swi 0x00
	add r4, r4, #1
	ldrb r0, [r4]
	swi 0x00
	swi 0x11
