all:
	nasm -g -f elf64 -o Maquina.o Maquina.asm
	g++ -c -g -no-pie -o Main.o Main.cpp
	g++ -g -no-pie -o exe Maquina.o Main.o

debug:
	nasm -g -f elf64 -o hello.o stack.asm
	ld -o stack hello.o

clean:
	rm *.o
