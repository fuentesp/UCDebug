@ Changes the value of the CPSR register

.data

.text
.globl _start
_start:
	
	@ Set the bits Q, GE, A, I and F to 1
	mrs r0,CPSR
	orr r0,r0,#0x00000100 
	orr r0,r0,#0x000F0000 
	orr r0,r0,#0x000000C0 
	orr r0,r0,#0x08000000 
	msr CPSR,r0
	swi 0x11

.end

