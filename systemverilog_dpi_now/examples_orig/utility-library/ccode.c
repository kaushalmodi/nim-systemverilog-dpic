#include <stdlib.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>

#include "mti.h"       /* To get mti_Malloc() */
#include "svdpi.h"     /* Standard DPI header */
#include "dpiheader.h" /* For interface matching. */

typedef struct rusage * rusagep;
typedef void          * chandle;

/* timer_new() - Malloc a new rusage structure. */
static rusagep
timer_new()
{
    return (rusagep)mti_Malloc(sizeof(struct rusage));
}

/*
 * timer_restart()
 *
 * Given an existing rusage structure, "refill" the
 * entries from now.
 */
static rusagep
timer_restart(rusagep p)
{
    if (getrusage(RUSAGE_SELF, p) != 0) {
        /* Error */
        perror("timer_restart()");
    }
    return p;
}

/*
 * timer_start()
 *
 * Create a new rusage, fill it in, and return a pointer to it.
 */
chandle
timer_start()
{
    rusagep p;

    p = timer_new();
    timer_restart(p);
    return p;
}

/* 
 * timer_split()
 *
 * Returns the number of useconds since either the start of the 
 * timer (*pp) or the last split time.
 *
 * The parameter "pp" will have its contents reset to the current
 * "rusage" at the end of this function. It is an inout.
 */
int64_t
timer_split(chandle *pp)
{
    int64_t seconds, useconds;
    struct rusage now, *p;

    p = *((rusagep *)pp);
    timer_restart(&now);

    seconds  = now.ru_utime.tv_sec  - p->ru_utime.tv_sec;
    useconds = now.ru_utime.tv_usec - p->ru_utime.tv_usec;
    if ( useconds < 0 ) {
        /* We need to borrow 1 seconds worth of microseconds. */
        if (seconds > 0) {
            seconds -= 1;
            useconds += 1000000;
        } else {
            /* Error? Or just a clock rounding error? Call it ZERO. */
            seconds = 0;
            useconds = 0;
        }
    }
    useconds = seconds * 1000000 + useconds;
    timer_restart(p); /* Reset the timer for the next split */
    return useconds;
}

