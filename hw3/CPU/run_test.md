## Compile verilog for each testcase
```bash
iverilog -D T0 -f cpu.f
iverilog -D T1 -f cpu.f
...
iverilog -D T7 -f cpu.f
```

## Run test
```bash
vvp ./a.out
```