section .text

    global _start

_start:

    mov byte [outBuffer+2], SPACE ;;; copy ascii code of a space to the third byte in outBuffer (it will just stay there always)

_InputBufferLoop:

    mov edx, BUFFERSIZE  ;;; use sys_read to read a line or buffer full of bytes

    mov ecx, inBuffer 

    mov ebx, stdin       ;;; notice I am using a defined symbol instead of plain 0x00  

    mov eax, sys_read    ;;; again, a defined constant instead of a bare 0x03

    int 0x80             ;;; trigger a system call interrupt for the sys_read

    

    cmp eax, 0x00

    jle _exit            ;;; check return value of sys_read, 0 or less means error or end of file, so jump to _exit

    

    add eax, inBuffer    ;;; add the number of bytes read (return by sys_read in eax) to start addres of input buffer

    sub eax, 1

    mov [ LastInputByte ], eax   ;;; save that address for later comparison

 

    mov edi, 0x00        ;;; we will use EDI as bytes-per-line counter. Starts at 0.     

 

    mov esi, inBuffer    ;;; use ESI register as pointer to input bytes, initialize it pointing to first byte 

    _ByteLoop:    

        mov eax, 0x00000000  ;;; zero the EAX register

        mov byte AL, [esi]   ;;; move an input byte to last byte to AL (last byte of EAX register)       so if first input byte is 'z', then AL=0x7A, EAX 0x0000007A

        add eax, eax         ;;; muliply eax by two -- many ways to do this, here we add it to itself

        add eax, hexPairTable ;;; add hex pair table address to eax, this is address of our desired hex digit pair

        mov BX, [eax]        ;;; copy two bytes starting from location addressed by EAX to BX (lower half of EBX register)....   EBX=0x00003741 (ascii codes of '7','A')

        mov [outBuffer],BX   ;;; copy two bytes from BX to the first two bytes of outBuffer

        

        mov edx, 3           ;;; setting up a sys_write to print our 2 hex digits and a space from the output buffer

        mov ecx, outBuffer

        mov ebx, 1

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

        cmp esi,[LastInputByte]  ;;; I don't want to compare to address LastInputByte. I want to compare to the address stored at location LastInputByte, given by [LastInputByte]

                                 ;;; which is the the address of the last input byte

        jle _ByteLoop         ;;; still bytes left to process in input buffer, jump back to _ByteLoop

            

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

    hexPairTable   db   "000102030405060708090A0B0C0D0E0F", \

                        "101112131415161718191A1B1C1D1E1F", \

                        "202122232425262728292A2B2C2D2E2F", \

                        "303132333435363738393A3B3C3D3E3F", \

                        "404142434445464748494A4B4C4D4E4F", \

                        "505152535455565758595A5B5C5D5E5F", \

                        "606162636465666768696A6B6C6D6E6F", \

                        "707172737475767778797A7B7C7D7E7F", \

                        "808182838485868788898A8B8C8D8E8F", \

                        "909192939495969798999A9B9C9D9E9F", \

                        "A0A1A2A3A4A5A6A7A8A9AAABACADAEAF", \

                        "B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF", \

                        "C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF", \

                        "D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF", \

                        "E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF", \

                        "F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF"

    newlineOutBuf  db   0x0A   ;;; a very small "output buffer" containing just a newline character

section .bss

    inBuffer   resb BUFFERSIZE

    outBuffer  resb 3   ;;; all we need is 3 bytes here. but why not have a standard buffer size?

    LastInputByte  resb 4    ;;; reserve 4 byte word to store the count of bytes read in

    

;;;;;;;;;;;;;; define commonly used constants ;;;;;;;;;;;;;;;;;;;;;;

sys_read  equ 0x03

sys_write equ 0x04

stdin     equ 0x00

stdout    equ 0x01

stderr    equ 0x02

BUFFERSIZE equ 100

SPACE     equ 0x20  ;;; ASCII code for space (32 decimal)

NEWLINE   equ 0x0A  ;;; ASCII code for newline

BYTES_PER_LINE  equ 4  ;;; define out bytes-per-line constant


