#include <stdio.h>
#include <stdlib.h>
#define SIZE 15

int convert(char *);
volatile int wait=1;
int main()
{
    char input[SIZE];
    int out;
#ifdef DEBUG
    while(wait);
#endif
    while (scanf("%s", input) != EOF) {
        out = convert(input);
	printf("%d\n", out);
    }
#ifdef DEBUG
    while(!wait);
#endif
    return 0;
}

