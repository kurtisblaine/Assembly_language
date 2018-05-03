; sections define distinct regions of memory for your executable program
; .text "read only" used for the actual instructions of the program

section .text


; "global" will make symbols in AP visible to the linker

	global _start
	
;two steps for an AP --Assembly and Linking-- "start" beginning of program to start and become visible to the linker
; syntax of "something:" creates a symbol "something", that symbol of the next byte of memory that the program will use.. Instructions, data, etc.

_start:

;mov = "move" 
; _start symbol represents that represents a dynammically allocated space designed in memory (kinda like a constant pointer) 
;address of first byte of this instruction

	mov edx, msgLen
	
	mov ecx, msg
	mov ebx, 1
	mov eax, 4
	
;move instructions copy data to or from memory or registers
;eax, ebx, and so forth are registers

	int 0x80
	
; int stands for interrupt and will cause the computer to jump execution to a system call
; in this case it is going to do a "sys_write"

	mov ebx, 0
	mov eax, 1
	int 0x80

;another system call to sys_exit to end the program clearly

;section for data...

section .data

;defines another symbol which is an address, which will point to the first byte of data specified after "db"

	msg   db    87,104,"at's up, Doc?",0x0A

;0x0A ASCII for line feed (new line)
;bytes of data are the ASCII codes of the character in the text string

	msgLen equ  $ - msg
	
;"$" represents current byte-position or address in what will ultimately be the binary executable 
;- is just subtraction and msg is already defined as the first byte of the What's up Doc text data






