.global fibonacci
.type fibonacci, %function

.align 2
# unsigned long long int fibonacci(int n);
fibonacci:  
    
    # insert code here
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    add t4, zero, a0
    beq t4, zero, base_case_0
    addi t0, zero, 1
    beq t4, t0, base_case_1
    # t3 = t1 + t2
    add t1, zero, zero
    addi t2, zero, 1
DP:
    add t3, t1, t2
    add t1, zero, t2
    add t2, zero, t3
    addi t0, t0, 1 # t0 += 1
    bne t0, a0, DP
    add a0, zero, t3
    ret
base_case_0:
    add a0, zero, zero
    ret
base_case_1:
    add a0, zero, t0
    ret

    
