object:hexDumpA.asm
	nasm -f elf32 -g -F dwarf hexDumpA.asm

go: hexDumpA.o
	ld -m elf_i386 hexDumpA.o -o go
	
debug: 


clean:
