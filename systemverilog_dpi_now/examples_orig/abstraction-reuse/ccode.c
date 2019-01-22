#include <stdio.h>
#include "svdpi.h"

#include "dpiheader.h"

static int sw_matches, hw_matches, total_tries;

static int
c_task(int inp1, int inp2, int *c_answer)
{
    *c_answer = (inp1 + inp2) & 0x0f;
}

static int
c_compare(int inp1, int inp2)
{
    int c_answer, vl_answer, vl_hw_answer, vl_hw_gate_answer;

    c_task(inp1, inp2, & c_answer);
    t_add(&vl_hw_answer, inp1, inp2);

    if (c_answer == vl_hw_answer) {
        hw_matches++;
    } else {
        vpi_printf("Error: MISMATCH hw(%d, %d) vl<%d> != c<%d>\n",
                inp1, inp2, vl_hw_answer, c_answer);
    }
}

int
c_test()
{
    int inp1, inp2;

    vpi_printf("Running\n");
    sw_matches = hw_matches = total_tries = 0;
    for(inp1 = 0; inp1 < 16; inp1++) {
      for(inp2 = 0; inp2 < 16; inp2++) {
          c_compare(inp1, inp2);
          total_tries++;
      }
    }
    vpi_printf("%d/%d hw matches. done.\n", hw_matches, total_tries);
    return 0;
}
