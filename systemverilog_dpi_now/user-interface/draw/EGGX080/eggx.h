/*
  EGGX / ProCALL  version 0.80
                        eggx.h
 */

#ifndef _EGGX_H
#define _EGGX_H

#include <eggxlib.h>

#define ggetdisplayinfo eggx_ggetdisplayinfo
#define gopen eggx_gopen
#define winname eggx_winname
#define window eggx_window
#define clsc_ clsc_
#define gclose eggx_gclose
#define gcloseall_ gcloseall_
#define newrgbcolor eggx_newrgbcolor
#define newcolor eggx_newcolor
#define newpen eggx_newpen
#define gclr eggx_gclr
#define line eggx_line
#define pset eggx_pset
#define gsetfontset eggx_gsetfontset
#define drawstr eggx_drawstr
#define drawsym eggx_drawsym
#define drawarrow eggx_drawarrow
#define fillarc eggx_fillarc
#define drawarc eggx_drawarc
#define circle eggx_circle
#define drawrect eggx_drawrect
#define fillrect eggx_fillrect
#define fillpoly eggx_fillpoly
#define copylayer eggx_copylayer
#define layer eggx_layer
#define putimg24 eggx_putimg24
#define ggetxpress eggx_ggetxpress
#define ggetch eggx_ggetch
#define saveimg eggx_saveimg
#define gsetborder eggx_gsetborder
#define gsetbgcolor eggx_gsetbgcolor
#define gsetinitialattributes eggx_gsetinitialattributes
#define gsetinitialborder eggx_gsetinitialborder
#define gsetinitialbgcolor eggx_gsetinitialbgcolor
#define gsetinitialparsegeometry eggx_gsetinitialparsegeometry
#define gsetinitialwinname eggx_gsetinitialwinname
#define msleep eggx_msleep
#define depthinfo eggx_depthinfo
#define drawnum eggx_drawnum

#define color_prms eggx_color_prms
#define generatecolor eggx_generatecolor
#define makecolor eggx_makecolor

#define tclr() clsc_()
#define gcloseall() gcloseall_()
#define inkeydollar(wn) eggx_ggetch((wn))
/* 以下4つのマクロは将来削除予定 */
#define clsc() clsc_()
#define clsx(wn) eggx_gclr((wn))
#define plot(wn,xg,yg,mode) eggx_line((wn),(xg),(yg),(mode))
#define arohd(wn,xs,ys,xt,yt,s,w,shape) eggx_drawarrow((wn),(xs),(ys),(xt),(yt),(s),(w),(shape))

#endif	/* _EGGX_H */
