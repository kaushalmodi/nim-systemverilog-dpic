
#include <stdio.h>
#include "svdpi.h"

#include "dpiheader.h"

short mem[4096];

int
c_store(int addr, short data)
{
    vl_posedge_clk();
    mem[addr] = data;

    return 0;
}

int
c_retrieve(int addr, short *data)
{
    vl_posedge_clk();
    *data = mem[addr];

    return 0;
}

