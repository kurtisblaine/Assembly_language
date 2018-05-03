;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;	Kurtis B Waldner

;MAKEFILE

;object:Lab0x03-BinCalc.asm
;	nasm -f elf32 -g -F dwarf Lab0x03-BinCalc.asm
;
;go: Lab0x03-BinCalc.o
;	ld -m elf_i386 Lab0x03-BinCalc.o -o go

; run commands:
;		make
;		make go
;		./go
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .text
    global _start
_start:
   
    mov edx, welcomeMsgLen
    mov ecx, welcomeMsg
    mov ebx, stdout
    mov eax, sys_write
    int 0x80

    mov byte [result], 0
    mov byte [previous], 0
   
    jmp _printResultPebbles
    
_MathLoop:
    mov edx, BUFFERSIZE
    mov ecx, pebbleInBuffer 
    mov ebx, stdin       
    mov eax, sys_read   
    int 0x80            

    cmp eax, 0x00
    jle _exit         

    cmp eax, 257
    jl _continue1
    mov eax, [pebbleInBuffer+eax-1]
    mov [LastByte], eax
    
_continue1: 
    sub eax, 1
    mov esi, pebbleInBuffer
    inc esi
    mov [LastByte], esi
    xor edi, edi          
    xor ebx, ebx		
_checkPebblesLoop:
    cmp edi, eax             
    jge _PebblesAllVerified  
    cmp byte [esi+edi], '1'
    je _calc
    _continue:
    inc ebx
    inc edi    
    jmp _checkPebblesLoop
    
_calc:

    cmp ebx, 0
    je _add128
    cmp ebx, 1
    je _add64
    cmp ebx, 2
    je _add32
    cmp ebx, 3
    je _add16
    cmp ebx, 4
    je _add8
    cmp ebx, 5
    je _add4
    cmp ebx, 6
    je _add2
    cmp ebx, 7
    je _add1
    
_add128:
    mov ecx, 128
    add [previous], ecx
    jmp _continue
_add64:
    mov ecx, 64
    add [previous], ecx
    jmp _continue
_add32:
    mov ecx, 32
    add [previous], ecx
    jmp _continue
_add16:
    mov ecx, 16
    add [previous], ecx
    jmp _continue
_add8:
    mov ecx, 8
    add [previous], ecx
    jmp _continue
_add4:
    mov ecx, 4
    add [previous], ecx
    jmp _continue
_add2:
    mov ecx, 2
    add [previous], ecx
    jmp _continue
_add1:
    mov ecx, 1
    add [previous], ecx
    jmp _continue

    
    
_PebblesAllVerified:
    
    cmp byte [pebbleInBuffer], 'x'
    je _exit
    cmp byte [pebbleInBuffer], '+'
    je _plus
    cmp byte [pebbleInBuffer], '-'
    je _minus
    cmp byte [pebbleInBuffer], '*'
    je _multiply
    cmp byte [pebbleInBuffer], '/'
    je _divide
    cmp byte [pebbleInBuffer], '%'
    je _modulo
   
    jmp _invalidOperator   
        
_plus:
    mov al, [previous]
    add [result], al
    jo _overflow
    jmp _printResultPebbles
_minus:
    mov al, [previous]
    sub al, [result]
    mov byte [result], 0
    mov [result], al
    cmp byte [result],0
    jle _underflow
    jmp _printResultPebbles
_multiply:
    mov al, [previous]
    mul byte [result] 
    jo _overflow 
    mov [result], AL
    jmp _printResultPebbles
_divide:
    mov al, [previous]
    mov BL, AL   
    mov AL, [result]  
    mov AH, 0         
    div BL   
    mov [result],AL 
    jmp _printResultPebbles
_modulo:
    mov al, [previous]
    mov BL, AL   
    mov AL, [result]  
    mov AH, 0                          
    div BL   
    mov [result],AH        
    jmp _printResultPebbles
_NotAPebble:
    mov edx, notAPebbleMsgLen
    mov ecx, notAPebbleMsg
    jmp _finishErrorMsg
_TooManyPebbles:
    mov edx, tooManyPebbleMsgLen
    mov ecx, tooManyPebbleMsg
    jmp _finishErrorMsg
