@ This program modifies the stack of supervisor mode, abort mode, undefined mode,
@ interrupt mode and fast interrupt mode, and ends without returning them to their
@ initial state.
@ Another program should check after this program execution that all stacks have reset their values.

.data
AuxFileName: .asciz "AuxFile/txt"
.align 2
Stack_def_values: .space 21

.text
.globl _start
_start:
	@ Open buffer to later store original SP values
	ldr r4, =Stack_def_values

	@ Enter OS Mode
	swi 0x16
	str sp, [r4], #4 @ Save stack pointer in buffer

	@ Modify the stack saving the regs 0 - 12
	stmdb sp!, {r0-r12}

	@ Enter ABT Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x17
	msr CPSR,r0
	str sp, [r4], #4 @ Save stack pointer in buffer

	@ Modify the stack saving the regs 0 - 12
	stmdb sp!, {r0-r12}

	@ Enter UND Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x1B
	msr CPSR,r0
	str sp, [r4], #4 @ Save stack pointer in buffer

	@ Modify the stack saving the regs 0 - 12
	stmdb sp!, {r0-r12}

	@ Enter IRQ Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x12
	msr CPSR,r0
	str sp, [r4], #4 @ Save stack pointer in buffer

	@ Modify the stack saving the regs 0 - 12
	stmdb sp!, {r0-r12}

    @ Enter FIQ Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x11
	msr CPSR,r0
	str sp, [r4], #4 @ Save stack pointer in buffer
	mov r2, #0
	strb r2, [r4]

	@ Modify the stack saving the regs 0 - 12
	stmdb sp!, {r0-r12}

	@ Check if auxiliary file exists and, if not, create it
	mov r0, #5
	ldr r1, =AuxFileName
	swi 0x8 @ OS_File 5 (read info)
	cmp r0, #0
	beq open_new_file

open_existing_file:
	mov r0, #0xC0 @ Open existing file in R/W mode
	orr r0, r0, #8 @ Return error if non-existent file, and use current filepath
	ldr r1, =AuxFileName
	swi 0x0D @ OS_Find
	b store_stack_addr
	@ Here could be checked if file correctly created

open_new_file:
	mov r0, #0x80 @ Open new file in R/W mode
	orr r0, r0, #8 @ Return error if non-existent file, and use current filepath
	ldr r1, =AuxFileName
	swi 0x0D @ OS_Find
	@ Here could be checked if file correctly created

store_stack_addr:
	mov r1, r0 @ Save copy of file handler
	mov r0, #2
	ldr r2, =Stack_def_values
	mov r3, #21 @Space for 5 words and a NULL char
	swi  0x0C @ OS_GBPB 2

	mov r0, #0 @ Close file
	swi 0x0D @ OS_Find

	swi 0x11
