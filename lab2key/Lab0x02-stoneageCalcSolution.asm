section .text
    global _start
_start:
    ;;; welcome message
    mov edx, welcomeMsgLen
    mov ecx, welcomeMsg
    mov ebx, stdout
    mov eax, sys_write
    int 0x80

    ; start with result at zero
    mov byte [result], 0
    
    ;; jump to where we print the result to get the initial '=' with no pebbles after it, then it will jump back up to start of _MathLoop
    jmp _printResultPebbles
    
_MathLoop:
    ; read a line -- we're assuming interactive, so always getting one line per sys_read
    ; of course this will not work with a file input
    mov edx, BUFFERSIZE  ;;; BUFFERSIZE is 257, operator + maximum of 255 pebbles +  newline character should be the most we need
    mov ecx, pebbleInBuffer 
    mov ebx, stdin       ;;; notice I am using a defined symbol instead of plain 0x00  
    mov eax, sys_read    ;;; again, a defined constant instead of a bare 0x03
    int 0x80             ;;; trigger a system call interrupt for the sys_read

    ;; check for end of file and break out of the InputBufferLoop if we are
    cmp eax, 0x00
    jle _exit            ;;; check return value of sys_read, 0 or less means error or end of file, so jump to _exit

    cmp eax, 257
    jl _continue1
    cmp byte [pebbleInBuffer+eax-1], NEWLINE  ;; if we have 257 bytes of input the last one better be a newline, since 255 is max number we will handle
    jne _TooManyPebbles
    
_continue1: 
    ;; assuming no invalid characters, then (number of input bytes)-2 will be the (number of pebbles) 
    sub eax, 2   ;;; keep the number of input pebbles in EAX 
                 ;;; we'll be done with it by the time we need EAX again for something else like a sys_write
    
    ;; now a do a loop to make sure everything else on the input line is a "pebble" (a lowercase 'o') up to the newline character
    mov esi, pebbleInBuffer
    inc esi                 ;; we start looking at the second character, which should be the first pebble
    mov edi, 0              ;; we'll use edi as an offset counter
_checkPebblesLoop:
    cmp edi, eax              ;; have we checked all the input characters that shoudl be pebbles?
    jge _PebblesAllVerified   ;; we do this check at the top of loop, because there might be zero pebbles
    cmp byte [esi+edi], 'o'        ;; is it a pebble?
    jne _NotAPebble      
         ;; if not a pebble, jump to the NotAPebble error message
    inc edi
    jmp _checkPebblesLoop
_PebblesAllVerified:

    ;; check for an 'x' as first byte of input and exit
    cmp byte [pebbleInBuffer], 'x'
    je _exit
    
    ;; check first byte for valid operation and jump to section that handles it...
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
    
    ;; if we get here then invalid input -- the user's input line must have started with something other than "+-/*%x"
    jmp _invalidOperator   
    
    ;;;NOTE: we only get here if EAX has a value form 0x00 to 0xFF (0 to 255) 
    ;;;      -- a one byte value, so all bits will be zero except in lowest byte: AL    
_plus:
    add [result], al
    jo _overflow
    jmp _printResultPebbles
_minus:
    sub [result], al
    ;; check underflow
    jb _underflow  ;; "jb" isn the unsigned "jump if less than"
    jmp _printResultPebbles
_multiply:
    ;;; unsigned multiplication is done by mul (use imul for signed, which is also more versatile)
    ;;; mul only takes one operand and always multiplies times EAX(32bit), AX(16bit), or AL(8bit)
    ;;; the result(which can be twices as many digits or bits) lands in EDX:EAX, or DX:AX, or AH:AL (same thing as AX)
    mul byte [result] 
    jo _overflow 
    ;;; because the result of the mul operation ends up in AL, we need to mov it to [result] for safe keeping
    mov [result], AL
    jmp _printResultPebbles
_divide:
    ;;; we use div for unsigned division
    ;;; both div & idiv are somewhat special, using two registers to construct the divided, 
    ;;;      and using two registers for the result: quotient & remainder(modulo)
    ;;; The dividend is either: EDX:EAX, DX:AX, or AH:AL (last one is same as AX by itself)
    ;;; we're doing 1 byte division, so we want AH=0, and our dividend needs to go into AL
    ;;; BUT our divisor is already in AL!!! so we must move things around...
    mov BL, AL   ;; put our divisor into BL
    mov AL, [result]  ;; current result is our dividend, so put it in AL
    mov AH, 0         ;; not really necessary because AH should already be zero but let's just be explicit about it here
    div BL   ;; the 1-byte version of div has only one operand -- the divisor. The dividend is always AH:AL (or simply AX)  
    mov [result],AL   ;; the quotient will land in AL, so copy it back to [result] 
    ;; note that we can't get overflow from doing division in this case
    jmp _printResultPebbles
