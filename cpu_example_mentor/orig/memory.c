#include <stdio.h>
#include "risc.h"

void C_init_mem(int index, int data) {
  
  /* Push C import context */
  svScope svScope = svGetScope();
  /* Set export context for shared memory */
  svSetScope(svGetScopeFromName("system.m1"));

  /* Call exported Vrilog task */
  V_init_mem(index,data);

  /* Pop C import context */
  svSetScope(svScope);
}








