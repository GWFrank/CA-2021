run:
	riscv64-unknown-elf-gcc -o convert convert.c convert.s
debug:
	riscv64-unknown-elf-gcc -g -Og -D DEBUG -o convert.o -c convert.c
	riscv64-unknown-elf-gcc -g -Og -T spike.lds -nostartfiles -o convert convert.o convert.s
test:
	spike pk ./convert < input
clean:
	rm -f convert convert.o

