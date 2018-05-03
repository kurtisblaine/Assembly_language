object:hexDumpB.asm
	nasm -f elf32 -g -F dwarf hexDumpB.asm

go: hexDumpB.o
	ld -m elf_i386 hexDumpB.o -o go
	
debug: 


clean:
