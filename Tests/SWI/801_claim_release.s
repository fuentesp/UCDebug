@ Test to check the behavior of OS_ClaimDeviceVector (0x4B) and OS_ReleaseDeviceVector (0x4C)

@ The program uses the system timer to check the correct functionality of the SWI calls.
@ It claims a device vector for the interrupts of the timer. Then it programs the timer to generate an interrupt.
@ The program idles in a loop until the interrupt is generated. Finally it releases the device vector and exits.


.data
Check: .word 0
Device: .word 0
success_text: .asciz "Interrupt detected"
error_claim_text: .asciz "Register in claim not preserved"
error_release_text: .asciz "Register in release not preserved"

.equ STBASE, 0x20003000
.equ STCS,0x00
.equ STCL0,0X04
.equ STC3,0X18
.equ timer_int_bit, 0x08

.equ WAIT_TIME, 0xD0000 @ Configuration of the timer wait time


.text
.global _start


handler:
	stmdb sp!,{r4-r12,r14}
	mrs r10,cpsr

	@ Acknoledge interrupt
	ldr r0,=Device
	ldr r0, [r0,#STCS]
	mov r9, #timer_int_bit
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
	mov r7,r0 @ Copy of the timer ID in R7

    @ Claim the Device vector
	ldr r1,=handler
	mov r2,#0
	mov r3,#0
	mov r4,#0
	swi 0x4B @ OS_ClaimDeviceVector

	@ Check registers r0-r4 are preserved
	cmp r7, r0
	bne error_claim
	ldr r5, =handler
	cmp r5, r1
	bne error_claim
	cmp r2, #0
	bne error_claim
	cmp r3, #0
	bne error_claim
	cmp r4, #0
	bne error_claim



    @ Maps the timer to memory
	mov r0, #13
	ldr r1, =STBASE
	mov r2, #0x100
	swi 0x68 @ OS_Memory
    @ Store the address of the timer
	ldr r0,=Device
	str r3,[r0]
	@ If there is a pending interrupt acknowledge it
	ldr r1, [r0,#STCS]
	ands r1, r1, #timer_int_bit
	strne r1, [r0,#STCS]


    @ Enables interrupts
	swi 0x13 @ OS_IntOn
	mov r8, #0 @ HAL
	mov r9, #1 @ HAL_IRQEnable
	mov r0, #0x3 @ irq of timer
	swi 0x7a @ OS_Hardware

    @ Timer counter initialization
	ldr r0,=Device
	ldr r0,[r0]
	swi 0x16 @EnterOS
	ldr r1, [r0,#STCL0]
	add r1, #WAIT_TIME
	str r1, [r0, #STC3]
 	swi 0x7c @ OS_LeaveOS


    @ Wait for the interrupt
	ldr r0,=Check
loop:
	@ Check if the value of the var has changed
	ldr r1,[r0]
	cmp r1,#1
	blt loop

    @ Disable interrupts
	mov r8,#0
	mov r9,#2
	mov r0,#0x3
	swi 0x7A @ OS_Hardware

    @ Release of the Device vector
	mov r0,r7 @ Recovery of the timer ID
	ldr r1,=handler
	mov r2,#0
	mov r3, #0
	mov r4, #0
	swi 0x4C @ OS_ReleaseDeviceVector

	@ Check registers r0-r4 are preserved
	cmp r7, r0
	bne error_release
	ldr r5, =handler
	cmp r5, r1
	bne error_release
	cmp r2, #0
	bne error_release
	cmp r3, #0
	bne error_release
	cmp r4, #0
	bne error_release

	@ Prints a text for confirmation
	ldr r0, =success_text
	swi 0x02

	mov r8, #0
	swi 0x11

error_claim:
	ldr r0, =error_claim_text
	swi 0x02
	swi 0x11

error_release:
	ldr r0, =error_release_text
	swi 0x02
	swi 0x11

.end
