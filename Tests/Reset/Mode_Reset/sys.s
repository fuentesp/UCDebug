.data

.text
.globl _start
_start:
	@ Enter OS Mode
	swi 0x16

	@ Enter SYS Mode
	mrs r0,CPSR 
	bic r0,r0,#0x1F 
	orr r0,r0,#0x1F
	msr CPSR,r0 

	@ End the program in Supervisor mode
	swi 0x11
	