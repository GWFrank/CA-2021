.global convert
.type matrix_mul, %function

.align 2
# int convert(char *);
convert:
    # insert your code here
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    add t0, zero, a0 # t0 = save adress
    lbu t1, 0(t0) # t1 = char val
    add t3, zero, zero # t3 = sign
    add t4, zero, zero # t4 = converted int
    addi t5, zero, 10; # t5 = 10 (base)
    addi t2, zero, 45 # '-'
    beq t1, t2, negative
    addi t2, zero, 43 # '+'
    beq t1, t2, c1
    beq zero, zero, loop
negative:
    addi t3, zero, 1
c1:
    addi t0, t0, 1
loop:
    lbu t1, 0(t0)
    beq t1, zero, exit
    addi t2, zero, 57 # t2 = '9'
    bltu t2, t1, not_int
    addi t2, zero, 48 # t2 = '0'
    bltu t1, t2, not_int
    sub t1, t1, t2 # t1 -= '0'
    mul t4, t4, t5 # t4 *= 10
    add t4, t4, t1 # t4 += t1
    addi t0, t0, 1
    beq zero, zero, loop
exit:
    add a0, zero, t4
    beq t3, zero, c2
    addi t0, zero, -1
    mul a0, a0, t0
c2:
    ret
not_int:
    addi a0, zero, -1 # '-'
    ret

