section .text

sumAtoB:
	push	ebp
	mov	ebp, esp
	push	esi
	mov	eax, dword [ebp + 12]
	mov	esi, dword [ebp + 8]
	xor	ecx, ecx

	cmp	esi, eax
	jg	LABEL
	
	cmp	eax, esi
	cmovl	eax, esi
	mov	edx, eax
	sub	edx, esi
	lea	ecx, [esi + 1]
	imul	ecx, edx
	dec	eax
	sub	eax, esi
	mul	edx
	shld	edx, eax, 31
	add	ecx, esi
	add	ecx, edx
LABEL:
	mov	eax, ecx
	pop	esi
	pop	ebp
	ret

