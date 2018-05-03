section .text      
	global _start         
_start:

;mov byte [outBuffer+2], SPACE  ;;; copy ascii code of a space to the third byte in outBuffer (it will just stay ;there always)

_read: ;reads from terminal
    mov edx, BUFFERSIZE  ;;; use sys_read to read a line or buffer full of bytes
    mov ecx, inBuffer 
    mov ebx, stdin       ;;; notice I am using a defined symbol instead of plain 0x00  
    mov eax, sys_read    ;;; again, a defined constant instead of a bare 0x03
    int 0x80             
;end read from terminal

    mov edx, eax  ;will only work if _read is the last thing we did
    
    mov ecx, inBuffer ;one address at a time
    
_write: ;writes to terminal         
    mov ecx, inBuffer 
    mov ebx, stdin
    mov eax, sys_write
    int 0x80             
;end writes to terminal  
  
   cmp eax, 0       ; is EOF? if so...
   jle _exit         ; jump to exit

    
jmp _start

_exit:

    mov edx, 1           ;;; setup a sys_write to print just a final newline, just to make things look nice
    mov ecx, newlineOutBuf 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80             ;;; interrupt to call sys_write 

    mov ebx, 0          ; only parameter of sys_exit is the return code for the program
    mov eax, 1          ; 1 is the code for sys_exit
    int 0x80            ; once again we do a system call interrupt    

section.data

	    newlineOutBuf  db   0x0A   ;;; a very small "output buffer" containing just a newline character

section .bss
    inBuffer   resb BUFFERSIZE
    outBuffer  resb BUFFERSIZE   ;;; all we need is 3 bytes here. but why not have a standard buffer size?

;;;;;;;;;;;;;; Constants ;;;;;;;;;;;;;;;;;;;;;;
sys_read  equ 0x03
sys_write equ 0x04
stdin     equ 0x00
stdout    equ 0x01
stderr    equ 0x02
BUFFERSIZE equ 100
SPACE     equ 0x20  ;;; ASCII code for space
NEWLINE   equ 0x0A  ;;; ASCII code for newline
BYTES_PER_LINE  equ 1  ;;; define out bytes-per-line constant
