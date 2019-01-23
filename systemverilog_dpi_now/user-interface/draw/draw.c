/* 
 * Borrowed from the EGGX sample distribution
 *   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
 */

/* --------------------------------------------------------- */
#include <math.h>
#include "eggx.h"

#include "draw.h"
#define MYCOLOR    DS9_B

static int Gwin = 0;

int
draw_init(int width, int height)
{
    int win;

    gsetinitialparsegeometry("%+d%+d", Gwin * (200 + 10), 0);

    win = gopen(width, height);
    layer(win, 0, 1);

    Gwin = win;
    return win;
}

void
draw_clear(int win)
{
    gclr(win);
}

void
draw_title(int win, const char *label)
{
    winname(win, label); 
}


void
draw_pixel(int win, int x, int y, int n, 
    int minlimit, int maxlimit)
{
    static int first = 1;
    static float MINL, MAXL;

    int color_r, color_g, color_b;

    if (first) {
        MINL = log((double)minlimit);
        MAXL = log((double)maxlimit);
        first = 0;
    }

    makecolor(MYCOLOR, (float)MINL, (float)MAXL, (float)log(n),
      &color_r, &color_g, &color_b);
    newrgbcolor(win, color_r, color_g, color_b);
    pset(win, x, y);
}

void
draw_flush(int win)
{
    copylayer(win, 1, 0);
}

void
draw_finish(int win)
{
    draw_flush(win);
    // ggetch(win);
}
