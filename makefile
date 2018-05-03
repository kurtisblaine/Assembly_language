object:name.asm
	nasm -f elf32 -g -F dwarf name.asm

go: name.o
	ld -m elf_i386 name.o -o go
	
debug: 


clean:
