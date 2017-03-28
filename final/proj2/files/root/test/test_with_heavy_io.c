#include <stdio.h>
#include <unistd.h>

#define TOTAL_ITERATION_NUM  100000000
#define CHECKPOINT_LEN       5000000 

int num_context_switches() 
{
    int result = 0;
    syscall(400, &result);
    return result;
}

int main()
{
    int j;
    int checkpoint = 0;
    unsigned int  i = 0;
    int output[20];

    for(i = 1; i <= TOTAL_ITERATION_NUM; i++) { 
        /*just consume some CPU time*/
        j++;

        if(!(i % CHECKPOINT_LEN)) { 
            /*In fact, printf() also makes some i/o*/
            output[checkpoint] = num_context_switches();
            checkpoint++;
        }
        getchar();
    }

    printf("[%d", output[0]);
    for(i = 1; i < checkpoint; i++ ) {
        printf(" %d", output[i]);
    }
    puts("]");
    
    return 0;
}
