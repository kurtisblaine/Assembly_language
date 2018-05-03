;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Kurtis B Waldner

;MAKEFILE

;object:Lab0x03-DecimalCalc.asm
;	nasm -f elf32 -g -F dwarf Lab0x03-DecimalCalc.asm
;
;go: Lab0x03-DecimalCalc.o
;	ld -m elf_i386 Lab0x03-DecimalCalc.o -o go

; run commands:
;		make
;		make go
;		./go
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


section .text    
	global _start         
_start:

    mov edx, msg1len    
    mov ecx, msg1 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80 

    mov edx, msg2len    
    mov ecx, msg2 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    
    mov edx, msg7len    
    mov ecx, msg7 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    
    mov edi, 0x00000000 ;stone counter
    mov ebx, 0x00000000 ;pointer for buffer (to be shifted)
    
_read:
    mov edx, 1  
    mov ecx, Newline
    mov ebx, stdout
    mov eax, sys_write
    int 0x80 
    
    mov edx, BUFFERSIZE
    mov ecx, inBuffer 
    mov ebx, stdin        
    mov eax, sys_read    
    int 0x80
  
    add eax, inBuffer
    dec eax
    mov [LastByte], eax
    mov esi, inBuffer
    
    mov ebx, [inBuffer]  ;pointer to buffer which will be shifted
    mov al, [inBuffer] 
    
    mov [operator], al
    
    cmp al, addition
    je _addition
    cmp al, modulo
    je _modulo
    cmp al, subtract
    je _subtract
    cmp al, multiply
    je _multiply
    cmp al, divide
    je _divide
    cmp al, x
    je _exit
    cmp al, X
    je _exit
    
    mov edx, msg4len    
    mov ecx, msg4 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
   
jmp _read

_asciiToBinary:
	


	mov al, [operator]
	cmp al, addition
	je _calcAdd
	cmp al, addition
        je _addition
        cmp al, modulo
        je _modulo
        cmp al, subtract
        je _subtract
        cmp al, multiply
        je _multiply
        cmp al, divide
        je _divide

_addition:
	jmp _asciiToBinary
		
	_calcAdd:
		mov eax, 0x00000000
		mov eax, [result]
		cmp eax, 0 
		je _equals
		add edi, eax
		jmp _equals
		
_subtract:
	.calcStones:
		shr ebx, 8  ;shift over 2 hex digits
		cmp bl, stone
		jne .calcSub
		inc edi
		mov [input], edi
		jmp .calcStones
	.calcSub:
		mov eax, 0x00000000
		mov eax, [result]
		cmp eax, 0  
		je _printEquals  ;cannot subtract from nothing, function sets input to zero
		mov eax, 0x00000000
		mov eax, [result]
		sub eax, edi
		mov edi, eax
		cmp edi, 0
		jl _printError
		jmp _equals
		
_divide:
	.calcStones:
		shr ebx, 8  ;shift over 2 hex digits
		cmp bl, stone
		jne .calcDiv
		inc edi
		mov [input], edi
		jmp .calcStones
	.calcDiv:
		mov eax, 0x00000000
		mov eax, [result]
		cmp eax, 0
		je _printEquals  ;cannot divide from nothing, function sets input to zero
		mov eax, 0x00000000
		mov edx, 0x00000000
		mov ax, [result]
		mov bx, di
		div bx
		mov di, ax
		jmp _equals
_modulo:
	.calcStones:
		shr ebx, 8  ;shift over 2 hex digits
		cmp bl, stone
		jne .calcMod
		inc edi
		mov [input], edi
		jmp .calcStones
	.calcMod:
		mov eax, 0x00000000
		mov eax, [result]
		cmp eax, 0
		je _printEquals  ;cannot divide from nothing, function sets input to zero
		mov eax, 0x00000000
		mov edx, 0x00000000
		mov ax, [result]
		mov bx, di
		div bx
		mov di, 0x0000
		mov di, dx
		jmp _equals
