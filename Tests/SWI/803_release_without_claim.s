@ Test to check the behavior of OS_ClaimDeviceVector (0x4B) and OS_ReleaseDeviceVector (0x4C)

@ The program uses the system timer to check the correct functionality of the SWI calls.
@ It doesn't claim any device vector. Then it programs the timer to generate an interrupt.
@ The program idles in a loop until the interrupt is generated. Finally it releases the device vector and exits.
@ No interrupt should happen, and the program should stay in the infinite loop


.data
Check: .word 0
Device: .word 0
success_text: .asciz "Test NOT passed: unclaimed device has been released"

.equ STBASE, 0x20003000
.equ STCS,0x00

.equ INTBASE, 0x2000b000
.equ INTENIRQ1, 0x210

.equ WAIT_TIME, 0x500000 @ Configuration of the timer wait time


.text
.global _start


handler:
	stmdb sp!,{r4-r12,r14}
	mrs r10,cpsr

	@ Acknoledge interrupt
	ldr r0,=Device
	ldr r0,[r0]
	mov r9, #0x08
	str r9, [r0,#STCS]

	@ Increase Check by 1
	ldr r2,=Check
	ldr r1,[r2]
	add r1,r1,#1
	str r1,[r2]

    @ Restore mode
	msr cpsr_c,r10
	ldmia sp!,{r4-r12,pc} @ Load the LR register in the PC to return



_start:

    @ Obtain the ID of the timer in R0
	mov r0,#1 @ timer1
	mov r8,#0
	mov r9,#13 @HAL_TimerDevice
	swi 0x7a @ OS_Hardware


    @ Release of the Device vector
	ldr r1,=handler
	mov r2,#0
	mov r3, #0
	mov r4, #0
	swi 0x4C @ OS_ReleaseDeviceVector

	@ Prints a text for confirmation
	ldr r0, =success_text
	swi 0x02

	mov r8, #0
	swi 0x11

.end
