;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; 	Kurtis B Waldner

;MAKEFILE

;object:Lab0x0A-Xname.asm
;	nasm -f elf32 -g -F dwarf Lab0x0A-Xname.asm
;
;go: Lab0x0A-Xname.o
;	ld -m elf_i386 Lab0x0A-Xname.o -o go
	
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

_read:
    
    mov edx, BUFFERSIZE  ;;; use sys_read to read a line or buffer full of bytes
    mov ecx, inBuffer 
    mov ebx, stdin       ;;; notice I am using a defined symbol instead of plain 0x00  
    mov eax, sys_read    ;;; again, a defined constant instead of a bare 0x03
    int 0x80
    
    mov edx, msg2len    
    mov ecx, msg2
    mov ebx, stdout
    mov eax, sys_write
    int 0x80              

    cmp eax, 0       ; is EOF? if so...
    jle _exit         ; jump to exit

   add eax, inBuffer ;save the number of characters in buffer
   sub eax, 1 
   mov [LastByte], eax ;save the number for later
   mov edi, 0x00 ;bytes per line counter
   mov esi, inBuffer ;fist byte pointer
   inc ebp
   
_printLoop:
   xor esp, esp
   .loop:
   mov eax, 0x00
   mov byte al, [esi]
   mov byte [outBuffer + esp], al
   
   mov edx, 1
   mov ecx, outBuffer
   mov ebx, stdout
   mov eax, sys_write
   int 0x80    
   
   xor eax, eax
   mov eax, [LastByte]
   mov bl, 0x00
   mov byte bl, [esi + eax]
   sub eax, esp
   mov byte [outBuffer+eax], bl
   
   mov edx, 1
   mov ecx, outBuffer
   mov ebx, stdout
   mov eax, sys_write
   int 0x80  
   
   xor eax, eax
   mov eax, [LastByte]
   mov byte[outBuffer+eax+1], NEWLINE
   
   mov edx, 1
   mov ecx, outBuffer
   mov ebx, stdout
   mov eax, sys_write
   int 0x80  
   
   inc esp
   inc esi
   inc edi 
   
   cmp esi, [LastByte]
   jle .loop    


jmp _exit
   
_exit:

    mov edx, 1           
    mov ecx, newLine
    mov ebx, stdout
    mov eax, sys_write
    int 0x80            

    mov ebx, 0          
    mov eax, 1         
    int 0x80               
	
section .data

    newLine    db 0x0A
    msg1 db "Please enter your name: " , NEWLINE, 0
    msg1len equ $-msg1
    msg2 db "Thanks..." , NEWLINE, 0
    msg2len equ $-msg2

section .bss

    inBuffer   resb BUFFERSIZE
    outBuffer  resb 1 
    LastByte   resb 4
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
BYTES_PER_LINE equ 1
