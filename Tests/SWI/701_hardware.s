@ Test to check the behavior of OS_Hardware (0x7A)

@ The program checks the results of the SWI is the expected and notifies the user if there has been an error or if it ended successfully.
@ In r0 it should return the number associated with timer1.
@ The values of r8 and r9 should be preserved after the execution of the SWI.
@ If there is an error it will notify the first register it detected an error.





.data
success_text: .asciz "Test ended successfully.\n"
error_text_r0: .asciz "Value in r0 different to expected.\n"
error_text_r8: .asciz "Value in r8 different to expected.\n"
error_text_r9: .asciz "Value in r9 different to expected.\n"

.text
.globl _start
_start:
	mov r0, #1 @ timer1
	mov r8, #0 @ Call HAL routine
	mov r9, #13 @ HAL_TimerDevice
	swi 0x7a @ OS_Hardware
	cmp r0, #3 @ Should be the 3, the device number associated with timer1
	bne error_r0
	cmp r8, #0 @ The value in r8 should be preserved
	bne error_r8
	cmp r9, #13 @ The value in r9 should be preserved
	bne error_r9
success: @ Prints a text notifying the test ended successfully
	ldr r0, =success_text
	swi 0x02
	swi 0x11
error_r0: @ Prints a text notifying the error
	ldr r0, =error_text_r0
	swi 0x02
	swi 0x11
error_r8: @ Prints a text notifying the error
	ldr r0, =error_text_r8
	swi 0x02
	swi 0x11
error_r9: @ Prints a text notifying the error
	ldr r0, =error_text_r9
	swi 0x02
	swi 0x11

.end
