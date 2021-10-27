#include <stdio.h>

unsigned long long int fibonacci(int);

volatile int wait=1;

int main () {
    unsigned long long int ret;
#ifdef DEBUG
    while (wait);
#endif
    for (int i = 0; i < 94; i++) {
        ret = fibonacci(i);
        printf("%llu\n", ret);
    }
#ifdef DEBUG
    while(!wait);
#endif
    return 0;
}
