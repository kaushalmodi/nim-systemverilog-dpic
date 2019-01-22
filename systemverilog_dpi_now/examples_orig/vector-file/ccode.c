#include <stdio.h>
#include "svdpi.h"

#include "dpiheader.h"
#include "zlib.h"

#define LINE_MAX 1024

int
c_test()
{
    gzFile *f;
    int expected_answer, vl_answer;
    int tries, matches;

    int inp1, inp2;
    char line[LINE_MAX];
    char *fileName = "compressed.txt.gz";

    vpi_printf("Running\n");
    if ((f = gzopen(fileName, "rb")) == NULL) {
            fprintf(stderr, "c_test(): Error - cannot open file (%s)\n",
                    fileName);
            perror(fileName);
    }

    tries = matches = 0;
    while(!gzeof(f)) {
        gzgets(f, line, LINE_MAX);
        line[strlen(line)-1] = 0;
        sscanf(line, "%d %d %d", &inp1, &inp2, &expected_answer);
        vl_task(inp1, inp2, &vl_answer);
        tries ++;
        if (expected_answer != vl_answer) {
            vpi_printf("Error: MISMATCH (%d, %d) vl<%d> != c<%d>\n",
                    inp1, inp2, vl_answer, expected_answer);
        } else {
            matches++;
        }

    }
    vpi_printf("...done. %d/%d matches.\n", matches, tries);
    return 0;
}

