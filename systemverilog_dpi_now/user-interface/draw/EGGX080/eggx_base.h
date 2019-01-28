/*
  EGGX / ProCALL  version 0.80
                   eggx_base.h
*/

#ifndef _EGGX_BASE_H
#define _EGGX_BASE_H

#include <X11/X.h>
#include <unistd.h>
#include <stdarg.h>

#define PENDOWN 2
#define PENUP   3
#define PSET    1
/* サポートするウィンドゥ属性 */
#define OVERRIDE (1<<0)
#define AUTOREDRAW (1<<1)
#define DOCKAPP (1<<3)
/* まだ実現してないが… */
#define SHAPE (1<<2)
#define WHENEVERFLUSH (1<<4)

#define FONTSET 0

#define ENABLE 1
#define DISABLE 0

#ifndef _EGGX_BASE_C

extern int eggx_ggetdisplayinfo( int *,int *,int * ) ;
extern int eggx_gopen( int , int ) ;
extern int eggx_winname( int wn, const char *, ... ) ;
extern void eggx_window( int , float , float , float , float ) ;
extern void clsc_( void ) ;
extern void eggx_gclose( int ) ;
extern void gcloseall_( void ) ;
extern void eggx_newrgbcolor( int , int , int , int ) ;
extern void eggx_newcolor( int , const char *, ... ) ;
extern void eggx_newpen( int , int ) ;
extern void eggx_gclr( int ) ;
extern void eggx_line( int , float , float , int ) ;
extern void eggx_pset( int , float , float ) ;
extern int eggx_gsetfontset( int , const char *, ... ) ;
extern void eggx_drawstr( int ,float, float, int, float, const char *, ... ) ;
extern void eggx_drawsym( int ,float, float, int, int ) ;
extern void eggx_drawarrow( int, float, float, float, float, float, float, int ) ;
extern void eggx_fillarc( int, float, float, float, float, float, float, int ) ;
extern void eggx_drawarc( int, float, float, float, float, float, float, int ) ;
extern void eggx_circle( int , float , float , float , float ) ;
extern void eggx_drawrect( int, float, float, float, float ) ;
extern void eggx_fillrect( int, float, float, float, float ) ;
extern void eggx_fillpoly( int, float [],float [], int, int ) ;
extern void eggx_copylayer( int , int , int ) ;
extern void eggx_layer( int, int, int ) ;
extern int eggx_putimg24( int , float , float ,
		      int , int , unsigned char * ) ;
extern int eggx_ggetxpress( int , int *, float *, float * ) ;
extern int eggx_ggetch( int ) ;
extern void eggx_saveimg( int, int, float, float, float, float, char *, int, const char *, ... ) ;

extern void eggx_gsetborder( int , int, const char *, ... ) ;
extern void eggx_gsetbgcolor( int , const char *, ... ) ;

extern void eggx_gsetinitialattributes( int , long ) ;
extern void eggx_gsetinitialborder( int , const char *, ... ) ;
extern void eggx_gsetinitialbgcolor( const char *, ... ) ;
extern void eggx_gsetinitialparsegeometry( const char *, ... ) ;
extern void eggx_gsetinitialwinname( char *, char *, char *, char * ) ;
extern void eggx_msleep( unsigned long ) ;

/* 削除予定 */
extern int eggx_depthinfo( void ) ;
extern void eggx_drawnum( int ,float, float, int, float, float, int ) ;

#endif	/* _EGGX_BASE_C */
#endif	/* _EGGX_BASE_H */
