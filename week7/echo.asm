section .text      
	global _start         
_start:

_read: ;reads from terminal
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

   mov eax, 0x00
   mov byte al, [esi]
   mov [outBuffer], al
   mov edx, 1
   mov ecx, outBuffer
   mov ebx, stdout
   mov eax, sys_write
   int 0x80
   
   inc esi
   inc edi
   
   cmp esi, [LastByte]
   jle _printLoop
   je _newLine
    
jmp _read

_newLine:         
    mov edx, 1          
    mov ecx, 0x0A 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80


_exit:

    mov edx, 1           ;;; setup a sys_write to print just a final newline, just to make things look nice
    mov ecx, 0x0A
    mov ebx, stdout
    mov eax, sys_write
    int 0x80             ;;; interrupt to call sys_write 

    mov ebx, 0          ; only parameter of sys_exit is the return code for the program
    mov eax, 1          ; 1 is the code for sys_exit
    int 0x80            ; once again we do a system call interrupt    


section .bss

    inBuffer   resb BUFFERSIZE
    outBuffer  resb 1   ;;; all we need is 1 byte here. but why not have a standard buffer size?
    LastByte   resb 4

;;;;;;;;;;;;;; Constants ;;;;;;;;;;;;;;;;;;;;;;
sys_read  equ 0x03
sys_write equ 0x04
stdin     equ 0x00
stdout    equ 0x01
stderr    equ 0x02
BUFFERSIZE equ 100
SPACE     equ 0x20  ;;; ASCII code for space
NEWLINE   equ 0x0A  ;;; ASCII code for newline

