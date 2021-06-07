@ Test to check the handling of CPSR variations during the execution of a non-captured SWI such as OS_Byte 145 (0x6), which reads a char from the keyboard in a non-blocking fashion.
@ If the behavior is properly captured, it should display the key pressed.
@ In case of error, execution should end after ~3 seconds without showing which key was pressed.




.data
MSG: .asciz "Pulsa una tecla:"
MSG2: .asciz "Has pulsado la tecla "

.text
.globl _start
_start:
        ldr r0,=MSG
        swi 2
        ldr r4, =10000 @ Consume time in a loop
        mov r2, #0
loop:   @ Print the key that is pressed
	subs r4, r4, #1
	beq end
	mov r0, #145
	mov r1, #0
	swi 0x6
	bcs loop
	mov r4, r2
	ldr r0, =MSG2
	swi 0x2
	mov r0, r4
	swi 0x0
end:
	swi 0x11

.end