_overflow:
    mov edx, overflowMsgLen
    mov ecx, overflowMsg
    mov byte [result], 0  ;;; reset result to zero on overflow
    jmp _finishErrorMsg
_underflow:
    mov edx, underflowMsgLen
    mov ecx, underflowMsg
    mov byte [result], 0  
    jmp _finishErrorMsg
_invalidOperator:
    mov edx, invalidOperatorMsgLen
    mov ecx, invalidOperatorMsg
    jmp _finishErrorMsg

_finishErrorMsg:
    mov ebx, stdout
    mov eax, sys_write   
    int 0x80   
    
_printResultPebbles:
    _continue2:
      	    xor eax, eax
      	    
	    mov eax, [result]
	    cmp eax, 256
	    jg _overflow
	   
	    cmp eax, 128
	    jge _div128 
	    cmp eax, 64
	    jge _div64 
	    cmp eax, 32
	    jge _div32
	    cmp eax, 16
	    jge _div16 
	    cmp eax, 8
	    jge _div8
	    cmp eax, 4
	    jge _div4 
	    cmp eax, 2
	    jge _div2
	    cmp eax, 1
	    jge _div1 
	    
	    mov edx, BinaryBufferLength        
	    mov ecx, BinaryBuffer 
	    mov ebx, stdout
	    mov eax, sys_write
	    int 0x80
    
    	    jmp _MathLoop 
	   
	    _div128:
	    	mov al, 128
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+1], '1'
	    
	    	jmp _continue2
	    	
	    _div64:
	    	mov al, 64
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+2], '1'
	    
	    	jmp _continue2
	    _div32:
	    	mov al, 32
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+3], '1'
	    
	    	jmp _continue2
	    _div16:
	    	mov al, 16
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+4], '1'
	    
	    	jmp _continue2
	    _div8:
	    	mov al, 8
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+5], '1'
	    
	    	jmp _continue2
	    _div4:
	    	mov al, 4
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+6], '1'
	    
	    	jmp _continue2
	    _div2:
	    	mov al, 2
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+7], '1'
	    
	    	jmp _continue2
	    _div1:
	    	mov al, 1
	    	sub [result], al
	    	
	    	mov byte[BinaryBuffer+8], '1'
	    
	    	jmp _continue2
    
_exit:
    mov edx, exitMsgLen       
    mov ecx, exitMsg 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80             

    mov ebx, 0          
    mov eax, 1         
    int 0x80              


section .data
    newlineOutBuf          db   NEWLINE   
    welcomeMsg             db  "Welcome to the binary age we do math in binary.", "***Prefix Expressions Only***", NEWLINE, 0
    welcomeMsgLen          equ $ - welcomeMsg

    invalidOperatorMsg     db   "Invalid Operator",NEWLINE
    invalidOperatorMsgLen  equ $ - invalidOperatorMsg

    notAPebbleMsg          db   "Error: 1's and 0's only",NEWLINE
    notAPebbleMsgLen       equ $ - notAPebbleMsg

    tooManyPebbleMsg       db   "Error: Too many digits",NEWLINE
    tooManyPebbleMsgLen    equ $ - tooManyPebbleMsg

    overflowMsg            db   "Error: Overflow",NEWLINE
    overflowMsgLen         equ $ - overflowMsg

    underflowMsg           db   "Error: Negative Number",NEWLINE
    underflowMsgLen        equ $ - underflowMsg

    exitMsg                db   "Returning to your proper time in history",NEWLINE
    exitMsgLen             equ $ - exitMsg

   BinaryBuffer db "=00000000", NEWLINE, 0
   BinaryBufferLength equ $-BinaryBuffer
   
section .bss  
    result resb 4   
    AddressOfLastBytePlusOne resb 4 
    pebbleInBuffer resb BUFFERSIZE  
    previous resb 4
    LastByte resb 4 
    OrigBuffer resb 4
;;;;;;;;;;;;;; define commonly used constants ;;;;;;;;;;;;;;;;;;;;;;
sys_read  equ 0x03
sys_write equ 0x04
stdin     equ 0x00
stdout    equ 0x01
stderr    equ 0x02
BUFFERSIZE equ 255
SPACE     equ 0x20  
NEWLINE   equ 0x0A  


