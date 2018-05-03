section .text 
    global _sumAndPrintList
    global _start
    extern printf 
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;function;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  
_sumAndPrintList:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;cdecl convensions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;save the stack frame pointer of the caller
	push ebp
;make the current top of stack the fram pointer of this function call (the callee)
;reference point for the parameters and local variables that were passed to funciton
	mov ebp, esp
;esi holds first parameter (pointer)
	xor esi, esi
	mov esi, [ebp + 8]
;eax holds second parameter (length)
	xor eax, eax
	mov al, [ebp + 12]
	sub eax, 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;cdecl convensions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;save parameters	
	push eax
	push esi

;print the table
	push tableString

;call printf
	call printf
	
;add to the stack pointer
	add esp, 4
	
;get the parameters back
	pop esi 
	pop eax

;counter
	xor edi, edi
	mov byte[total], 0x00000000
	
	_loop:
; move parameters 
		mov [par], eax
		mov [par2], esi
		mov [counter], edi
	
;print the number
		xor edx, edx
		mov edx, [esi+edi*4]
		push edx
		push spaces
		call printf
		add esp, 8
		
;mov parameters into registers
		xor eax, eax
		xor esi, esi
		xor edi, edi
		xor edx, edx
		mov eax, [par]
		mov esi, [par2]
		mov edi, [counter]
	
;print the running total
		mov al, [esi+edi*4]
		mov dl, byte[total]
		add edx, eax
		mov [total], edx
		
		xor eax, eax
		mov eax, [par]
		
;push before printf funciton call
		push eax
		push esi
		push edi
		
;print the spaces, result, and newline to table
	
		push edx
		push spaces
		call printf
		add esp, 8
	
		push newLine
		call printf
		add esp, 4
	
;get them back
		xor eax, eax
		xor esi, esi
		xor edi, edi
		pop edi
		pop esi	
		pop eax

;compares for loop termination
		cmp edi, eax
		je _end
		inc edi
		jmp _loop
	
_end:
	
;move the result in eax
		xor eax, eax
		mov eax, [total]
	
;restore the caller's stack frame pointer
		pop ebp
	
;pop the return address off the stack and into the IP (instruction resumes where the caller left off)
		ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;function;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

section .data

	tableString db "Numbers                    Running Total", NEWLINE, 0 ;20 spaces
	tableStringLen equ $-tableString
	spaces      db        "    %d                    ", 0
	spaceslen equ $-spaces 
	newLine     db  NEWLINE, 0
	 
section .bss

	total resb 4
	par resb 4
	par2 resb 4
	counter resb 4

;;;;;;;;;;;;;; Constants ;;;;;;;;;;;;;;;;;;;;;;
sys_read  equ 0x03
sys_write equ 0x04
stdin     equ 0x00
stdout    equ 0x01
stderr    equ 0x02
BUFFERSIZE equ 100
SPACE     equ 0x20  
NEWLINE   equ 0x0A






