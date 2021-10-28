# HW2

 b09902004 資工二 郭懷元

## 2.8

```c
*(A+1) = A;
f = *(A+1) + A;
```

## 2.9

| instruction        | `opcode` | `rs1`   | `rd`    | `rs2`   | `imm`   | `funct3` | `funct7` |
| ------------------ | -------- | ------- | ------- | ------- | ------- | -------- | -------- |
| `addi x30, x10, 8` | `010011` | `01010` | `11110` |         | `0x008` | `000`    |          |
| `addi x31, x10, 0` | `010011` | `01010` | `11111` |         | `0x000` | `000`    |          |
| `sd x31, 0(x30)`   | `100011` | `11110` |         | `11111` | `0x000` | `011`    |          |
| `ld x30, 0(x30)`   | `000011` | `11110` | `11110` |         | `0x000` | `011`    |          |
| `add x5, x30, x31` | `110011` | `11110` | `00110` | `11111` |         | `000`    | `000`    |

## 2.16

### 2.16.1

`funct7`, `funct3`, `opcode`: These bit fields might increase in size to accommodate the four times as many instructions.

`rs2`, `rs1`, `rd`: These bit fields should increase from 5 bits to 7 bits for the 128 registers.

### 2.16.2

`funct3`, `opcode`: These bit fields might increase in size to accommodate the four times as many instructions.

`rs1`, `rd`: These bit fields should increase from 5 bits to 7 bits for the 128 registers.

`imm`: This field doesn't need to change, because neither the number of registers or instructions have to do with `imm`.

### 2.16.3

Decrease in size: Because there are more registers and more instructions, some old instructions can now be combined into just a single instruction.

Increase in size: Because instructions now takes up more bits, for simple tasks that doesn't use many registers, the extra bits are wasted and take up unnecessary spaces.



