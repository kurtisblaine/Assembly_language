
section .text

	global _start
	
_start:

	mov edx, msgLen
	
	mov ecx, msg
	mov ebx, 1
	mov eax, 4

	int 0x80

	mov ebx, 0
	mov eax, 1
	int 0x80

section .data

	msg   db    87,104,"at's up, Doc?",0x0A

	msgLen equ  $ - msg
