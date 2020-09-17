.data

.text
.globl _start
_start:
	@ Enter OS Mode
	swi 0x16
	@ End the program in Supervisor mode
	swi 0x11
	