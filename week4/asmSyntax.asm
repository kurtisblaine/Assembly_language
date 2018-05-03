section .text
	global _start;
_start:
	
	mov eax, 100
	mov ebx, 0x64 ; 100 in hexadecimal
	add eax, ebx  ;eax = eax + ebx
	mov [result], eax ;brackets will store the data in the address at result w/o brackets will just be the memory address
	sub eax, 0x63 ; 44 in hex 2*16 = 32 + 12
	cmp eax, 150 ; compare eax to 150
		     ; this will set/unset zero flag 
		     ;and sign flag
		     ;previous values are all lost!
	jle _lesser  ;jump if equal (equallity flag)
	mov edx, 0x00000001
	jmp _continue
	
	_lesser:
		mov edx, 0xFFFFFFFF ;puts all ones in edx
		
	_continue:
		add edx, 0x00000001
		mov eax, 0x12345678
		mov AX,      0xFF00
		mov ebx, x ;copies address x into ebx
		mov ecx, [x] ; copies 4 bytes starting at address x, from memory into ecx
		add ebx, 4 ; 4 is the number in ebx which is also the address in x
		mov edx, [ebx] ;copies 4 bytes from memory at teh address currently in EBX
	
	_exit: ;clean sys_exit call
		mov edx, 0
		mov eax, 1 ; the one in eax makes a sys_exit without seg fault
		int 0x80
	
	
section .data   ; .data is for inializing data: constants
	x    dd    42  ;x is address of 1st byte of a word
	y    dd  0xF0F0F0F0   ;y is a address of 1st byte of a 4 byte double word. dd=data doubleword
	result dd 0  ;address result will be x+4
section .bss    ;.bss is for variables -- reserving memory for variables 









