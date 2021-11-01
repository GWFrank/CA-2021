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
    // matrix_mul(A, B, C);
    unsigned short *a_ptr=A, *b_ptr=B, *c_ptr=C;
    for (int i=0; i<128; i+=4) {
        for (int j=0; j<128; j+=4) {
            int acc00=0, acc01=0, acc02=0, acc03=0;
            int acc10=0, acc11=0, acc12=0, acc13=0;
            int acc20=0, acc21=0, acc22=0, acc23=0;
            int acc30=0, acc31=0, acc32=0, acc33=0;
            for (int k=0; k<128; k+=2) {
                acc00 = (acc00+(*(b_ptr))*(*(a_ptr))); acc00 = (acc00+(*(b_ptr+128))*(*(a_ptr+1)));
                acc01 = (acc01+(*(b_ptr+1))*(*(a_ptr))); acc01 = (acc01+(*(b_ptr+129))*(*(a_ptr+1)));
                acc02 = (acc02+(*(b_ptr+2))*(*(a_ptr))); acc02 = (acc02+(*(b_ptr+130))*(*(a_ptr+1)));
                acc03 = (acc03+(*(b_ptr+3))*(*(a_ptr))); acc03 = (acc03+(*(b_ptr+131))*(*(a_ptr+1)));

                acc10 = (acc10+(*(b_ptr))*(*(a_ptr+128))); acc10 = (acc10+(*(b_ptr+128))*(*(a_ptr+129)));
                acc11 = (acc11+(*(b_ptr+1))*(*(a_ptr+128))); acc11 = (acc11+(*(b_ptr+129))*(*(a_ptr+129)));
                acc12 = (acc12+(*(b_ptr+2))*(*(a_ptr+128))); acc12 = (acc12+(*(b_ptr+130))*(*(a_ptr+129)));
                acc13 = (acc13+(*(b_ptr+3))*(*(a_ptr+128))); acc13 = (acc13+(*(b_ptr+131))*(*(a_ptr+129)));
                
                acc20 = (acc20+(*(b_ptr))*(*(a_ptr+256))); acc20 = (acc20+(*(b_ptr+128))*(*(a_ptr+257)));
                acc21 = (acc21+(*(b_ptr+1))*(*(a_ptr+256))); acc21 = (acc21+(*(b_ptr+129))*(*(a_ptr+257)));
                acc22 = (acc22+(*(b_ptr+2))*(*(a_ptr+256))); acc22 = (acc22+(*(b_ptr+130))*(*(a_ptr+257)));
                acc23 = (acc23+(*(b_ptr+3))*(*(a_ptr+256))); acc23 = (acc23+(*(b_ptr+131))*(*(a_ptr+257)));
                
                acc30 = (acc30+(*(b_ptr))*(*(a_ptr+384))); acc30 = (acc30+(*(b_ptr+128))*(*(a_ptr+385)));
                acc31 = (acc31+(*(b_ptr+1))*(*(a_ptr+384))); acc31 = (acc31+(*(b_ptr+129))*(*(a_ptr+385)));
                acc32 = (acc32+(*(b_ptr+2))*(*(a_ptr+384))); acc32 = (acc32+(*(b_ptr+130))*(*(a_ptr+385)));
                acc33 = (acc33+(*(b_ptr+3))*(*(a_ptr+384))); acc33 = (acc33+(*(b_ptr+131))*(*(a_ptr+385)));

                a_ptr += 2;
                b_ptr += 256;
            }
            *c_ptr = acc00%1024; *(c_ptr+1) = acc01%1024; *(c_ptr+2) = acc02%1024; *(c_ptr+3) = acc03%1024;
            *(c_ptr+128) = acc10%1024; *(c_ptr+129) = acc11%1024; *(c_ptr+130) = acc12%1024; *(c_ptr+131) = acc13%1024;
            *(c_ptr+256) = acc20%1024; *(c_ptr+257) = acc21%1024; *(c_ptr+258) = acc22%1024; *(c_ptr+259) = acc23%1024;
            *(c_ptr+384) = acc30%1024; *(c_ptr+385) = acc31%1024; *(c_ptr+386) = acc32%1024; *(c_ptr+387) = acc33%1024;
            a_ptr -= 128;
            b_ptr -= 16384;
            b_ptr += 4;
            c_ptr += 4;
        }
        a_ptr += 512;
        // a_ptr += 256;
        b_ptr -= 128;
        c_ptr -= 128;
        c_ptr += 512;
        // c_ptr += 256;
    }
    
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
