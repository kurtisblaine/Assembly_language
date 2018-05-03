section .text

    global _start

_start:

    mov byte [outBuffer+2], SPACE ;;; copy ascii code of a space to the third byte in outBuffer (it will just stay there always)

_InputBufferLoop:        ;;; we jump back to this point to read another line (or buffer full) of input

    mov edx, BUFFERSIZE  ;;; use sys_read to read a line or buffer full of bytes

    mov ecx, inBuffer 

    mov ebx, stdin       ;;; notice I am using a defined symbol instead of plain 0x00  

    mov eax, sys_read    ;;; again, a defined constant instead of a bare 0x03

    int 0x80             ;;; trigger a system call interrupt for the sys_read

    

    cmp eax, 0x00

    jle _exit            ;;; check return value of sys_read, 0 or less means error or end of file, so jump to _exit

    

    add eax, inBuffer    ;;; add the number of bytes read (return by sys_read in eax) to start addres of input buffer

    mov [LastInputBytePlusOne], eax   ;;; save that address for later comparison

 

    mov edi, 0x00        ;;; we will use EDI as bytes-per-line counter. Starts at 0.

 

    mov esi, inBuffer    ;;; use ESI register as pointer to input bytes, initialize it pointing to first byte 

    _ByteLoop:    

        mov eax, 0x0000000   ;;; zero the EAX register

        mov byte AL, [esi]   ;;; move an input byte to last byte to AL (last byte of EAX register)

        shr eax, 4           ;;; shift EAX -- move top 4 bits of the byte to the last 4 bits, giving a 4 bit number: 0x0..0xF 

        cmp eax, 10

        jge _else1:

            add eax, 0x30        ;;; add digit values 0..9 to 48, the ascii code for '0', to get 48..57, the ascii codes for '0'..'9'

        jmp _continue1:

        _else1:

            add eax, 0x37        ;;; add digit values 10..15 to 57 to get 65..70 (ascii codes for 'A'..'F')

        _continue1:

        mov [outBuffer],AL   ;;; copy last byte from EAX to the first byte of outBuffer

 

        mov byte AL, [esi]   ;;; fetch the same input byte again

        and EAX, 0x0000000F  ;;; and with bit mask that will leave behind just the last 4 bits   

        cmp eax, 10

        jge _else2:

           add eax, 0x30        ;;; add digit values 0..9 to 48, the ascii code for '0', to get 48..57, the ascii codes for '0'..'9'

        jmp _continue2:

        _else2:

           add eax, 0x37        ;;; add digit values 10..15 to 55 to get 65..70 (ascii codes for 'A'..'F')

        _continue2:

        mov [outBuffer+1],AL ;;; copy last byte from EAX to the second byte of outBuffer

        

        mov edx, 3           ;;; setting up a sys_write to print our 2 hex digits and a space from the output buffer

        mov ecx, outBuffer

        mov ebx, stdout

        mov eax, sys_write

        int 0x80             ;;; trigger a system call interrup for the sys_write

        

        inc esi              ;;; increment the address in ESI to point to the next input byte

        inc edi              ;;; increment our bytes-per-line counter

        cmp edi, BYTES_PER_LINE   ;;; compare bytes counter to desired bytes-per-line

        jl _SkipNewLine

        mov edi, 0           ;;; reset our bytes-per-line counter

        mov edx, 1           ;;; setup a sys_write to print just a newline

        mov ecx, newlineOutBuf 

        mov ebx, stdout

        mov eax, sys_write

        int 0x80             ;;; interrupt to call sys_write 

    _SkipNewLine:

        cmp esi,[LastInputBytePlusOne]

        jl _ByteLoop         ;;; still bytes left to process in input buffer, jump back to _ByteLoop        

    jmp _InputBufferLoop ;;; jump back up to grab another line or buffer full of input bytes

_exit:

    mov edx, 1           ;;; setup a sys_write to print just a final newline, just to make things look nice

    mov ecx, newlineOutBuf 

    mov ebx, stdout

    mov eax, sys_write

    int 0x80             ;;; interrupt to call sys_write 

 

    mov ebx, 0          ; only parameter of sys_exit is the return code for the program

    mov eax, 1          ; 1 is the code for sys_exit

    int 0x80            ; once again we do a system call interrupt    

section .data

    newlineOutBuf  db   0x0A   ;;; a very small "output buffer" containing just a newline character

section .bss

    inBuffer   resb BUFFERSIZE

    outBuffer  resb BUFFERSIZE   ;;; all we need is 3 bytes here. but why not have a standard buffer size?

    LastInputBytePlusOne  resb 4    ;;; reserve 4 byte word to store the count of bytes read in

    

;;;;;;;;;;;;;; define commonly used constants ;;;;;;;;;;;;;;;;;;;;;;

sys_read  equ 0x03

sys_write equ 0x04

stdin     equ 0x00

stdout    equ 0x01

stderr    equ 0x02

BUFFERSIZE equ 100

SPACE     equ 0x20  ;;; ASCII code for space

NEWLINE   equ 0x0A  ;;; ASCII code for newline

BYTES_PER_LINE  equ 4  ;;; define out bytes-per-line constant


