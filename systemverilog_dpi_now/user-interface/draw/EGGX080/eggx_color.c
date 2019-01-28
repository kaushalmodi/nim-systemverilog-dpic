#define _EGGX_COLOR_C
#include <stdio.h>
#include <math.h>
#include "eggx_color.h"

#include "_eggx_internal_defs.h"
#include "idl_colors1.h"
#include "idl_colors2.h"
#include "ds9_colors.h"

int eggx_generatecolor( struct eggx_color_prms *p, float dmin, float dmax,
			float in_data, int *rt_r, int *rt_g, int *rt_b )
{
    int rt_over=0 ;
    float d_max=dmax, d_min=dmin ;
    float rt__r=0,rt__g=0,rt__b=0 ;
    float rng , data0 , ndata ;
    float _contrast , _brightness , _gamma ;
    if( d_max < d_min ){
	d_min = dmax ;
	d_max = dmin ;
	rng = d_max - d_min ;
	/* maxとminが逆だった場合は，色を逆に */
	data0 = rng - (in_data - d_min) ;
	if( d_max < in_data ) rt_over=-1 ;
	if( in_data < d_min ) rt_over=1 ;
    }
    else{
	rng = d_max - d_min ;
	data0 = in_data - d_min ;
	if( d_max < in_data ) rt_over=1 ;
	if( in_data < d_min ) rt_over=-1 ;
    }

    ndata = data0 / rng ;

    if( p->flags & C_REVERSE ){
	data0 = rng - data0 ;
    }

    /* 量子化してしまう */
    if( p->flags & CP_SEPLEVEL ){
	if( 1 < p->seplevel ){
	    int num_block ;
	    float sl_block ;
	    sl_block = rng/(float)(p->seplevel) ;
	    num_block = (int)(data0 / sl_block) ;	/* 0,1,... */
	    if( p->seplevel <= num_block ) num_block = p->seplevel - 1 ;
	    data0 = sl_block*0.5 + sl_block*num_block ;
	}
    }

    /* DS9 */
    if( DS9_BEGIN <= p->colormode &&
	p->colormode < (DS9_BEGIN + DS9_NUM ) ){
	if( DS9_GREY <= p->colormode &&
	    p->colormode <= DS9_BLUE ){
	    float nd = 255.0 * (data0) / rng ;
	    if( p->colormode == DS9_GREY ){
		rt__r = nd ;  rt__g = nd ;  rt__b = nd ;
	    }
	    else if( p->colormode == DS9_RED ){
		rt__r = nd ;  rt__g = 0 ;  rt__b = 0 ;
	    }
	    else if( p->colormode == DS9_GREEN ){
		rt__r = 0 ;  rt__g = nd ;  rt__b = 0 ;
	    }
	    else if( p->colormode == DS9_BLUE ){
		rt__r = 0 ;  rt__g = 0 ;  rt__b = nd ;
	    }
	}
	else if( ( DS9_A <= p->colormode && p->colormode <= DS9_HE ) ||
		 ( DS9_SLS <= p->colormode && p->colormode <= DS9_RAINBOW ) ){
	    float nd ;
	    int cn, c_mode ;
	    c_mode = p->colormode - DS9_A ;
	    if( DS9_SLS <= p->colormode )
		c_mode -= (DS9_SLS-DS9_HE-1) ;
	    nd = 613.0 * (data0) / rng ;
	    if( nd < 0 ) nd=0 ;
	    else if( 612 < nd ) nd=612 ;
	    cn = (int)nd ;
	    if( (Ds9_cl1[c_mode].flags & F_DIRECT)!=0 || cn==612 ){
		rt__r = Ds9_cl1[c_mode].c[cn].r ;
		rt__g = Ds9_cl1[c_mode].c[cn].g ;
		rt__b = Ds9_cl1[c_mode].c[cn].b ;
	    }
	    else{	/* カラーの補完をする */
		rt__r = (nd-cn)*Ds9_cl1[c_mode].c[cn+1].r 
		    +(cn+1-nd)*Ds9_cl1[c_mode].c[cn].r ;
		rt__g = (nd-cn)*Ds9_cl1[c_mode].c[cn+1].g 
		    +(cn+1-nd)*Ds9_cl1[c_mode].c[cn].g ;
		rt__b = (nd-cn)*Ds9_cl1[c_mode].c[cn+1].b 
		    +(cn+1-nd)*Ds9_cl1[c_mode].c[cn].b ;
	    }
	}
	else if( p->colormode == DS9_I8 ){	/* I8 */
	    int c_r[8] = {0,  0,  0,  0,255,255,255,255} ;
	    int c_g[8] = {0,255,  0,255,  0,255,  0,255} ;
	    int c_b[8] = {0,  0,255,255,  0,  0,255,255} ;
	    float nd = 8 * (data0) / rng ;
	    int cn ;
	    if( nd < 0 ) nd=0 ;
	    else if( 7 < nd ) nd=7 ;
	    cn = (int)nd ;
	    rt__r = c_r[cn] ;
	    rt__g = c_g[cn] ;
	    rt__b = c_b[cn] ;
	}
	else if( p->colormode == DS9_AIPS0 ){	/* AIPS0 */
	    int c_r[9] = {0x31,0x79,0x00,0x5f,0x00,0x00,0xff,0xff,0xff} ;
	    int c_g[9] = {0x31,0x00,0x00,0xa7,0x97,0xf6,0xff,0xb0,0x00} ;
	    int c_b[9] = {0x31,0x9b,0xc8,0xeb,0x00,0x00,0x00,0x00,0x00} ;
	    float nd = 9 * (data0) / rng ;
	    int cn ;
	    if( nd < 0 ) nd=0 ;
	    else if( 8 < nd ) nd=8 ;
	    cn = (int)nd ;
	    rt__r = c_r[cn] ;
	    rt__g = c_g[cn] ;
	    rt__b = c_b[cn] ;
	}
	else if( p->colormode == DS9_STANDARD ){
	    float nd = 3.0 * (data0) / rng ;
	    if( nd < 0 ) nd=0 ;
	    else if( 3.0 < nd ) nd=3.0 ;
	    if( nd < 1.0 ){
		rt__r=0x04d * nd ;
		rt__g=0x04d * nd ;
		rt__b=1 + 0x0fd * nd ;
	    }
	    else if( nd < 2.0 ){
		rt__r=0x04d * (nd-1.0) ;
		rt__g=0x04c + (0x0ff - 0x04c)*(nd-1.0) ;
		rt__b=0x04d * (nd-1.0) ;
	    }
	    else{
		rt__r=0x04c +(0x0fe - 0x04c)*(nd-2.0) ;  
		rt__g=0x04c * (nd-2.0) ; 
		rt__b=0x04c * (nd-2.0) ;
	    }
	}
	else if( p->colormode == DS9_STAIRCASE ){
	    int c_r[15] = {0x0f,0x1e,0x2d,0x3d,0x4c,
			   0x0f,0x1e,0x2d,0x3d,0x4c,
			   0x33,0x66,0x99,0xcc,0xff} ;
	    int c_g[15] = {0x0f,0x1e,0x2d,0x3d,0x4c,
			   0x33,0x66,0x99,0xcc,0xff,
			   0x0f,0x1e,0x2d,0x3d,0x4c} ;
	    int c_b[15] = {0x33,0x66,0x99,0xcc,0xff,
			   0x0f,0x1e,0x2d,0x3d,0x4c,
			   0x0f,0x1e,0x2d,0x3d,0x4c} ;
	    float nd = 15 * (data0) / rng ;
	    int cn ;
	    if( nd < 0 ) nd=0 ;
	    else if( 14 < nd ) nd=14 ;
	    cn = (int)nd ;
	    rt__r = c_r[cn] ;
	    rt__g = c_g[cn] ;
	    rt__b = c_b[cn] ;
	}
	else if( p->colormode == DS9_COLOR ){
	    int c_r[16] = {0x00,0x2e,0x5f,0x8e,0xbf,0xee,
			   0x00,0x00,0x00,0x00,0x00,0x4e,0x7f,0x9f,0xee,0xbf} ;
	    int c_g[16] = {0x00,0x2e,0x5f,0x8e,0xbf,0xee,
			   0x2e,0x5f,0x7f,0xbf,0xee,0x9f,0x7f,0x4e,0x00,0x00} ;
	    int c_b[16] = {0x00,0x2e,0x5f,0x8e,0xbf,0xee,
			   0xee,0xbf,0x7f,0x4e,0x00,0x00,0x00,0x00,0x00,0x4e} ;
	    float nd = 16 * (data0) / rng ;
	    int cn ;
	    if( nd < 0 ) nd=0 ;
	    else if( 15 < nd ) nd=15 ;
	    cn = (int)nd ;
	    rt__r = c_r[cn] ;
	    rt__g = c_g[cn] ;
	    rt__b = c_b[cn] ;
	}
    }
    /* IDL1,IDL2 */
    else if( (IDL1_BEGIN <= p->colormode && 
	      p->colormode < (IDL1_BEGIN + IDL1_NUM)) || 
	     (IDL2_BEGIN <= p->colormode && 
	      p->colormode < (IDL2_BEGIN + IDL2_NUM)) ){
	struct idl_color *pt ;
	float nd ;
	int cn,c_mode ;
	if( IDL2_BEGIN <= p->colormode ){
	    c_mode = p->colormode - IDL2_BEGIN ;
	    pt = Idl_cl2 ;
	}
	else{
	    c_mode = p->colormode - IDL1_BEGIN ;
	    pt = Idl_cl1 ;
	}
	nd = 255.0 * (data0) / rng ;
	if( nd < 0 ) nd=0 ;
	else if( 254 < nd ) nd=254 ;
	cn = (int)nd ;
	if( (pt[c_mode].flags & F_DIRECT)!=0 || cn==254 ){
	    rt__r = pt[c_mode].c[cn].r ;
	    rt__g = pt[c_mode].c[cn].g ;
	    rt__b = pt[c_mode].c[cn].b ;
	}
	else{	/* カラーの補完をする */
	    rt__r = (nd-cn)*pt[c_mode].c[cn+1].r 
		+(cn+1-nd)*pt[c_mode].c[cn].r ;
	    rt__g = (nd-cn)*pt[c_mode].c[cn+1].g 
		+(cn+1-nd)*pt[c_mode].c[cn].g ;
	    rt__b = (nd-cn)*pt[c_mode].c[cn+1].b 
		+(cn+1-nd)*pt[c_mode].c[cn].b ;
	}
    }

    /* コントラスト */
    if( p->flags & CP_CONTRAST ){
	_contrast = p->contrast ;
	if( _contrast < 0 ) _contrast = 0 ;
	if( 1 < _contrast ) _contrast = 1 ;
	rt__r *= _contrast ;
	rt__g *= _contrast ;
	rt__b *= _contrast ;
    }
    /* ブライトネス */
    if( p->flags & CP_BRIGHTNESS ){
	_brightness = p->brightness ;
	if( _brightness < 0 ) _brightness = 0 ;
	if( 1 < _brightness ) _brightness = 1 ;
	rt__r = rt__r *( 1 - _brightness )
	    + 256.0 * _brightness ;
	rt__g = rt__g *( 1 - _brightness )
	    + 256.0 * _brightness ;
	rt__b = rt__b *( 1 - _brightness )
	    + 256.0 * _brightness ;
    }
    /* γ補正 */
    if( p->flags & CP_GAMMA ){
	_gamma = p->gamma ;
	if( _gamma <= 0 ) _gamma = 1.0 ;
	if( rt__r < 0 ) rt__r = 0 ;
	if( rt__g < 0 ) rt__g = 0 ;
	if( rt__b < 0 ) rt__b = 0 ;
	rt__r = 256.0*pow(rt__r/256.0,1.0/_gamma) ;
	rt__g = 256.0*pow(rt__g/256.0,1.0/_gamma) ;
	rt__b = 256.0*pow(rt__b/256.0,1.0/_gamma) ;
    }
    if( p->flags & CP_FUNCTION ){
	/* ユーザ関数を呼ぶ */
	if( p->function != NULL )
	    p->function( ndata,p->ptr,rt__r,rt__g,rt__b, &rt__r,&rt__g,&rt__b ) ;
    }

    *rt_r = (int)rt__r ;
    *rt_g = (int)rt__g ;
    *rt_b = (int)rt__b ;
    if( *rt_r < 0 ) *rt_r=0 ;
    else if( 255 < *rt_r ) *rt_r=255 ;
    if( *rt_g < 0 ) *rt_g=0 ;
    else if( 255 < *rt_g ) *rt_g=255 ;
    if( *rt_b < 0 ) *rt_b=0 ;
    else if( 255 < *rt_b ) *rt_b=255 ;

    return(rt_over) ;
}

int eggx_makecolor( int cmode, float d_min, float d_max, float data,
		    int *rt_r, int *rt_g, int *rt_b )
{
    struct eggx_color_prms p ;
    p.colormode = cmode ;
    p.flags = CP_NONE ;
    return( eggx_generatecolor( &p, d_min, d_max, data, rt_r,rt_g,rt_b ) ) ;
}

void makecolor_( integer *cmode, real *d_min, real *d_max, real *data,
		 integer *rt_r, integer *rt_g, integer *rt_b )
{
    int rt__r,rt__g,rt__b ;
    eggx_makecolor( *cmode, *d_min, *d_max, *data, &rt__r,&rt__g,&rt__b ) ;
    *rt_r = (integer)rt__r ;
    *rt_g = (integer)rt__g ;
    *rt_b = (integer)rt__b ;
}