_multiply:
	.calcStones:
		shr ebx, 8  ;shift over 2 hex digits
		cmp bl, stone
		jne .calcMul
		inc edi
		mov [input], edi
		jmp .calcStones
	.calcMul:
		mov eax, 0x00000000
		mov eax, [result]
		cmp eax, 0
		je _printEquals  ;cannot multiply from nothing, function sets input to zero
		mov eax, 0x00000000
		imul edi, [result]
		jmp _equals
_equals:
	mov edx, 1    
   	mov ecx, Equals
    	mov ebx, stdout
   	mov eax, sys_write
    	int 0x80
    	
    	mov [result], edi
    	
    	.stonePrint:
	    	cmp edi, 0
	    	je _read
	    	cmp edi, 255
	    	jge _tooBig
    		dec edi
	    	mov edx, 1   
	   	mov ecx, Stone
	    	mov ebx, stdout
	   	mov eax, sys_write
	    	int 0x80 
	    	jmp .stonePrint    	
_printEquals:
	mov edx, 1    
   	mov ecx, Equals
    	mov ebx, stdout
   	mov eax, sys_write
    	int 0x80
    	
    	mov edi, 0
    	mov [input], edi
    	
    	jmp _read
_printError:
	mov edx, msg3len    
    	mov ecx, msg3 
    	mov ebx, stdout
    	mov eax, sys_write
    	int 0x80 
    	
    	mov edi, 0
    	mov [input], edi
    	mov [result], edi
    	
    	jmp _read
_tooBig:
	mov edx, msg6len    
    	mov ecx, msg6 
    	mov ebx, stdout
    	mov eax, sys_write
    	int 0x80 
    	
    	mov edi, 0
    	mov [input], edi
    	mov [result], edi
    	
    	jmp _read
_exit:

    mov edx, msg5len    
    mov ecx, msg5 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80            

    mov ebx, 0          
    mov eax, 1 
    int 0x80            

section .data

	;;;;;;;;;;;;;;;;;;prompts;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	msg1 db NEWLINE, 'Welcome to the Decimal Age!', NEWLINE, 0
	msg1len equ $-msg1

	msg2 db 'We do math in decimal...', NEWLINE, 0
	msg2len equ $-msg2

	msg3 db 'Error: Negative Result.', NEWLINE, 0
	msg3len equ $-msg3

	msg4 db 'Error: Unrecognized Symbol.', NEWLINE, 0
	msg4len equ $-msg4

	msg5 db NEWLINE, 'Returning to your proper time in history...', NEWLINE, 0
	msg5len equ $-msg5

	msg6 db 'Error: Result is larger than 255', NEWLINE, 0
	msg6len equ $-msg6

	msg7 db NEWLINE, 'Valid operands: + - * / %  Binary: 1 or 0   Exit: x', NEWLINE, '**Prefix Expressions Only**', NEWLINE, 0
	msg7len equ $-msg7
	

section .data

	Equals db '='
	Stone db 'o'
	Newline db 0x0A

section .bss

	inBuffer resb BUFFERSIZE
	outBuffer resb BUFFERSIZE
	input   resb 4
	result  resb 4
	LastByte resb 4
	operator resb 4
	
	;;;;;;;;;;;;;; Constants ;;;;;;;;;;;;;;;;;;;;;;
	sys_read  equ 0x03
	sys_write equ 0x04
	stdin     equ 0x00
	stdout    equ 0x01
	stderr    equ 0x02
	BUFFERSIZE equ 20
	SPACE     equ 0x20
	NEWLINE   equ 0x0A
	zero equ 0x30
	one equ 0x31
	x equ 0x78
	X equ 0x58
	addition equ 0x2B
	subtract equ 0x2D
	multiply equ 0x2A
	divide equ 0x2F
	modulo equ 0x25
	stone equ 0x6F
	equals equ 0x3D
