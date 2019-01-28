/*
  EGGX / ProCALL  version 0.80
                  eggx_color.h
*/

#ifndef _EGGX_COLOR_H
#define _EGGX_COLOR_H

#include <stdio.h>

#define CP_NONE		0
#define C_REVERSE	(1<<0)
#define CP_CONTRAST	(1<<1)
#define CP_BRIGHTNESS	(1<<2)
#define CP_GAMMA	(1<<3)
#define CP_FUNCTION	(1<<4)
#define CP_SEPLEVEL	(1<<5)

struct eggx_color_prms {
    int colormode ;
    int flags ;
    float contrast ;
    float brightness ;
    float gamma ;
    int seplevel ;
    void *ptr ;
    void (*function)( float,void *,float,float,float,float *,float *,float * ) ;
} ;

/* DS9 */
#define DS9_GREY		0
#define DS9_GRAY		0
#define DS9_RED			1
#define DS9_GREEN		2
#define DS9_BLUE		3
#define DS9_A			4
#define DS9_B			5
#define DS9_BB			6
#define DS9_HE			7
#define DS9_I8			8
#define DS9_AIPS0		9
#define DS9_SLS			10
#define DS9_HEAT		11
#define DS9_COOL		12
#define DS9_RAINBOW		13
#define DS9_STANDARD		14
#define DS9_STAIRCASE		15
#define DS9_COLOR		16

#define DS9_BEGIN		0
#define DS9_NUM			17

/* IDL1 */

#define IDL1_B_W_LINEAR		17
#define IDL1_BLUE_WHITE		18
#define IDL1_GRN_RED_BLU_WHT	19
#define IDL1_RED_TEMPERATURE	20
#define IDL1_BLUE_GREEN_RED_YELLOW 21
#define IDL1_STD_GAMMA_II	22
#define IDL1_PRISM		23
#define IDL1_RED_PURPLE		24
#define IDL1_GREEN_WHITE_LINEAR	25
#define IDL1_RGN_WHT_EXPONENTIAL  26
#define IDL1_GREEN_PINK		27
#define IDL1_BLUE_RED		28
#define IDL1_16_LEVEL		29
#define IDL1_RAINBOW		30
#define IDL1_STEPS		31
#define IDL1_STERN_SPECIAL	32

#define IDL1_BEGIN		17
#define IDL1_NUM		16

/* IDL2 */

#define IDL2_HAZE		33
#define IDL2_BLUE_PASTEL_RED	34
#define IDL2_PASTELS		35
#define IDL2_HUE_SAT_LIGHTNESS_1 36
#define IDL2_HUE_SAT_LIGHTNESS_2 37
#define IDL2_HUE_SAT_VALUE_1	38
#define IDL2_HUE_SAT_VALUE_2	39
#define IDL2_PURPLE_RED_WITH_STRIPES 40
#define IDL2_BEACH		41
#define IDL2_MAC_STYLE		42
#define IDL2_EOS_A		43
#define IDL2_EOS_B		44
#define IDL2_HARDCANDY		45
#define IDL2_NATURE		46
#define IDL2_OCEAN		47
#define IDL2_PEPPERMINT		48
#define IDL2_PLASMA		49
#define IDL2_BLUE_RED		50
#define IDL2_RAINBOW		51
#define IDL2_BLUE_WAVES		52
#define IDL2_VALCANO		53
#define IDL2_WAVES		54
#define IDL2_RAINBOW18		55
#define IDL2__RAINBOW		56
#define IDL2_ORBIT_VIEWER_COLOR 57
#define IDL2_ORBIT_VIEWER_GREY  58
#define IDL2_ORBIT_VIEWER_GRAY  58

#define IDL2_BEGIN		33
#define IDL2_NUM		26

#define EGGX_COLOR_BEGIN	0
#define EGGX_COLOR_NUM		(DS9_NUM+IDL1_NUM+IDL2_NUM)

#ifndef _EGGX_COLOR_C

extern int eggx_generatecolor( struct eggx_color_prms *, float, float, float ,
			       int *, int *, int * ) ;
extern int eggx_makecolor( int , float , float , float ,
			   int *, int *, int * ) ;

#endif	/* _EGGX_COLOR_C */
#endif	/* _EGGX_COLOR_H */