_modulo:
    ;;; do the same thing as division, but the remainder is the result we want...
    mov BL, AL   ;; put our divisor into BL
    mov AL, [result]  ;; current result is our dividend, so put it in AL
    mov AH, 0         ;; not really necessary because AH should already ahve been zero...
                      ;; blut let's just be explicit about it here
    div BL   ;; the 1-byte version of div has only one operand -- the divisor. The dividend is always AH:AL (or simply AX)  
    mov [result],AH   ;; the remainder will land in AH, so copy it back to [result] 
    ;;; can't get overflow from doing division, in either the quotient or the remainder       
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
    mov byte [result], 0  ;;; reset result to zero on underflow
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
    ;;; we need to print an '=' followed by [result] 'o' characters, then a newline
    ;;; one way to do this: have a big buffer "=ooooooooooo...255 of them....." and just print as much as we need...
    mov edx, 0  ;; make sure edx is clear
    mov DL, [result]  ;; move the 1 byte result into DL -- so now EDX will be the number of pebbles we need to print
    add edx, 1        ;; add 1 to edx because we also need to print the '=', so total number of characters to print is one higher the number of pebbles
    mov ecx, pebbleOutBuffer ;; address of our result pebble buffer
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    ;; now print the newline character separately
    mov edx, 1
    mov ecx, newlineOutBuf
    mov ebx, stdout
    mov eax, sys_write
    int 0x80
    ;;
    
    jmp _MathLoop ;; unconditional jump back up to repeat InputBufferLoop, 
                         ;; because exiting that loop is handled just after reading the input buffer
    
_exit:
    mov edx, exitMsgLen       ;;; setup a sys_write to print just a final newline, just to make things look nice
    mov ecx, exitMsg 
    mov ebx, stdout
    mov eax, sys_write
    int 0x80             ;;; interrupt to call sys_write 

    mov ebx, 0          ; only parameter of sys_exit is the return code for the program
    mov eax, 1          ; 1 is the code for sys_exit
    int 0x80            ; once again we do a system call interrupt   


section .data
    newlineOutBuf          db   NEWLINE   ;;; a very small "output buffer" containing just a newline character

    welcomeMsg             db  "Grog say: Grog good at math. Do math with pebbles.",NEWLINE
    welcomeMsgLen          equ $ - welcomeMsg

    invalidOperatorMsg     db   "Grog say:  Grog not no how to do that!",NEWLINE
    invalidOperatorMsgLen  equ $ - invalidOperatorMsg

    notAPebbleMsg          db   "Grog say:  You try trick Grog!  Grog no only can do math with pebble!",NEWLINE
    notAPebbleMsgLen       equ $ - notAPebbleMsg

    tooManyPebbleMsg       db   "Grog say:  Too many pebble!  You try hurt Grog head! Start over!",NEWLINE
    tooManyPebbleMsgLen    equ $ - tooManyPebbleMsg

    overflowMsg            db   "Grog say:  Grog not have enough pebble for that! Start over!",NEWLINE
    overflowMsgLen         equ $ - overflowMsg

    underflowMsg           db   "Grog say:  Grog can't do that.  Negative number not invented yet!",NEWLINE
    underflowMsgLen        equ $ - underflowMsg

    exitMsg                db   "Grog say:  Grog genius brain tired.  Glad you finished.",NEWLINE
    exitMsgLen             equ $ - exitMsg

    pebbleOutBuffer        db "=oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo",\
                              "oooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo"
section .bss  
    result resb 4   ;  4 byte (32 bit) unsigned integer  
    AddressOfLastBytePlusOne resb 4 ;; place to store the address of the last input byte in the input buffer
    pebbleInBuffer   resb BUFFERSIZE  
    
;;;;;;;;;;;;;; define commonly used constants ;;;;;;;;;;;;;;;;;;;;;;
sys_read  equ 0x03
sys_write equ 0x04
stdin     equ 0x00
stdout    equ 0x01
stderr    equ 0x02
BUFFERSIZE equ 258
SPACE     equ 0x20  ;;; ASCII code for space (32 decimal)
NEWLINE   equ 0x0A  ;;; ASCII code for newline

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

