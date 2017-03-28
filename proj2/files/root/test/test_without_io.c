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
    int checkpoint = 1;
    unsigned int  i = 0;

    for(i = 1; i <= TOTAL_ITERATION_NUM; i++)
    { 
        /*just consume some CPU time*/
        j++;

        if(!(i % CHECKPOINT_LEN)) 
        { 
            /*In fact, printf() also makes some i/o*/
            printf("Have made context switches %d times at %dth checkpoint\n", num_context_switches(), checkpoint);
            checkpoint++;
        }
    }
    return 0;
}
