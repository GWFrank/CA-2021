.global matrix_mul
.type matrix_mul, %function

.align 2
# void matrix_mul(unsigned int A[][], unsigned int B[][], unsinged int C[][]);
matrix_mul:
    
    # insert code here
    # Green card here: https://www.cl.cam.ac.uk/teaching/1617/ECAD+Arch/files/docs/RISCVGreenCardv8-20151013.pdf
    # Matrix multiplication: https://en.wikipedia.org/wiki/Matrix_multiplication
    # save reg val
    addi sp, sp, -120
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
    sd gp, 96(sp)
    sd tp, 104(sp)
    sd ra, 112(sp)
    
    addi a3, zero, 256 # size of a row
    # addi t4, zero, 1
    # slli t4, t4, 15 # (128*128)*2 bytes
    # addi t4, t4, -8
    add gp, zero, zero
    add tp, zero, zero
    add t0, zero, zero # i=0
loopi:
    addi sp, sp, -2
    sh t0, 0(sp)
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
    add t2, zero, zero # acc20
    add t3, zero, zero # acc21
    add t4, zero, zero # acc22
    add t5, zero, zero # acc23
    add t6, zero, zero # acc30
    add s10, zero, zero # acc31
    add s11, zero, zero # acc32
    add a3, zero, zero # acc33
    add ra, zero, zero # k=0
loopk:
    lhu s4, 0(a0) # s4 = *(a0) = A[i][k]
    lhu s5, 256(a0) # s5 = *(a0+256B) = A[i+1][k]
    lhu gp, 512(a0) # gp = A[i+2][k]
    lhu tp, 768(a0) # tp = A[i+3][k]
    lhu s6, 0(a1) # s6 = *(a1) = B[k][j]
    lhu s7, 2(a1) # s7 = *(a1+2B) = B[k][j+1]
    lhu s8, 4(a1) # s8 = *(a1+4B) = B[k][j+2]
    lhu s9, 6(a1) # s9 = *(a1+6B) = B[k][j+3]

    mulw t0, s4, s6 # A[i][k]*B[k][j]
    addw s0, s0, t0 # acc00 += A[i][k]*B[k][j]
    mulw t0, s4, s7 # A[i][k]*B[k][j+1]
    addw s1, s1, t0 # acc01 += A[i][k]*B[k][j+1]
    mulw t0, s4, s8 # A[i][k]*B[k][j+2]
    addw s2, s2, t0 # acc02 += A[i][k]*B[k][j+2]
    mulw t0, s4, s9 # A[i][k]*B[k][j+3]
    addw s3, s3, t0 # acc03 += A[i][k]*B[k][j+3]

    mulw t0, s5, s6 # A[i+1][k]*B[k][j]
    addw a4, a4, t0 # acc10 += A[i+1][k]*B[k][j]
    mulw t0, s5, s7 # A[i+1][k]*B[k][j+1]
    addw a5, a5, t0 # acc11 += A[i+1][k]*B[k][j+1]
    mulw t0, s5, s8 # A[i+1][k]*B[k][j+2]
    addw a6, a6, t0 # acc12 += A[i+1][k]*B[k][j+2]
    mulw t0, s5, s9 # A[i+1][k]*B[k][j+3]
    addw a7, a7, t0 # acc13 += A[i+1][k]*B[k][j+3]

    mulw t0, gp, s6 # A[i+2][k]*B[k][j]
    addw t2, t2, t0 # acc20 += A[i+2][k]*B[k][j]
    mulw t0, gp, s7 # A[i+2][k]*B[k][j+1]
    addw t3, t3, t0 # acc21 += A[i+2][k]*B[k][j+1]
    mulw t0, gp, s8 # A[i+2][k]*B[k][j+2]
    addw t4, t4, t0 # acc22 += A[i+2][k]*B[k][j+2]
    mulw t0, gp, s9 # A[i+2][k]*B[k][j+3]
    addw t5, t5, t0 # acc23 += A[i+2][k]*B[k][j+3]

    mulw t0, tp, s6 # A[i+3][k]*B[k][j]
    addw t6, t6, t0 # acc30 += A[i+3][k]*B[k][j]
    mulw t0, tp, s7 # A[i+3][k]*B[k][j+1]
    addw s10, s10, t0 # acc31 += A[i+3][k]*B[k][j+1]
    mulw t0, tp, s8 # A[i+3][k]*B[k][j+2]
    addw s11, s11, t0 # acc32 += A[i+3][k]*B[k][j+2]
    mulw t0, tp, s9 # A[i+3][k]*B[k][j+3]
    addw a3, a3, t0 # acc33 += A[i+3][k]*B[k][j+3]

    lhu s4, 2(a0) # s4 = A[i][k+1]
    lhu s5, 258(a0) # s5 = A[i+1][k+1]
    lhu gp, 514(a0) # gp = A[i+2][k+1]
    lhu tp, 770(a0) # tp = A[i+3][k+1]
    lhu s6, 256(a1) # s6 = B[k+1][j]
    lhu s7, 258(a1) # s7 = B[k+1][j+1]
    lhu s8, 260(a1) # s8 = B[k+1][j+2]
    lhu s9, 262(a1) # s9 = B[k+1][j+3]

    mulw t0, s4, s6
    addw s0, s0, t0
    mulw t0, s4, s7
    addw s1, s1, t0
    mulw t0, s4, s8
    addw s2, s2, t0
    mulw t0, s4, s9
    addw s3, s3, t0

    mulw t0, s5, s6
    addw a4, a4, t0
    mulw t0, s5, s7
    addw a5, a5, t0
    mulw t0, s5, s8
    addw a6, a6, t0
    mulw t0, s5, s9
    addw a7, a7, t0

    mulw t0, gp, s6
    addw t2, t2, t0
    mulw t0, gp, s7
    addw t3, t3, t0
    mulw t0, gp, s8
    addw t4, t4, t0
    mulw t0, gp, s9
    addw t5, t5, t0

    mulw t0, tp, s6
    addw t6, t6, t0
    mulw t0, tp, s7
    addw s10, s10, t0
    mulw t0, tp, s8
    addw s11, s11, t0
    mulw t0, tp, s9
    addw a3, a3, t0
    
    addi a0, a0, 4 # a_ptr += 2
    addi a1, a1, 512 # b_ptr += 256
    addi ra, ra, 4 # k += 4 bytes (2 short)
    addi t0, zero, 256
    blt ra, t0, loopk # continue loop if k < row_size
