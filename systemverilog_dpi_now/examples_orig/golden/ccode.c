
#include <stdio.h>
#include "svdpi.h"

#include "dpiheader.h"

#define MAX 10

static
int
c_task(int inp1, int inp2, int *c_answer)
{
    *c_answer = inp1 * inp2;
}

static
int
c_compare(int inp1, int inp2)
{
    int c_answer, vl_answer;

    vl_task(inp1, inp2, &vl_answer);
     c_task(inp1, inp2, & c_answer);

    if (c_answer != vl_answer) {
        vpi_printf("Error: MISMATCH (%d, %d) vl<%d> != c<%d>\n",
                inp1, inp2, vl_answer, c_answer);
    }
}

int
c_test()
{
    int inp1, inp2;

    vpi_printf("Running\n");
    for(inp1 = 0; inp1 < MAX; inp1++) {
      for(inp2 = 0; inp2 < MAX; inp2++) {
          c_compare(inp1, inp2);
      }
    }
    vpi_printf("...done.\n");
    return 0;
}

