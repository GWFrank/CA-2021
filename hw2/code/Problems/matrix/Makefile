run:
	riscv64-unknown-elf-gcc -o matrix matrix.c matrix.s
debug:
	riscv64-unknown-elf-gcc -g -Og -D DEBUG -o matrix.o -c matrix.c
	riscv64-unknown-elf-gcc -g -Og -T spike.lds -nostartfiles -o matrix matrix.o matrix.s
test:
	spike pk ./matrix < input
clean:
	rm -f matrix matrix.o

