#/bin/bash
iverilog -D T0 -f cpu.f
vvp ./a.out
iverilog -D T1 -f cpu.f
vvp ./a.out
iverilog -D T2 -f cpu.f
vvp ./a.out
iverilog -D T3 -f cpu.f
vvp ./a.out
iverilog -D T4 -f cpu.f
vvp ./a.out
iverilog -D T5 -f cpu.f
vvp ./a.out
iverilog -D T6 -f cpu.f
vvp ./a.out
iverilog -D T7 -f cpu.f
vvp ./a.out
rm a.out cpu.vcd
