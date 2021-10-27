run:
	riscv64-unknown-elf-gcc -o fibonacci fibonacci.c fibonacci.s
debug:
	riscv64-unknown-elf-gcc -g -Og -D DEBUG -o fibonacci.o -c fibonacci.c
	riscv64-unknown-elf-gcc -g -Og -T spike.lds -nostartfiles -o fibonacci fibonacci.o fibonacci.s
test:
	spike pk ./fibonacci
clean:
	rm -f fibonacci fibonacci.o

