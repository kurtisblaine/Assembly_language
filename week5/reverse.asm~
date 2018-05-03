section .text
	global _start;
_start:;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mov esi, text    
	add esi, textlen
	dec esi
	mov edi, somewhere
_textRevLoop:
	mov al, [esi]
	mov [edi], al
	dec esi		
	inc edi
	cmp esi,text
	jge _textRevLoop         ;jump back and repeat if   				         ;ESI >= text
_revArray:;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mov esi, primes
	mov ecx, nprimes
	dec ecx		  ;ecx will be index into the source array of integers, primes
	mov edi, elsewhere
	mov ebx, 0 ;ebx will be the index into the destination array of integers, elsewhere
_arrayRevLoop:
	mov eax, [esi + 4*ecx] ;copy the 4byte word from 				       ;location [esi + 4*ecx] to eax
	mov [esi + 4*ecx], eax ;copy the 4byte word from eax 				       ;to location [esi + 4*ecx]
	inc ebx
	dec ecx
	cmp ecx, 0 	       ;compare to zero
	jge _arrayRevLoop      ;jump back and repeat
_exit:;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	mov ebx, 0
	mov eax, 1
	int 0x80
section .data
	text db "abcdefghijklmnopqrstuvwxyz" ;first of 26 						     ;bytes defined 						     ;here
	textlen equ $-text ;text len is current byte minus 				   ;the address text
  primes dd 2,3,5,7,11,13,17,19,23,29,31,37,41,43,47 ;creates an array of 32bit integers
	nprimes equ ($ - primes) / 4     ;number of bytes 						 ;from address 						 ;primes to here / 						 ;4bytes per double- 						 ;word
section .bss
	size equ 100
	somewhere resb size;a buffer for up to 100 bytes
			   ;resb is a character array
	elsewhere resd size;an array of up to 100 4-byte
			   ;resd is an integer array 				   ;double-words
