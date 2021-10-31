.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    # Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
    # save reg val
    addi sp, sp, -64
    sd s0, 56(sp)
    sd s1, 48(sp)
    sd s2, 40(sp)
    sd s3, 32(sp)
    sd s4, 24(sp)
    sd s5, 16(sp)
    sd s6, 8(sp)
    sd s7, 0(sp)
    
    # addi a3, zero, 1023 # MOD (x%1024 = x&1023)
    addi a4, zero, 256 # size of a row
    addi a5, zero, 16 # ib

    add t4, zero, zero # ii=0
loopii:

    add t1, zero, zero # j=0
loopj:

    add t0, zero, t4 # i=ii
    # add t0, zero, zero # i=0
loopi:

    add s0, zero, zero # acc00
    add s1, zero, zero # acc01
    add s2, zero, zero # acc10
    add s3, zero, zero # acc11
    
    add t2, zero, zero # k=0
loopk:

    slli s4, t0, 7 # s4 = i*128 = i*2^7
    add s4, s4, a0 # s4 = &A[i]
    add s4, s4, t2 # s4 = &A[i][k]
    lhu s5, 256(s4) # s5 = *(s4 + 256 B) = A[i+1][k]
    lhu s4, 0(s4) # s4 = *(s4) = A[i][k]
    
    slli s6, t2, 7 # s6 = k*128 = k*2^7
    add s6, s6, a1 # s6 = &B[k]
    add s6, s6, t1 # s6 = &B[k][j]
    lhu s7, 2(s6) # s7 = *(s6 + 2 B) = B[k][j+1]
    lhu s6, 0(s6) # s6 = *(s6) = B[k][j]

    mulw t3, s4, s6 # A[i][k]*B[k][j]
    addw s0, s0, t3 # acc00 += A[i][k]*B[k][j]
    andi s0, s0, 1023 # acc00 = acc00%1024 = last 10 bits
    mulw t3, s4, s7 # A[i][k]*B[k][j+1]
    addw s1, s1, t3 # acc01 += A[i][k]*B[k][j+1]
    andi s1, s1, 1023 # acc01 = acc01%1024 = last 10 bits
    mulw t3, s5, s6 # A[i+1][k]*B[k][j]
    addw s2, s2, t3 # acc10 += A[i+1][k]*B[k][j]
    andi s2, s2, 1023 # acc10 = acc10%1024 = last 10 bits
    mulw t3, s5, s7 # A[i+1][k]*B[k][j+1]
    addw s3, s3, t3 # acc11 += A[i+1][k]*B[k][j+1]
    andi s3, s3, 1023 # acc11 = acc11%1024 = last 10 bits

    addi t2, t2, 2 # k += 2 bytes
    blt t2, a4, loopk # continue loop if k < row_size
# end loopk

    slli t3, t0, 7 # t3 = i*128 = i*2^7
    add t3, t3, a2 # t3 = &C[i]
    add t3, t3, t1 # t3 = &C[i][j]
    sh s0, 0(t3) # C[i][j] = acc00
    sh s1, 2(t3) # C[i][j+1] = acc01
    sh s2, 256(t3) # C[i+1][j] = acc10
    sh s3, 258(t3) # C[i+1][j+1] = acc11

    addi t0, t0, 4 # i += 4 bytes
    add t3, t4, a5 # t5=ii+ib
    blt t0, t3, loopi # continue loop if i < ii+ib
# end loopi

    addi t1, t1, 4 # j += 4 bytes
    blt t1, a4, loopj # continue loop if j < row_size
# end loopj

    add t4, t4, a5 # ii += ib
    blt t4, a4, loopii
# end loopii
    
    # restore reg val
    ld s7, 0(sp)
    ld s6, 8(sp)
    ld s5, 16(sp)
    ld s4, 24(sp)
    ld s3, 32(sp)
    ld s2, 40(sp)
    ld s1, 48(sp)
    ld s0, 56(sp)
    addi sp, sp, 64
    
    ret
