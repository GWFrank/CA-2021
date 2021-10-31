#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <time.h>
#define MOD 1024
#define SIZE 128

void matrix_mul(unsigned short (*)[SIZE], unsigned short (*)[SIZE], unsigned short (*)[SIZE]);

int main () {
    unsigned short A[SIZE][SIZE], B[SIZE][SIZE], C[SIZE][SIZE];
    unsigned long long start, end;

    srand(time(NULL));

    // init
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            A[i][j] = rand() % MOD;

    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            B[i][j] = rand() % MOD;

    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            C[i][j] = 0;


    asm volatile ("rdcycle %0" : "=r" (start));
    matrix_mul(A, B, C);
    // unsigned short *a_ptr=A, *b_ptr=B, *c_ptr=C;
    // for (int i=0; i<SIZE; i+=2) {
    //     for (int j=0; j<SIZE; j+=4) {
    //         int acc00=0, acc01=0, acc02=0, acc03=0;
    //         int acc10=0, acc11=0, acc12=0, acc13=0;
    //         for (int k=0; k<SIZE; k++) {
    //             acc00 = (acc00+(*b_ptr)*(*a_ptr))%MOD;
    //             acc01 = (acc01+(*(b_ptr+1))*(*a_ptr))%MOD;
    //             acc02 = (acc02+(*(b_ptr+2))*(*a_ptr))%MOD;
    //             acc03 = (acc03+(*(b_ptr+3))*(*a_ptr))%MOD;
    //             acc10 = (acc10+(*b_ptr)*(*(a_ptr+128)))%MOD;
    //             acc11 = (acc11+(*(b_ptr+1))*(*(a_ptr+128)))%MOD;
    //             acc12 = (acc12+(*(b_ptr+2))*(*(a_ptr+128)))%MOD;
    //             acc13 = (acc13+(*(b_ptr+3))*(*(a_ptr+128)))%MOD;
    //             a_ptr += 1;
    //             b_ptr += 128;
    //         }
    //         C[i+0][j+0] = acc00; C[i+0][j+1] = acc01; C[i+0][j+2] = acc02; C[i+0][j+3] = acc03;
    //         C[i+1][j+0] = acc10; C[i+1][j+1] = acc11; C[i+1][j+2] = acc12; C[i+1][j+3] = acc13;
    //         a_ptr -= 128;
    //         b_ptr -= 16384;
    //         b_ptr += 4;
    //         c_ptr += 4;
    //     }
    //     a_ptr += 256;
    //     b_ptr = B;
    //     c_ptr += 128;
    // }
    
    asm volatile ("rdcycle %0" : "=r" (end));


    // check
    unsigned short check[SIZE][SIZE];
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            check[i][j] = 0;
    for (int i = 0; i < SIZE; i++)
        for (int j = 0; j < SIZE; j++)
            for (int k = 0; k < SIZE; k++)
                check[i][j] = (check[i][j] + A[i][k] * B[k][j]) % MOD;

    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            if (check[i][j] != C[i][j]) printf("%d, %d\n", i, j);
            assert(check[i][j] == C[i][j]);
        }
    }

    printf("Took %llu cycles\n", end - start);
}
