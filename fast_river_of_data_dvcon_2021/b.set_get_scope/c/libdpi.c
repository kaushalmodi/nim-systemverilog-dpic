#include "svdpi.h"

// Keeping the same name as in libdpi.nim as the tb.sv does import
// "DPI-C" of f_scopetest_nim.
void f_scopetest_nim() {
    f_scopetest_c();
}

void f_scopetest_c() {
    char *origScopeName;
    svScope scope, prevScope; // svdpi.h: void*

    scope = svGetScope();
    origScopeName = svGetNameFromScope(scope);
    printf("Hello from f_scopetest_c(), scope = %s\n", origScopeName);
    f_scopetest_sv();

    // Try OTHER scopes
    scope = svGetScopeFromName("top.u_other_module");
    prevScope = svSetScope(scope);
    printf("f_scopetest_c: Switched from %s to %s\n", svGetNameFromScope(prevScope), svGetNameFromScope(scope));
    f_scopetest_sv();

    // Go back to THIS scope
    scope = svGetScopeFromName(origScopeName);
    prevScope = svSetScope(scope);
    printf("f_scopetest_c: Switched from %s to %s\n", svGetNameFromScope(prevScope), svGetNameFromScope(scope));
    f_scopetest_sv();
}
