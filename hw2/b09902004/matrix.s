.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    # Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
    # save reg val
    addi sp, sp, -96
    sd s0, 0(sp)
    sd s1, 8(sp)
    sd s2, 16(sp)
    sd s3, 24(sp)
    sd s4, 32(sp)
    sd s5, 40(sp)
    sd s6, 48(sp)
    sd s7, 56(sp)
    sd s8, 64(sp)
    sd s9, 72(sp)
    sd s10, 80(sp)
    sd s11, 88(sp)
    
    addi a3, zero, 256 # size of a row
    add s10, zero, a0 # s10 = &A = a_ptr
    add s11, zero, a1 # s11 = &B = b_ptr
    addi t4, zero, 1;
    slli t4, t4, 15; # (128*128)*2 bytes
    add t0, zero, zero # i=0
loopi:
    add t1, zero, zero # j=0
loopj:
    add s0, zero, zero # acc00
    add s1, zero, zero # acc01
    add s2, zero, zero # acc02
    add s3, zero, zero # acc03
    add a4, zero, zero # acc10
    add a5, zero, zero # acc11
    add a6, zero, zero # acc12
    add a7, zero, zero # acc13
    add t2, zero, zero # k=0
loopk:
    lhu s5, 256(s10) # s5 = *(s10+256B) = A[i+1][k]
    lhu s4, 0(s10) # s4 = *(s10) = A[i][k]
    lhu s9, 6(s11) # s9 = *(s11+6B) = B[k][j+3]
    lhu s8, 4(s11) # s8 = *(s11+4B) = B[k][j+2]
    lhu s7, 2(s11) # s7 = *(s11+2B) = B[k][j+1]
    lhu s6, 0(s11) # s6 = *(s11) = B[k][j]

    mulw t3, s4, s6 # A[i][k]*B[k][j]
    addw s0, s0, t3 # acc00 += A[i][k]*B[k][j]
    andi s0, s0, 1023 # acc00 = acc00%1024 = last 10 bits
    mulw t3, s4, s7 # A[i][k]*B[k][j+1]
    addw s1, s1, t3 # acc01 += A[i][k]*B[k][j+1]
    andi s1, s1, 1023 # acc01 = acc01%1024 = last 10 bits
    mulw t3, s4, s8 # A[i][k]*B[k][j+2]
    addw s2, s2, t3 # acc02 += A[i][k]*B[k][j+2]
    andi s2, s2, 1023 # acc02 = acc02%1024 = last 10 bits
    mulw t3, s4, s9 # A[i][k]*B[k][j+3]
    addw s3, s3, t3 # acc03 += A[i][k]*B[k][j+3]
    andi s3, s3, 1023 # acc03 = acc03%1024 = last 10 bits

    mulw t3, s5, s6 # A[i+1][k]*B[k][j]
    addw a4, a4, t3 # acc10 += A[i+1][k]*B[k][j]
    andi a4, a4, 1023 # acc10 = acc10%1024 = last 10 bits
    mulw t3, s5, s7 # A[i+1][k]*B[k][j+1]
    addw a5, a5, t3 # acc11 += A[i+1][k]*B[k][j+1]
    andi a5, a5, 1023 # acc11 = acc11%1024 = last 10 bits
    mulw t3, s5, s8 # A[i+1][k]*B[k][j+2]
    addw a6, a6, t3 # acc12 += A[i+1][k]*B[k][j+2]
    andi a6, a6, 1023 # acc12 = acc12%1024 = last 10 bits
    mulw t3, s5, s9 # A[i+1][k]*B[k][j+3]
    addw a7, a7, t3 # acc13 += A[i+1][k]*B[k][j+3]
    andi a7, a7, 1023 # acc13 = acc13%1024 = last 10 bits
    
    addi s10, s10, 2 # a_ptr += 1
    addi s11, s11, 256 # b_ptr += 128
    addi t2, t2, 2 # k += 2 bytes (1 short)
    blt t2, a3, loopk # continue loop if k < row_size
# end loopk

    sh s0, 0(a2) # C[i][j] = acc00
    sh s1, 2(a2) # C[i][j+1] = acc01
    sh s2, 4(a2) # C[i][j+2] = acc02
    sh s3, 6(a2) # C[i][j+3] = acc03
    sh a4, 256(a2) # C[i+1][j] = acc10
    sh a5, 258(a2) # C[i+1][j+1] = acc11
    sh a6, 260(a2) # C[i+1][j+2] = acc12
    sh a7, 262(a2) # C[i+1][j+3] = acc13

    addi s10, s10, -256 # a_ptr += -128
    sub s11, s11, t4 # b_ptr -= 128*128
    addi s11, s11, 8 # b_ptr += 4
    addi a2, a2, 8 # c_ptr += 4
    addi t1, t1, 8 # j += 8 bytes (4 shorts)
    blt t1, a3, loopj # continue loop if j < row_size
# end loopj

    addi s10, s10, 512 # a_ptr += 256
    add s11, zero, a1 # b_ptr = B
    add a2, a2, 256 # c_ptr += 128
    addi t0, t0, 4 # i += 4 bytes (2 shorts)
    blt t0, a3, loopi # continue loop if i < row_size
# end loopi

    # restore reg val
    ld s11, 88(sp)
    ld s10, 80(sp)
    ld s9, 72(sp)
    ld s8, 64(sp)
    ld s7, 56(sp)
    ld s6, 48(sp)
    ld s5, 40(sp)
    ld s4, 32(sp)
    ld s3, 24(sp)
    ld s2, 16(sp)
    ld s1, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 96
    
    ret
