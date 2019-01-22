
#include <stdio.h>
#include "svdpi.h"

#include "dpiheader.h"

/* 
 * Adapted from the EGGX sample distribution
 *   http://phe.phyas.aichi-edu.ac.jp/~cyamauch/eggx_procall
 */

/* --------------------------------------------------------- */
#define THRES      4.0
#define LIMIT      1000
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

int
c_mandel(
    int width, int height, 
    double xstart, double xend, double ystart, double yend)
{
    int cnt;
    double xreal, yreal, xstep, ystep;
    int modn;
    int n, x, y;
    double p;
    int m;
    int win;
    char label[1024];
    const char *l;

    win = draw_init(width, height);
    sprintf(label, "C(win=%d) IMG(%g, %g) (%g, %g)",
            win, xstart, ystart, xend, yend);

    l = label;
    draw_title(win, l);

    xstep = (xend - xstart) / width;
    ystep = (yend - ystart) / height;

    modn = width / 20;
    cnt = 3;
    while(cnt--) {
        yreal = ystart;
        for(y = 0; y < height; y++){
            xreal = xstart;
            for(x = 0; x < width; x++){
                if ((n = get_mandel(xreal, yreal)) > 0) {
                    draw_pixel(win, x, y, n, 1, LIMIT);
                }
                xreal += xstep;
            }
            hw_sync(1);
            if ((y % modn) == 0) {
                draw_flush(win);
            }
            yreal += ystep;
        }
        draw_finish(win);
        hw_sync(200);
        draw_clear(win);
    }
    return 0;
}
