@ Test to check the behavior of OS_ConvertInteger4 (0xDC)

@ The program checks the results of the SWI is the expected and notifies the user if there has been an error or if it ended successfully.
@ In r0 it should return the address it received in r1.
@ In r1 it should return the next byte stored next to the string the SWI created.
@ In r2 it should return the number of bytes written by the SWI.
@ If there is an error it will notify the first register it detected an error.




.data

Result: .space 8
success_text: .asciz "Test ended successfully.\n"
error_text_r0: .asciz "Value in r0 different to expected.\n"
error_text_r1: .asciz "Value in r1 different to expected.\n"
error_text_r2: .asciz "Value in r2 different to expected.\n"

.text
.globl _start
_start:
	mov r0, #15
	ldr r1, =Result
	mov r2, #8
	swi 0xDC @ OS_ConvertInteger4
	ldr r3, =Result
	cmp r0, r3
	bne error_r0 @ r0 should be the address passed to the SWI in r1
	add r3, r3, #2
	cmp r1, r3
	bne error_r1 @ r1 should be the pointer to the next byte after the saved string
	cmp r2, #6
	bne error_r2 @ r2 should be the number of bytes not used
success: @ Prints a text notifying the test ended successfully
	ldr r0, =success_text
	swi 0x02
	swi 0x11
error_r0: @ Prints a text notifying the error
	ldr r0, =error_text_r0
	swi 0x02
	swi 0x11
error_r1: @ Prints a text notifying the error
	ldr r0, =error_text_r1
	swi 0x02
	swi 0x11
error_r2: @ Prints a text notifying the error
	ldr r0, =error_text_r2
	swi 0x02
	swi 0x11

.end
