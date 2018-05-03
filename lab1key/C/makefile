object:hexDumpC.asm
	nasm -f elf32 -g -F dwarf hexDumpC.asm

go: hexDumpC.o
	ld -m elf_i386 hexDumpC.o -o go
	
debug: 


clean:
