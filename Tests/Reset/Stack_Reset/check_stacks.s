@ Checks Stack Pointers from modes supervisor, abort, undefined, interrupt and fast interrupt
@ reset their value after loading a new program.
@ This program should be executed after another program which ends with the stack values of all modes changed. 

.data

Error_Msg1:	.asciz "Error: "
Error_Msg2: .asciz " stack pointer didn't reset\n"
Error_Msg3: .asciz "Error: AuxFile not found. Have you previously run \"modify_stacks\"?"
Success_Msg:	.asciz "Test ended successfully\n"
List_modes: .asciz "svc abt und irq fiq"
AuxFileName: .asciz "AuxFile/txt"
.align 2
@ This list contains the default values of the stack pointers of all modes
@                       svc      abt      und      irq      fiq
Stack_def_values: .space 21



.text
.globl _start
_start:
	@ Check if auxiliary file exists
	mov r0, #5
	ldr r1, =AuxFileName
	swi 0x8 @ OS_File 5 (read info)
	cmp r0, #0
	beq aux_file_error

open_existing_file:
	mov r0, #0x40 @ Open existing file in RO mode
	orr r0, r0, #8 @ Return error if non-existent file, and use current filepath
	ldr r1, =AuxFileName
	swi 0x0D @ OS_Find
	b load_stack_addr
	@ Here could be checked if file correctly created

load_stack_addr:
	mov r1, r0 @ Save copy of file handler
	mov r0, #3
	ldr r2, =Stack_def_values
	mov r3, #21 @Space for 5 words and a NULL char
	mov r4, #0  @ Read from beginning of file
	swi  0x0C @ OS_GBPB 3

	mov r0, #0 @ Close file
	swi 0x0D @ OS_Find

	@ Remove auxiliary file
	mov r0, #6 @ Delete file
	ldr r1, =AuxFileName
	swi 0x8 @ OS_File 6

	@ Check supervisor SP
	swi 0x16 @ Enter OS Mode

	ldr r2, =Stack_def_values
	ldr r1, [r2], #4 @ Load the default value of supervisor SP and increase the pointer to abt SP default value
	cmp sp, r1
	movne r4, #0
	bne error

	@ Check abort SP
	@ Enter ABT Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x17
	msr CPSR,r0

	ldr r1, [r2], #4 @ Load the default value of abort SP and increase the pointer to und SP default value
	cmp sp, r1
	movne r4, #1
	bne error

	@ Check undefined SP
	@ Enter UND Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x1B
	msr CPSR,r0

	ldr r1, [r2], #4 @ Load the default value of undefined SP and increase the pointer to irq SP default value
	cmp sp, r1
	movne r4, #2
	bne error

	@ Check interrupt SP
	@ Enter IRQ Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x12
	msr CPSR,r0

	ldr r1, [r2], #4 @ Load the default value of interrupt SP and increase the pointer to fiq SP default value
	cmp sp, r1
	movne r4, #3
	bne error

	@ Check fast interrupt SP
	@ Enter FIQ Mode
	mrs r0,CPSR
	bic r0,r0,#0x1F
	orr r0,r0,#0x11
	msr CPSR,r0

	ldr r1, [r2] @ Load the default value of fast interrupt SP
	cmp sp, r1
	movne r4, #4
	bne error
no_error:
	@Print the success message
	ldr r0, =Success_Msg
	swi 0x2 @OS_Write0
	swi 0x11

@Print the error and exit the program
error:
	mov r1, #4
	mul r2, r4, r1
	ldr r1, =List_modes @ Load the string with the names of the mode
	add r4, r2, r1 @ Get the position of the reg name
	@ Print the first part of the error message
	ldr r0, =Error_Msg1
	swi 0x2 @OS_Write0
	@ Print the name of the mode that failed the check
	ldrb r0, [r4]
	swi 0x00 @OS_WriteC
	add r4, r4, #1
	ldrb r0, [r4]
	swi 0x00
	add r4, r4, #1
	ldrb r0, [r4]
	swi 0x00
	@ Print the second part of the error message
	ldr r0, =Error_Msg2
	swi 0x2 @OS_Write0
	swi 0x11

aux_file_error:
	ldr r0, =Error_Msg3
	swi 0x2
	swi 0x11
