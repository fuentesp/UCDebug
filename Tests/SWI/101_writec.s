@ Test to check the behavior of OS_WriteC (0x00)
@ This test prints all the characters of the variable "Chars".

.data

@ Characters: 1@* +;[_Ftñáçº
Chars: .byte 0x31, 0x40, 0x2a, 0x20, 0x2b, 0x3b, 0x5b, 0x5f, 0x46, 0x74, 0xf1, 0xe1, 0xe7, 0xba

.equ Num_chars, 13


.text
.globl _start
_start:
    ldr r5, =Chars
    mov r4, #0
@ This loop prints all the characters of the var Chars.
loop:
    ldrb r0, [r5] @ Read the character
    swi 0x00
    add r5, r5, #1 @ Advance the pointer to the next character
    add r4, r4, #1
    cmp r4, #Num_chars
    bne loop
end:
    swi 0x11

.end