# end loopk
    andi s0, s0, 1023
    andi s1, s1, 1023
    andi s2, s2, 1023
    andi s3, s3, 1023
    andi a4, a4, 1023
    andi a5, a5, 1023
    andi a6, a6, 1023
    andi a7, a7, 1023
    andi t2, t2, 1023
    andi t3, t3, 1023
    andi t4, t4, 1023
    andi t5, t5, 1023
    andi t6, t6, 1023
    andi s10, s10, 1023
    andi s11, s11, 1023
    andi a3, a3, 1023

    sh s0, 0(a2) # C[i][j] = acc00
    sh s1, 2(a2) # C[i][j+1] = acc01
    sh s2, 4(a2) # C[i][j+2] = acc02
    sh s3, 6(a2) # C[i][j+3] = acc03
    sh a4, 256(a2) # C[i+1][j] = acc10
    sh a5, 258(a2) # C[i+1][j+1] = acc11
    sh a6, 260(a2) # C[i+1][j+2] = acc12
    sh a7, 262(a2) # C[i+1][j+3] = acc13
    sh t2, 512(a2)
    sh t3, 514(a2)
    sh t4, 516(a2)
    sh t5, 518(a2)
    sh t6, 768(a2)
    sh s10, 770(a2)
    sh s11, 772(a2)
    sh a3, 774(a2)

    addi a0, a0, -256 # a_ptr += -128
    addi t0, zero, 1
    slli t0, t0, 15 # (128*128)*2 bytes
    addi t0, t0, -8
    sub a1, a1, t0 # b_ptr -= 128*128-4
    addi a2, a2, 8 # c_ptr += 4
    addi t1, t1, 8 # j += 8 bytes (4 shorts)
    
    addi t0, zero, 256
    blt t1, t0, loopj # continue loop if j < row_size
# end loopj

    addi a0, a0, 1024 # a_ptr += 512
    addi a1, a1, -256 # b_ptr -=128
    add a2, a2, 768 # c_ptr += 512-128

    lh t0, 0(sp)
    addi sp, sp, 2
    addi t0, t0, 8 # i += 8 bytes (4 shorts)
    addi s4, zero, 256
    blt t0, s4, loopi # continue loop if i < row_size
# end loopi

    # restore reg val
    ld ra, 112(sp)
    ld tp, 104(sp)
    ld gp, 96(sp)
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
    addi sp, sp, 120
    
    ret
