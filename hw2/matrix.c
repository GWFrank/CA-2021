int main() {
    unsigned short *a_ptr=A, *b_ptr=B, *c_ptr=C;
    for (int i=0; i<128; i+=2) {
        for (int j=0; j<128; j+=4) {
            int acc00=0, acc01=0, acc02=0, acc03=0;
            int acc10=0, acc11=0, acc12=0, acc13=0;
            for (int k=0; k<128; k+=2) {
                acc00 = (acc00+(*(b_ptr))*(*(a_ptr)))%1024; acc00 = (acc00+(*(b_ptr+128))*(*(a_ptr+1)))%1024;
                acc01 = (acc01+(*(b_ptr+1))*(*a_ptr))%1024; acc01 = (acc01+(*(b_ptr+129))*(*(a_ptr+1)))%1024;
                acc02 = (acc02+(*(b_ptr+2))*(*a_ptr))%1024; acc02 = (acc02+(*(b_ptr+130))*(*(a_ptr+1)))%1024;
                acc03 = (acc03+(*(b_ptr+3))*(*a_ptr))%1024; acc03 = (acc03+(*(b_ptr+131))*(*(a_ptr+1)))%1024;
                acc10 = (acc10+(*(b_ptr))*(*(a_ptr+128)))%1024; acc10 = (acc10+(*(b_ptr+128))*(*(a_ptr+129)))%1024;
                acc11 = (acc11+(*(b_ptr+1))*(*(a_ptr+128)))%1024; acc11 = (acc11+(*(b_ptr+129))*(*(a_ptr+129)))%1024;
                acc12 = (acc12+(*(b_ptr+2))*(*(a_ptr+128)))%1024; acc12 = (acc12+(*(b_ptr+130))*(*(a_ptr+129)))%1024;
                acc13 = (acc13+(*(b_ptr+3))*(*(a_ptr+128)))%1024; acc13 = (acc13+(*(b_ptr+131))*(*(a_ptr+129)))%1024;
                
                a_ptr += 2;
                b_ptr += 256;
            }
            *c_ptr = acc00; *(c_ptr+1) = acc01;
            *(c_ptr+2) = acc02; *(c_ptr+3) = acc03;
            *(c_ptr+128) = acc10; *(c_ptr+129) = acc11;
            *(c_ptr+130) = acc12; *(c_ptr+131) = acc13;
            a_ptr -= 128;
            b_ptr -= 16384;
            b_ptr += 4;
            c_ptr += 4;
        }
        a_ptr += 256;
        b_ptr -= 128;
        c_ptr -= 128;
        c_ptr += 256;
    }


    unsigned short *a_ptr=A, *b_ptr=B, *c_ptr=C;
    for (int i=0; i<128; i+=2) {
        for (int j=0; j<128; j+=2) {
            int acc00=0, acc01=0, acc10=0, acc11=0;
            for (int k=0; k<128; k+=2) {
                acc00 = (acc00+(*(b_ptr))*(*(a_ptr)))%1024; acc00 = (acc00+(*(b_ptr+128))*(*(a_ptr+1)))%1024;
                acc01 = (acc01+(*(b_ptr+1))*(*(a_ptr)))%1024; acc01 = (acc01+(*(b_ptr+129))*(*(a_ptr+1)))%1024;
                acc10 = (acc10+(*(b_ptr))*(*(a_ptr+128)))%1024; acc10 = (acc10+(*(b_ptr+128))*(*(a_ptr+129)))%1024;
                acc11 = (acc11+(*(b_ptr+1))*(*(a_ptr+128)))%1024; acc11 = (acc11+(*(b_ptr+129))*(*(a_ptr+129)))%1024;
                a_ptr += 2;
                b_ptr += 256;
            }
            *(c_ptr) = acc00;
            *(c_ptr+1) = acc01;
            *(c_ptr+128) = acc10;
            *(c_ptr+129) = acc11;
            a_ptr -= 128;
            b_ptr -= 16384;
            b_ptr += 2;
            c_ptr += 2;
        }
        a_ptr += 256;
        b_ptr -= 128;
        c_ptr -= 128;
        c_ptr += 256;
    }
    // for (int i=0; i<128; i+=2) {
    //     for (int j=0; j<128; j+=2) {
    //         int acc00=0, acc01=0, acc10=0, acc11=0;
    //         for (int k=0; k<128; k+=1) {
    //             acc00 = (acc00+(*(b_ptr))*(*(a_ptr)))%1024;
    //             acc01 = (acc01+(*(b_ptr+1))*(*(a_ptr)))%1024;
    //             acc10 = (acc10+(*(b_ptr))*(*(a_ptr+128)))%1024;
    //             acc11 = (acc11+(*(b_ptr+1))*(*(a_ptr+128)))%1024;
    //             a_ptr += 1;
    //             b_ptr += 128;
    //         }
    //         *(c_ptr) = acc00;
    //         *(c_ptr+1) = acc01;
    //         *(c_ptr+128) = acc10;
    //         *(c_ptr+129) = acc11;
    //         a_ptr -= 128;
    //         b_ptr -= 16384;
    //         b_ptr += 2;
    //         c_ptr += 2;
    //     }
    //     a_ptr += 256;
    //     b_ptr -= 128;
    //     c_ptr -= 128;
    //     c_ptr += 256;
    // }
    return 0;
}