@ Test to check the behavior of OS_ClaimDeviceVector (0x4B) and OS_ReleaseDeviceVector (0x4C)

@ The program uses the system timer to check the correct functionality of the SWI calls.
@ It claims a device vector for the interrupts of the timer. Then it programs the timer to generate an interrupt.
@ The program idles in a loop until the interrupt is generated. 


.data
Check: .word 0
Device: .word 0
successful_text: .asciz "Interrupt detected"

.equ STBASE, 0x20003000
.equ STCS,0x00
.equ STCL0,0X04
.equ STC3,0X18

.equ INTBASE, 0x2000b000
.equ INTENIRQ1, 0x210

.equ WAIT_TIME, 0x1000 @ Configuration of the timer wait time


.text
.global _start


handler:
	stmdb sp!,{r4-r12,r14}
	mrs r10,cpsr
    @ Enter supervisor mode
	orr r0,r10,#3
	msr cpsr_c, r0

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
	mov r7,r0 @ Copy of the timer ID in R7

    @ Claim the Device vector
	ldr r1,=handler
	mov r2,#0
	mov r3,#0
	mov r4,#0
	swi 0x4B @ OS_ClaimDeviceVector



    @ Maps the timer to memory
	mov r0, #13
	ldr r1, =STBASE
	mov r2, #0x100
	swi 0x68 @ OS_Memory
    @ Store the address of the timer
	ldr r0,=Device
	str r3,[r0]
	@ If there is a pending interrupt acknowledge it
	mov r1, #0x08
	ldr r1, [r0,#STCS]
	ands r1, r1, #0x08
	movne r1, #0x08
	strne r1, [r0,#STCS]


    @ Enables interrupts
	swi 0x13 @ OS_IntOn
	mov r8,#0 @ HAL
	mov r9,#1 @ HAL_IRQEnable
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

	@ Prints a text for confirmation
	ldr r0, =successful_text
	swi 0x02

	mov r8, #0
	swi 0x11

.end
