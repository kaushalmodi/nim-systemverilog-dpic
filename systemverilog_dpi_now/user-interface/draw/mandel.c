/* egg mandel.c -o mandel -O2 -Wall */
/*
 * Borrowed from the EGGX sample distribution
 *   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
 */

#include <unistd.h>
#include "draw.h"

/* --------------------------------------------------------- */
#define WIN_WIDTH  200
#define WIN_HEIGHT 200

#define XSCALE     1.0
#define YSCALE     1.0
#define REALBEGIN  0.075    /* -2.0 */
#define REALEND    0.175    /* 0.5 */
#define IMAGIBEGIN 0.59        /* -1.25 */
#define IMAGIEND   0.69        /* 1.25 */

#define THRES      4.0
#define LIMIT      1000        /* 100 */

/* --------------------------------------------------------- */

int
get_mandel(double c_real, double c_imaginary)
{
    int i;
    double xsq, ysq, tmp, re = 0, im = 0;
    for (i = 0; i < LIMIT; i++){
        if(((xsq = re * re) + (ysq = im * im)) > THRES)
            break;
        tmp = xsq - ysq + c_real;
        im = 2 * re * im + c_imaginary;
        re = tmp;
    }
    if (i == LIMIT)
        return 0;
    else
        return i;
}

int main()
{
    int n, x, y;
    double xreal, yreal, xstep, ystep;
    int win;
    char label[1024];

    sprintf(label, "IMG(%g, %g) (%g, %g)",
        REALBEGIN, IMAGIBEGIN, REALEND, IMAGIEND);

    win = draw_init(WIN_WIDTH, WIN_HEIGHT);
    printf("win=%d\n", win);
    draw_title(win, label);

    xstep = XSCALE * ( REALEND -  REALBEGIN) / WIN_WIDTH;
    ystep = YSCALE * (IMAGIEND - IMAGIBEGIN) / WIN_HEIGHT;

    yreal = IMAGIBEGIN;
    for(y = 0; y < WIN_HEIGHT; y++){
        xreal = REALBEGIN;
        for(x = 0; x < WIN_WIDTH; x++){
            if ((n = get_mandel(xreal, yreal)) > 0) {
                draw_pixel(win, x, y, n, 1, LIMIT);
            }
            xreal += xstep;
        }
        if ((y % 10) == 0) {
            draw_flush(win);
        }
        yreal += ystep;
    }
    sleep(5);
    draw_finish(win);
    return 0;
}
