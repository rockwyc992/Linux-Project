#include <stdio.h>
#include <linux/kernel.h>
#include <sys/syscall.h>
#include <unistd.h>

#define  SIZE   1000000

void address_space_survey(int a, int b, int *c) {
    syscall(400, a, b, c);
}

int      p[SIZE]; 

void main()
{ 
    int      result[1024];

    printf("Hello World!\n");
    address_space_survey(0,767, &p); 
    address_space_survey(768,1023, &p); 
    printf("%p\n", &p);
} 
