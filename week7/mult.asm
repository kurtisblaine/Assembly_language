section .text    
	global _start         
_start:

mov edx, 0x9C9C9C9C
mov eax, 111
mov ebx, 9
mul ebx
mov dword [somewhere], 99
mov eax, 1001001
mul dword [somewhere]
mov [elsewhere], eax
mov eax, 0xABCDEF99
mov ecx, 0x10
mov edx, 0x01020304
mul ecx

mov ah, 10110011b
mov al, 0x0f
mov bl, 0xff
imul bl

mov ah, 10110011b
mov al,0x7f
mov bl, 0xff
mul bl

_exit:
mov ebx, 0
mov eax, 1
int 0x80


section .bss

somewhere resb 4
elsewhere resd 1


