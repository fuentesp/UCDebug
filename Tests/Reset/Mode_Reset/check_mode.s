.data

Error_Msg:	.asciz "The program didn't start in user mode\n"
Success_Msg:	.asciz "Test ended successfully\n"

.text
.globl _start
_start:
	mrs r0, cpsr
	and r0, r0, #0x1f
	cmp r0, #0x10
	beq no_error
error:
	mov r1, r0
	ldr r0, =Error_Msg
	swi 0x2 @OS_Write0
no_error:
	@Print the success message
	ldr r0, =Success_Msg
	swi 0x2 @OS_Write0
	swi 0x11
