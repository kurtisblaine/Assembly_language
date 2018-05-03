;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; 	Kurtis B Waldner

;MAKEFILE

;object:Lab0x04-BracketMatcher.asm
;	nasm -f elf32 -g -F dwarf Lab0x04-BracketMatcher.asm
;
;go: Lab0x04-BracketMatcher.o
;	ld -m elf_i386 Lab0x04-BracketMatcher.o -o go
	
; run commands:
;		make
;		make go
;		./go
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

section .text      
	global _start         
_start:
    mov dword [stack], esp
_read: ;reads from terminal
    cmp esp, [stack]
    jne _error2
    
    mov edx, BUFFERSIZE  ;;; use sys_read to read a line or buffer full of bytes
    mov ecx, inBuffer 
    mov ebx, stdin       ;;; notice I am using a defined symbol instead of plain 0x00  
    mov eax, sys_read    ;;; again, a defined constant instead of a bare 0x03
    int 0x80             
;end read from terminal

   cmp eax, 0       ; is EOF? if so...
   jle _exit         ; jump to exit

   add eax, inBuffer ;save the number of characters in buffer
   sub eax, 1 
   mov [LastByte], eax ;save the number for later
   mov edi, 0x00 ;bytes per line counter
   mov esi, inBuffer ;fist byte pointer
   
_printLoop:

   mov eax, 0x00000000
   mov byte al, [esi]
   
   cmp al, '{'
   je _match
   cmp al, '}'
   je _endmatch
   cmp al, '('
   je _match
   cmp al, ')'
   je _endmatch
   cmp al, '['
   je _match
   cmp al, ']'
   je _endmatch
   
   _continue:
   inc esi
   inc edi
   
   cmp esi, [LastByte]
   jle _printLoop
   je _newLine
    
jmp _read

_match:
   push ax
   jmp _continue
   
_endmatch:
   mov bx, 0x0000
   pop bx
   mov [top], bx
   
   _check:
   cmp esp, [stack]
   jne _somethingleftonstack
   
   cmp al, '}'
   je .continuea
   cmp al, ']'
   je .continueb
   cmp al, ')'
   je .continuec
   jne _error
   
   .continuea:
   cmp byte[top], '{'
   je _success
   jne _error
   
   .continueb:
   cmp byte[top], '['
   je _success
   jne _error
   
   .continuec:
   cmp byte[top], '('
   je _success
   jne _error
   
   jmp _continue
    
_success:
    mov edx, msg1len         
    mov ecx, msg1
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    jmp _read
    
_error:
    mov byte [outBuffer], 0x00000000
    mov byte [outBuffer], al
    mov byte [outBuffer+1], NEWLINE
    
    mov edx, msg3len         
    mov ecx, msg3 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
  
    mov edx, 2         
    mov ecx, outBuffer
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    
    jmp _read
    
_newLine:  
    cmp esp, [stack]
    jne _error2
       
    mov edx, 1          
    mov ecx, 0x0A 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    
_somethingleftonstack:
    mov esp, [stack]
    mov edx, msg4len         
    mov ecx, msg4
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    jmp _read
    
_error2:
    mov esp, [stack]
    mov edx, msg5len         
    mov ecx, msg5
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    
    jmp _read  
_exit:
    mov edx, 1           ;;; setup a sys_write to print just a final newline, just to make things look nice
    mov ecx, 0x0A
    mov ebx, stdout
    mov eax, sys_write
    int 0x80             ;;; interrupt to call sys_write 

    mov ebx, 0          ; only parameter of sys_exit is the return code for the program
    mov eax, 1          ; 1 is the code for sys_exit
    int 0x80            ; once again we do a system call interrupt  
      
section .data
	msg1 db 'All brackets are balanced.', NEWLINE, 0
	msg1len equ $-msg1
	
	msg2 db NEWLINE, 'Expecting  a  , but found a  ', NEWLINE, 0
	msg2len equ $-msg2
	
	msg3 db 'Input ended with an open ', 0
	msg3len equ $-msg3
	
	msg4 db 'Found a closed bracket without an opening bracket', NEWLINE, 0 
	msg4len equ $-msg4
	
	msg5 db 'Found a open bracket without a closing bracket', NEWLINE, 0 
	msg5len equ $-msg5

section .bss

    inBuffer   resb BUFFERSIZE
    outBuffer  resb 1   ;;; all we need is 1 byte here. but why not have a standard buffer size?
    LastByte   resb 4
    stack resb 4
    top resb 4
;;;;;;;;;;;;;; Constants ;;;;;;;;;;;;;;;;;;;;;;
sys_read  equ 0x03
sys_write equ 0x04
stdin     equ 0x00
stdout    equ 0x01
stderr    equ 0x02
BUFFERSIZE equ 100
SPACE     equ 0x20  ;;; ASCII code for space
NEWLINE   equ 0x0A  ;;; ASCII code for newline
