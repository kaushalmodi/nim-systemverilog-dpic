/*
  EGGX / ProCALL  version 0.80
                   eggx_base.c
  究極の簡単さを目指して作成した，C ，FORTRAN 両用の
  X11グラフィックスライブラリ．
 */

#define _EGGX_BASE_C

#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>
#include <X11/Xlocale.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <stdarg.h>
#include <string.h>
#include <math.h>
#include <signal.h>
#include <fcntl.h>
#include <dirent.h>
#include <ctype.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <locale.h>

#include "_eggx_internal_defs.h"
#include "eggx_base.h"
#include "exec_proslave.h"

#define  MLC 8
#define  STRMLC 32

#define SLAVEFILE "_proslave_"
#define DEFAULTFONTSET "-*-fixed-medium-r-normal--14-*"

#ifdef NO_ISINF
#define ISINF(x) isnan(x)
#else
#define ISINF(x) isinf(x)
#endif

struct pctg {
    Window win ;	/* Window  ID */
    Window iconwin ;	/* Icon Window ID */
    Pixmap pix[2] ;	/* Pixmap  ID */
    GC pxgc ;	/* レイヤのコピー用 */
    GC gc ;
    XFontStruct *fontstruct ;
    XFontSet fontset ;	/* フォントセット */
    unsigned short fontheight ;
    char **fontset_ml ;
    pid_t cpid ;	/* 子プロセスのpid */
    int flg ;
    int plx ;		/* plotで使用するx座標 */
    int ply ;		/* plotで使用するy座標 */
    float winxs ;	/* ウィンドゥ */
    float winxe ;
    float winys ;
    float winye ;
    int wszx ;		/* グラフィックのサイズ */
    int wszy ;
    float wicx ;	/* xyconvで使用 */
    float wicy ;
    int sly ;		/* 表示するレイヤ */
    int wly ;		/* 書き込むレイヤ */
    int fsz ;		/* フォントサイズ */
    unsigned long bgcolor ;	/* 背景色 */
    GC bggc ;
    long attributes ;
} ;

static struct pctg *Pc = NULL ;

static Display* Pc_dis=NULL ;			/* Display ID */
static int Pc_depth = 8 ;
static XVisualInfo *Pc_vinfo_ptr=NULL ;
static Visual *Pc_visual ;
static Colormap Pc_cmap ;
static int Red_depth,Green_depth,Blue_depth ;
static int Red_sft,Green_sft,Blue_sft ;
static integer Wn = -1 ;			/* PROCALLで使用するwindowの番号 */
volatile int Ihflg = 0 ;			/* 割り込み禁止フラグ */
volatile int Bsyflg = 0 ;			/* 子プロセスが作業中！のフラグ */
volatile int Exitflg = 0 ;			/* 割り込みによって終了が知らされたが，すぐにはできない場合にたてる */
static int Mlc = 0 ;
static int Or_wth=0 ;				/* ボーダーの幅 */
static pid_t Pid ;				/* プロセスid */
volatile pid_t Cpid_imgsave ;			/* imgsaveしているcpid */
volatile pid_t Cpid_tmp ;			/* テンポラリ用cpid */
static char Exec_slave_tmp[] = "/tmp/" SLAVEFILE "XXXXXX" ;	/* 子プロセスのファイル名 */
static int Exec_fd=-1 ;
static char *Pc_fnt[24] ={ "5x7","5x7","5x7","5x7","5x7","5x7","5x7","5x8",
			   "6x9","6x10","6x10","6x12","6x13","7x14","7x14","8x16",
			   "8x16","8x16","8x16","10x20",
			   "10x20","10x20","10x20","12x24" } ;
static char *Pc_storename=NULL ;
static char *Pc_iconname=NULL ;
static char *Pc_classhint_res_name=NULL ;
static char *Pc_classhint_res_class=NULL ;
static char *Pc_geometry = NULL ;
static char *Pc_bgcolor = NULL ;
static char *Pc_bordercolor = NULL ;
static long Pc_attributes = 0 | AUTOREDRAW | WHENEVERFLUSH ;

static char *Pname="EGGX" ;

/* ぷろとたいぷ */
void eggx_msleep( unsigned long ) ;
void gcloseall_( void ) ;
int eggx_gsetfontset( int , const char *, ... ) ;

/* ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡ */
/*               汎用的な関数               */
/* ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡ */

/* エラーチェック付きmalloc,realloc */
static void *_procall_xmalloc( size_t size )
{
    void *rt ;
    rt=malloc(size) ;
    if( rt==NULL ){
        fprintf(stderr,"メモリの確保に失敗しました．\n") ;
        exit(1) ;
    }
    return( rt ) ;
}

static void *_procall_xrealloc( void *ptr, size_t size )
{
    void *rt ;
    rt=realloc(ptr,size) ;
    if( rt==NULL ){
        fprintf(stderr,"メモリの再確保に失敗しました．\n") ;
        exit(1) ;
    }
    return( rt ) ;
}

static int _procall_dev_null_w_open( void )
{
    int f ;
    f=open("/dev/null",O_WRONLY) ;
    if( f == -1 ){
	fprintf(stderr,"/dev/null がオープンできません．\n") ;
	exit(1) ;
    }
    return( f ) ;
}

/* 割込みを設定する */
static int _procall_signal( int signum, int sa__flags,
			    void (*sa__handler)(int) )
{
    struct sigaction sa ;
    sigset_t sm ;
    /* シグナルマスクの設定 */
    sigemptyset( &sm ) ;
    sigaddset( &sm, signum ) ;
    /* 割り込み登録 */
    sa.sa_handler = sa__handler ;
    sa.sa_mask = sm ;
    sa.sa_flags = sa__flags ;
    return( sigaction( signum, &sa, NULL ) ) ;
}

static char *strdup_toupper( const char *s )
{
    int i ;
    char *rt ;
    rt = strdup( s ) ;
    if ( rt!=NULL ){
	for( i=0 ; i<strlen(s) ; i++ ){
	    rt[i]=toupper(s[i]) ;
	}
    }
    return(rt) ;
}

/* プロセスのコマンド名を調べる */
static char *getpname( pid_t pd )
{
    static char *buf=NULL ;
    char *ptr,*eptr ;
    int pfds[2] ;
    int status ;
    pid_t pid ;
    char *args[]= { "/bin/ps","-f","-p", NULL, NULL } ;
    char *args0[]= { "/usr/bin/ps","-f","-p", NULL, NULL } ;
    char *name=NULL ;
    int f,nn,i ;
    FILE *fp ;
    int mlc ;
    int c,cnt=0,line_cnt=0 ;

#ifdef ANOTHERPS
    goto err ;
#endif
    f=_procall_dev_null_w_open() ;
    fp=fdopen(f,"w") ;
    if( fp == NULL ){
	fprintf(stderr,"/dev/null がオープンできません．\n") ;
	exit(1) ;
    }
    nn=fprintf(fp,"%ld",(long)pd) ;
    fclose(fp) ;
    close(f) ;

    name=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
    sprintf(name,"%ld",(long)pd) ;
    args[3]=name ;
    args0[3]=name ;
    
    while( 1 ){
	if( pipe(pfds)<0 ) goto err ;
	if( ( pid=fork() ) < 0 ) goto err ;
	if( pid == 0 ){
	    dup2( pfds[1],1 ) ;	/* 読み込み用 */
	    close( pfds[1] ) ;
	    close( pfds[0] ) ;
	    execv( *args, args ) ;
	    execv( *args0, args0 ) ;
	    fprintf(stderr,"ps コマンドが実行できません．\n") ;
	    if( Pid == getppid() ){
		kill(Pid,SIGTERM) ;
	    }
	    _exit(-1) ;
	}
	close( pfds[1] ) ;
	fp = fdopen( pfds[0],"r") ;
	if( fp!=NULL ){
	    cnt=0 ;
	    line_cnt=0 ;
	    mlc = 64 ;
	    if( buf!=NULL ){
		free(buf) ;
		buf=NULL ;
	    }
	    buf=(char *)_procall_xmalloc(sizeof(char)*mlc) ;
	    while( (c=fgetc(fp))!=EOF ){
		if( cnt == mlc-1 ){
		    mlc += 64 ;
		    buf=(char *)_procall_xrealloc(buf,sizeof(char)*mlc) ;
		}
		if( c == '\n' ) line_cnt++ ;
		if( c < 0x020 ) c=0x020 ;
		buf[cnt]=c ;
		cnt++ ;
	    }
	    buf[cnt]='\0' ;
	    fclose(fp) ;
	}
	close( pfds[0] ) ;
	while(wait(&status)!=pid) ; 	/* ここは割込みで処理していない */
	if( line_cnt > 1 ) break ;		/* /proc以下に書き込まれるまでに */
	eggx_msleep( 10 ) ;			/* 時間がかかることがある */
    } ;
    if( cnt == 0 ) goto err ;
    for( i=0 ; i<cnt ; i++ ){
	if( 0x020 < buf[cnt-1-i] ) break ;
	buf[cnt-1-i]='\0' ;
    }
    if( strlen(buf) < 2 ) goto err ;
    ptr=buf ;
    if( *ptr != 0x020 ) i=1 ;
    else i=0 ;
    while( *++ptr != '\0' ){
	if( *(ptr-1) == 0x020 && *ptr != 0x20 ){
	    i++ ;
	    if( i == 16 ) break ;
	}
    }
    if( *ptr == '\0' ) goto err ;
    eptr=ptr ;
    while( *++eptr != '\0' ){
	if( *eptr == 0x020 ) break ;
    }
    *eptr='\0' ;
    ptr=eptr ;
    while( *--ptr != 0x020 ){
	if( *ptr == '/' ) break ;
    }
    ptr++ ;

    if( name != NULL ) free(name) ;
    return( ptr ) ;
 err:
    if( buf  != NULL ) free(buf) ;
    if( name != NULL ) free(name) ;
    return(NULL) ;
}

/* ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡ */
/*           PROCALL内部用の関数            */
/* ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡ */

/* ============= テンポラリファイル関連 ============= */

#ifdef CYGWIN
static char **Remove_list = NULL ;
static int Remove_cnt=0 ;
static int add_removelist( void )
{
    if ( Remove_list == NULL ){
	Remove_cnt++ ;
	Remove_list = (char **)_procall_xmalloc(sizeof(char *)*Remove_cnt) ;
    }
    else{
	Remove_cnt++ ;
	Remove_list = (char **)_procall_xrealloc(Remove_list,sizeof(char *)*Remove_cnt) ;
    }
    Remove_list[Remove_cnt-1]=strdup(Exec_slave_tmp) ;
    return(0) ;
}

static void remove_removelist( void )
{
    int i ;
    struct stat st ;
    for( i=0 ; i<Remove_cnt ; i++ ){
	while( remove( Remove_list[i] ) ){
	    if( stat( Exec_slave_tmp, &st ) ) break ;
	    eggx_msleep(10) ;
	}
    }
}
#endif

static int mkexecfile( void )
{
    struct stat st ;
    mode_t mode ;

#ifdef CYGWIN
    if( 0 < Remove_cnt ){
	if( stat( Exec_slave_tmp, &st )==0 ){
	    return(0) ;
	}
    }
#endif

    /* if( Exec_fd != -1 ) return( 0 ) ; */
    while(1){
	strcpy(Exec_slave_tmp,"/tmp/" SLAVEFILE "XXXXXX") ;
#ifdef NO_MKSTEMP	/* mkstempがない場合 */
	if( mktemp( Exec_slave_tmp ) == NULL ) return( -1 ) ;
	Exec_fd = open( Exec_slave_tmp, O_RDWR|O_CREAT|O_EXCL, S_IRUSR|S_IWUSR) ;
#else
	Exec_fd = mkstemp( Exec_slave_tmp ) ;
#endif
	if( Exec_fd == -1 ) return( -1 ) ;
#if 0
	if( lockf( Exec_fd, F_LOCK, 0 ) ){
	    close( Exec_fd ) ;
	    Exec_fd=-1 ;
	    remove(Exec_slave_tmp) ;
	    eggx_msleep( 10 ) ;
	    continue ;
	}
#endif
	/* lockfの前に消される場合も有り得るので,statで確認 */
	if( stat( Exec_slave_tmp, &st ) ){
	    close( Exec_fd ) ;
	    Exec_fd=-1 ;
	    remove(Exec_slave_tmp) ;
	    eggx_msleep( 10 ) ;
	    continue ;
	}
	if( write( Exec_fd, _proslave_, sizeof(_proslave_) ) != sizeof(_proslave_) ){
	    close( Exec_fd ) ;
	    Exec_fd=-1 ;
	    remove(Exec_slave_tmp) ;
	    eggx_msleep( 10 ) ;
	    continue ;
	}
	if( stat( Exec_slave_tmp, &st ) ){
	    close( Exec_fd ) ;
	    Exec_fd=-1 ;
	    remove(Exec_slave_tmp) ;
	    eggx_msleep( 10 ) ;
	    continue ;
	}
	break ;
    }
    mode=st.st_mode ;
    chmod( Exec_slave_tmp, mode | S_IXUSR ) ;
    fsync(Exec_fd) ;
    /* close(Exec_fd) ; */	/* closeしない．execvする直前にclose */
#ifdef CYGWIN
    add_removelist() ;
#endif
    return( 0 ) ;
}

static void rmexecfile( void )
{
    if( Exec_fd != -1 ){
	close(Exec_fd) ;
	Exec_fd = -1 ;
    }
#ifndef CYGWIN
    remove( Exec_slave_tmp ) ;
#endif
}

#if 0
/* 以前のテンポラリファイルが残っていれば削除する */
static int rmproperexec( void )
{
    struct stat st ;
    DIR *ddir ;
    struct dirent *dp ;
    char *ptr ;
    int flen,rtnflg=0 ;

    ddir=opendir("/tmp") ;
    if( ddir == NULL ) return(-1) ;
    flen=strlen(Exec_slave_tmp)+1 ;
    for( dp=readdir(ddir) ; dp!=NULL ; dp=readdir(ddir) ){
      ptr=(strrchr(Exec_slave_tmp,'/')+1) ;
      if( strncmp(dp->d_name,ptr,
		  strlen(SLAVEFILE)) == 0 ){
	if( strlen(ptr) == (strlen(SLAVEFILE)+6) ){
	  FILE *fp ;
	  char *fn=NULL ;
	  fn=(char *)_procall_xmalloc(sizeof(char)*flen) ;
	  strcpy(fn,Exec_slave_tmp) ;
	  strcpy(fn+5,dp->d_name) ;
	  stat(fn,&st) ;
	  if( st.st_uid == getuid() /* && st.st_size == sizeof(_proslave_) */ ){
	    int i,f ;
	    int fd ;
	    unsigned char *chkbuf=NULL ;
	    chkbuf=(unsigned char *)_procall_xmalloc(sizeof(_proslave_)) ;
	    fd = open(fn,O_RDONLY) ;		/* まずはロックをチェック */
	    if( fd != -1 ){
	      if( lockf(fd, F_TEST, 0) == 0 ){	/* 0ならロックされてない */
		close(fd) ;
		fp=fopen(fn,"a+b") ;
		if( fp != NULL ){	/* 実行中なら NULL になる */
		  fclose(fp) ;
		  fd = open(fn,O_RDONLY) ;
		  if( fd != -1 ){	/* 同一かどうかチェックする */
		    i = read( fd, chkbuf, sizeof(_proslave_) ) ;
		    f=0 ;
		    if( i==sizeof(_proslave_) ){
		      for( i=0 ; i<sizeof(_proslave_) ; i++ ){
			if( chkbuf[i] != _proslave_[i] )
			  break ;
		      }
		      if( i==sizeof(_proslave_) && st.st_size == sizeof(_proslave_) ) f=1 ;
		    }
		    else{
			if( i==0 ) f=1 ;
		    }
		    /* 念のため再度，ロックをチェック */
		    if( lockf(fd, F_TEST, 0) == 0 ){
		      close(fd) ;
		      if( f ) remove(fn) ;
		    }
		    else close(fd) ;
		  }
		}
	      }
	      else close(fd) ;
	    }
	    if( chkbuf != NULL ) free(chkbuf) ;
	  }
	  if( fn != NULL ) free(fn) ;
	}
      }
    }		    
    closedir(ddir) ;
    return(rtnflg) ;
}
#endif

/* ============= 割込み関連 ============= */

/* 子プロセスが終了した時の処理 */
static void chldexithandler( int dummy )
{
    pid_t pid ;
    int status ;
    pid = waitpid(-1, &status, WNOHANG) ;
    if( pid == Cpid_imgsave ){
	if( Bsyflg == 1 ) Bsyflg=0 ;	/* Bsyflg==-1の時はさわらない */
	Cpid_imgsave=0 ;
    }    
    else{
	int i ;
	for( i=0 ; i<Mlc ; i++ ){
	    if( Pc[i].flg!=0 ){
		if( pid == Pc[i].cpid ){
		    Pc[i].cpid = 0 ;
		}
	    }
	}
    }
    if( pid == Cpid_tmp ) Cpid_tmp=0 ;
}

static void c_err_handler( int dummy )
{
    Bsyflg=-1 ;
}

static void c_rdy_handler( int dummy )
{
    Bsyflg=1 ;
}

static void killallchld()
{
    int i ;
    for( i=0 ; i<Mlc ; i++ ){
	if( Pc[i].flg!=0 ){
	    if( Pc[i].cpid != 0 ){
		kill(Pc[i].cpid,SIGTERM) ;
	    }
	}
    }
}

/* 割り込みOFF */
static void iusr_end( void )
{
    _procall_signal( SIGUSR2, 0, SIG_DFL ) ;
    _procall_signal( SIGUSR1, 0, SIG_DFL ) ;
    _procall_signal( SIGTERM, 0, SIG_DFL ) ;
    _procall_signal( SIGINT, 0, SIG_DFL ) ;
    _procall_signal( SIGCHLD, 0, SIG_DFL ) ;
}

static void wait_child( void )
{
    while( Bsyflg ){
	eggx_msleep( 10 ) ;
	/* fprintf(stderr,"waiting cpid=%d\n",Cpid_imgsave) ; */
    }
}

static void iint_handler( int dummy )
{
    /*
    if( Ihflg ) Exitflg = 1 ;
    else exit(0) ;
    */
    /* wait_child() ; */	/* imgsave中は待たせる */
    /* iusr_end() ; */
    exit(0);
}

/* 割り込みセット */
static void iusr_start( void )
{
    _procall_signal( SIGCHLD, SA_NOCLDSTOP|SA_RESTART, &chldexithandler ) ;
    _procall_signal( SIGINT, 0, &iint_handler ) ;
    _procall_signal( SIGTERM, 0, &iint_handler ) ;
    _procall_signal( SIGUSR1, 0, &c_rdy_handler ) ;
    _procall_signal( SIGUSR2, 0, &c_err_handler ) ;
}

static void chkexit( void )
{
    if( Exitflg ) iint_handler( 0 ) ;
}

/* ============= 描画関連 ============= */

static Window XX_CreateSimpleWindow(Display *display, Window parent,
				   int x, int y,
				   unsigned int width, unsigned int height,
				   unsigned int border_width,
				   unsigned long border, 
				   unsigned long background )
{
    XSetWindowAttributes attributes ;

    attributes.border_pixel = border ;
    attributes.background_pixel = background ;
    attributes.colormap = Pc_cmap ;

    return( XCreateWindow(display,parent,x,y,width,height,
			  border_width,
			  Pc_depth,InputOutput,Pc_visual,
			  CWBorderPixel | CWBackPixel | CWColormap,
			  &attributes ) ) ;
}

static unsigned long GetColor( Display* dis, char* color_name )
{
    Colormap cmap ;
    XColor near_color, true_color ;

    cmap = Pc_cmap /* DefaultColormap( dis, 0 ) */ ;
    XAllocNamedColor( dis, cmap, color_name, &near_color, &true_color ) ;
    return( near_color.pixel ) ;
}

static void xyconv( int wn, float x, float y, int *rx, int *ry )
{
    *rx = (int)((x-Pc[wn].winxs)*Pc[wn].wicx) ;
    *ry = Pc[wn].wszy - (int)((y-Pc[wn].winys)*Pc[wn].wicy) -1 ;
}

/* 開始点と終了点に点を打ち，ラインを引く(特定のXサーバ対策) */
static int XX_DrawLine( Display *dis, int wn, int xs, int ys, int xe, int ye )
{
    int i ;
    i=Pc[wn].wly ;
    XDrawPoint( dis, Pc[wn].pix[i], Pc[wn].gc, xs, ys ) ;
    XDrawLine( dis, Pc[wn].pix[i], Pc[wn].gc, xs,ys,xe,ye ) ;
    XDrawPoint( dis, Pc[wn].pix[i], Pc[wn].gc, xe, ye ) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XDrawPoint( dis, Pc[wn].win, Pc[wn].gc, xs, ys ) ;
    XDrawLine( dis, Pc[wn].win, Pc[wn].gc, xs,ys,xe,ye ) ;
    XDrawPoint( dis, Pc[wn].win, Pc[wn].gc, xe, ye ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XDrawPoint( dis, Pc[wn].iconwin, Pc[wn].gc, xs, ys ) ;
	XDrawLine( dis, Pc[wn].iconwin, Pc[wn].gc, xs,ys,xe,ye ) ;
	XDrawPoint( dis, Pc[wn].iconwin, Pc[wn].gc, xe, ye ) ;
    }
    return(1) ;
}

static int X_DrawLine(  Display *dis, int wn, int xs, int ys, int xe, int ye )
{
    XDrawLine( dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].gc, xs,ys,xe,ye ) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XDrawLine( dis, Pc[wn].win, Pc[wn].gc, xs,ys,xe,ye ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XDrawLine( dis, Pc[wn].iconwin, Pc[wn].gc, xs,ys,xe,ye ) ;
    }
    return(1) ;
}

static int X_DrawPoint( Display *dis, int wn, int x, int y )
{
    XDrawPoint( dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].gc, x, y ) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XDrawPoint( dis, Pc[wn].win, Pc[wn].gc, x, y ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XDrawPoint( dis, Pc[wn].iconwin, Pc[wn].gc, x, y ) ;
    }
    return(1) ;
}

static int X_DrawString( Display *dis, int wn, int x, int y, char *str, int len )
{
    XDrawString( dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].gc, x, y, str, len ) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XDrawString( dis, Pc[wn].win, Pc[wn].gc, x, y, str, len ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XDrawString( dis, Pc[wn].iconwin, Pc[wn].gc, x, y, str, len ) ;
    }
    return(1) ;
}

static int X_mbDrawString( Display *dis, int wn, int x, int y, char *str, int len )
{
    XmbDrawString( dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].fontset, Pc[wn].gc, x, y, str, len ) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XmbDrawString( dis, Pc[wn].win, Pc[wn].fontset, Pc[wn].gc, x, y, str, len ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XmbDrawString( dis, Pc[wn].iconwin, Pc[wn].fontset, Pc[wn].gc, x, y, str, len ) ;
    }
    return(1) ;
}

static int X_FillArc( Display *dis, int wn, int x, int y, 
		      int sx, int sy, int s, int w )
{
    XFillArc( dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].gc, x, y, sx, sy, s, w ) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XFillArc( dis, Pc[wn].win, Pc[wn].gc, x, y, sx, sy, s, w ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XFillArc( dis, Pc[wn].iconwin, Pc[wn].gc, x, y, sx, sy, s, w ) ;
    }
    return(1) ;
}

static int X_DrawArc( Display *dis, int wn, int x, int y, 
		      int sx, int sy, int s, int w )
{
    XDrawArc( dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].gc, x, y, sx, sy, s, w ) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XDrawArc( dis, Pc[wn].win, Pc[wn].gc, x, y, sx, sy, s, w ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XDrawArc( dis, Pc[wn].iconwin, Pc[wn].gc, x, y, sx, sy, s, w ) ;
    }
    return(1) ;
}

static int X_FillPolygon( Display *dis, int wn, XPoint* points, 
			  int num, int shape, int mode )
{
    XFillPolygon( dis,Pc[wn].pix[Pc[wn].wly],Pc[wn].gc,points,num,shape,mode) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XFillPolygon( dis,Pc[wn].win,Pc[wn].gc,points,num,shape,mode) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XFillPolygon( dis,Pc[wn].iconwin,Pc[wn].gc,points,num,shape,mode) ;
    }
    return(1) ;
}

static int X_DrawRectangle( Display *dis, int wn, int x, int y, int w, int h )
{
    XDrawRectangle( dis,Pc[wn].pix[Pc[wn].wly],Pc[wn].gc,x,y,w,h) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XDrawRectangle( dis,Pc[wn].win,Pc[wn].gc,x,y,w,h) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XDrawRectangle( dis,Pc[wn].iconwin,Pc[wn].gc,x,y,w,h) ;
    }
    return(1) ;
}

static int X_FillRectangle( Display *dis, int wn, int x, int y, int w, int h )
{
    XFillRectangle( dis,Pc[wn].pix[Pc[wn].wly],Pc[wn].gc,x,y,w,h) ;
    if( Pc[wn].wly!=Pc[wn].sly ) return(0) ;
    XFillRectangle( dis,Pc[wn].win,Pc[wn].gc,x,y,w,h) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XFillRectangle( dis,Pc[wn].iconwin,Pc[wn].gc,x,y,w,h) ;
    }
    return(1) ;
}

/* ============= ProCALLの関数専用 ============= */

static int bitcount( int d )
{
    int rt=0 ;
    while( (d & 0x01)==0x01 ){
	d>>=1 ;
	rt++ ;
    }
    return(rt) ;
}
static int sftcount( int *mask )
{
    int rt=0 ;
    while( (*mask & 0x01)==0 ){
	(*mask)>>=1 ;
	    rt++ ;
    }
    return(rt) ;
}


/* ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡ */
/*            外部に提供する関数            */
/* ≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡≡ */

/* displayをopenし，depthなどを調べる */
int eggx_ggetdisplayinfo( int *rt_depth, int *root_width, int *root_height )
{
    Window lwin ;
    static XWindowAttributes xvi,root_xvi ;
    XVisualInfo visual_info ;
    int i,best,num_visual ;

    if( Pc_dis==NULL ){
	Pc_dis=XOpenDisplay(NULL) ;
	if( Pc_dis==NULL ){
	    if( rt_depth != NULL ) *rt_depth=-1 ;
	    if( root_width != NULL ) *root_width=-1 ;
	    if( root_height != NULL ) *root_height=-1 ;
	    return(-1) ;
	}
	/* Visualの決定 */
	visual_info.screen = DefaultScreen(Pc_dis) ;
	visual_info.class  = TrueColor ;

	if( Pc_vinfo_ptr!=NULL ) XFree((char *)Pc_vinfo_ptr) ;
	Pc_vinfo_ptr = XGetVisualInfo( Pc_dis, 
				       VisualScreenMask | VisualClassMask,
				       &visual_info, &num_visual ) ;
	best = -1 ;
	if( Pc_vinfo_ptr!=NULL ){     /* TrueColorを探す */
	    for( i=0 ; i < num_visual ; i++ ){
		if( 0 <= best ){
		    if( Pc_vinfo_ptr[best].depth < Pc_vinfo_ptr[i].depth ){
			if( Pc_vinfo_ptr[i].depth <= 24 ){
			    best = i ;
			}
		    }
		}
		else{
		    best = i ;
		}
	    }
	}
	if( 0 <= best ){	/* 結局同じなら… */
	    if( Pc_vinfo_ptr[best].depth 
		== DefaultDepth(Pc_dis,DefaultScreen(Pc_dis)) )
		best=-1 ;
	}
	if( best == -1 ){
	    Pc_visual=DefaultVisual(Pc_dis,DefaultScreen(Pc_dis));
	    Pc_depth =DefaultDepth(Pc_dis,DefaultScreen(Pc_dis));
	    Pc_cmap  =DefaultColormap(Pc_dis,DefaultScreen(Pc_dis));
	    if( Pc_vinfo_ptr!=NULL ){
		XFree((char *)Pc_vinfo_ptr) ;
		Pc_vinfo_ptr=NULL ;
	    }
	}
	else{
	    Pc_visual=Pc_vinfo_ptr[best].visual ;
	    Pc_depth =Pc_vinfo_ptr[best].depth ;
	    Pc_cmap  =XCreateColormap(Pc_dis, 
				      DefaultRootWindow(Pc_dis),
				      Pc_visual, AllocNone);
	}

	/* 試しにダミーのウィンドゥを作って */
	lwin = XX_CreateSimpleWindow( Pc_dis, RootWindow(Pc_dis,0), 
				      0, 0, 16, 16, 0, WhitePixel(Pc_dis,0), 
				      BlackPixel(Pc_dis,0) ) ;
	/* 属性を調べる */
	XGetWindowAttributes( Pc_dis, RootWindow(Pc_dis,0) , &root_xvi ) ;
	XGetWindowAttributes( Pc_dis, lwin, &xvi ) ;
	if( Pc_depth != xvi.depth ){
	    fprintf(stderr,"Xサーバのdepthが変です!!\n") ;
	    Pc_depth = xvi.depth ;
	}
	if( 16<=Pc_depth ){
	    Red_depth=(xvi.visual)->red_mask ;
	    Green_depth=(xvi.visual)->green_mask ;
	    Blue_depth=(xvi.visual)->blue_mask ;
	    /* シフトの回数 */
	    Red_sft=sftcount(&(Red_depth)) ;
	    Green_sft=sftcount(&(Green_depth)) ;
	    Blue_sft=sftcount(&(Blue_depth)) ;
	    /* ビットあたりの深さ */
	    Red_depth=bitcount(Red_depth) ;
	    Green_depth=bitcount(Green_depth) ;
	    Blue_depth=bitcount(Blue_depth) ;
	    /*
	    printf("%d %d %d - %d %d %d\n",Red_sft,Green_sft,Blue_sft,
		   Red_depth,Green_depth,Blue_depth) ;
	    */
	}
	XDestroyWindow( Pc_dis, lwin ) ;
    }
    if( rt_depth != NULL ) *rt_depth = Pc_depth ;
    if( root_width != NULL ) *root_width  = root_xvi.width ;
    if( root_height != NULL ) *root_height = root_xvi.height ;
    return( 0 ) ;
}

void ggetdisplayinfo_( integer *rt_d, integer *root_w, integer *root_h )
{
    int rt_depth,root_width,root_height ;
    eggx_ggetdisplayinfo(&rt_depth,&root_width,&root_height) ;
    *rt_d   = rt_depth ;
    *root_w = root_width ;
    *root_h = root_height ;
}

/* 窓を開く */
void gopen_( integer *xsize, integer *ysize, integer *rtnum )
{
    XGCValues gv ;
    XEvent ev ;				/* イベント取り込み変数 */
    XSetWindowAttributes att ;		/* 窓属性の変数 */
    XClassHint classHint ;
    XSizeHints size_hints = { 0 } ;
    int x_negative=0,y_negative=0 ;
    /* XTextProperty name ; */
    static int pmlc ;
    int i,dummy,result,num=0 ;
    int default_depth,root_width,root_height ;
#if 0
    int f ;
#endif

    if( Wn < 0 ){
	if( Pc_dis==NULL ){	/* Xserverとの接続 */
	    if( eggx_ggetdisplayinfo(&default_depth,&root_width,&root_height) ){
		fprintf(stderr,"Can't open display.\n") ;
		exit(1) ;
	    }
	}
	if( Wn==-1 ){	/* 1回きりの実行 */
	    Pid=getpid() ;
#if 0
	    f=rmproperexec() ;	/* 前回のテンポラリファイルを削除 */
	    if( f ){
	      fprintf(stderr,"警告: /tmp ディレクトリがオープンできません．\n") ;
	    }
#endif
	    /* atexit( &rmexecfile ) ; */
#ifdef CYGWIN
	    atexit( &remove_removelist ) ;
#endif
	    atexit( &killallchld ) ;
	    Pname=getpname(Pid) ;
	    if( Pname==NULL ) Pname="EGGX" ;
	    if( setlocale(LC_CTYPE, "") == NULL && 0 )
		fprintf(stderr,"Can't set locale.\n") ;
	    /* atexit( &gcloseall_ ) ; */
	}
	iusr_start() ;
	Wn = 0 ;
    }
    if( Mlc==0 ){
	Mlc = MLC ;
	Pc = (struct pctg *)_procall_xmalloc(sizeof(struct pctg)*Mlc) ;
	for( i=0 ; i<Mlc ; i++ ){
	    Pc[i].flg=0 ;
	    Pc[i].fsz=-1 ;
	    Pc[i].fontstruct = NULL ;
	}
	pmlc = Mlc ;
    }
    if( rtnum==NULL ){			/* plotsから来た場合 */
	if( Pc[0].flg==1 ) return ;	/* すでにオープン済み */
	num = 0 ;
	Pc[0].flg=1 ;
    }
    else{				/* あいてる番号を探す */
	for( i=1 ; i<Mlc ; i++ ){	/* 0はplots用に予約*/
	    if( Pc[i].flg==0 ){
		num = i ;
		Pc[i].flg=1 ;
		break ;
	    }
	}
	if( i==Mlc ){			/* あいてない時 */
	    Mlc+=MLC ;
	    Pc = (struct pctg *)_procall_xrealloc(Pc,sizeof(struct pctg)*Mlc) ;
	    for( i=pmlc ; i<Mlc ; i++ ){
		Pc[i].flg=0 ;
		Pc[i].fsz=-1 ;
		Pc[i].fontstruct = NULL ;
	    }
	    num = pmlc ;
	    Pc[pmlc].flg=1 ;
	    pmlc=Mlc ;
	}
    }
    Pc[num].wly=0 ;
    Pc[num].sly=0 ;
    wait_child() ;	/* imgsave中は待たせる */

    Pc[num].attributes = Pc_attributes ;

    size_hints.flags = 0 ;
    if( Pc_geometry != NULL ){
	unsigned int size_hints__width,size_hints__height ;
	result = XParseGeometry( Pc_geometry, 
				 &size_hints.x,
				 &size_hints.y,
				 &size_hints__width,
				 &size_hints__height ) ;
	size_hints.width = (int)size_hints__width ;
	size_hints.height = (int)size_hints__height ;
	if( result & XNegative ) x_negative = 1 ;
	if( result & YNegative ) y_negative = 1 ;
	
        size_hints.flags |= USPosition ;
        size_hints.x = 0;
        size_hints.y = 0;

	XWMGeometry( Pc_dis, DefaultScreen(Pc_dis), 
		     Pc_geometry, NULL, 
		     Or_wth, &size_hints,
		     &size_hints.x, &size_hints.y,
		     &size_hints.width, &size_hints.height, 
		     &dummy );

	size_hints.flags |= PMinSize ;
	size_hints.min_width = *xsize ;
	size_hints.min_height = *ysize ;
	
	size_hints.flags |= PMaxSize ;
	size_hints.max_width = *xsize ;
	size_hints.max_height = *ysize ;
	
	size_hints.flags |= USSize ;
	size_hints.width = *xsize ;
	size_hints.height = *ysize ;
	
	size_hints.win_gravity = NorthWestGravity ;
	if( x_negative ){
	    size_hints.x -= size_hints.width ;
	    size_hints.win_gravity = NorthEastGravity ;
	}
	if( y_negative ){
	    size_hints.y -= size_hints.height ;
	    if( x_negative )
		size_hints.win_gravity = SouthEastGravity ;
	    else
		size_hints.win_gravity = SouthWestGravity ;
	}
	size_hints.flags |= PWinGravity;
    }
    else{
	size_hints.x = 0 ;
	size_hints.y = 0 ;

	size_hints.flags |= PMinSize ;
	size_hints.min_width = *xsize ;
	size_hints.min_height = *ysize ;
	
	size_hints.flags |= PMaxSize ;
	size_hints.max_width = *xsize ;
	size_hints.max_height = *ysize ;
	
	size_hints.flags |= USSize ;
	size_hints.width = *xsize ;
	size_hints.height = *ysize ;
    }

    if( Pc_bgcolor == NULL ){
	Pc[num].bgcolor = BlackPixel(Pc_dis,0) ;
    }
    else{
	Pc[num].bgcolor = GetColor(Pc_dis,Pc_bgcolor) ;
    }

    /* 窓の生成 */
    Pc[num].win = XX_CreateSimpleWindow( Pc_dis, RootWindow(Pc_dis,0), 
					 size_hints.x, size_hints.y,
					 *xsize, *ysize, Or_wth, WhitePixel(Pc_dis,0), 
				       Pc[num].bgcolor ) ;
    XSetWMNormalHints( Pc_dis, Pc[num].win, &size_hints) ;
    if( Pc[num].attributes & DOCKAPP ){
	XWMHints mywmhints ;
	Pc[num].iconwin = XX_CreateSimpleWindow( Pc_dis, RootWindow(Pc_dis,0), 
						 size_hints.x, size_hints.y,
						 *xsize, *ysize, Or_wth, WhitePixel(Pc_dis,0), 
					       Pc[num].bgcolor ) ;
	XSetWMNormalHints( Pc_dis, Pc[num].iconwin, &size_hints ) ;
	mywmhints.initial_state = WithdrawnState ;
        mywmhints.icon_window = Pc[num].iconwin ;
        mywmhints.icon_x = size_hints.x ;
        mywmhints.icon_y = size_hints.y ;
        mywmhints.window_group = Pc[num].win ;
        mywmhints.flags = StateHint | IconWindowHint | 
	    IconPositionHint | WindowGroupHint ;
	XSetWMHints( Pc_dis, Pc[num].win, &mywmhints ) ;
    }
    else Pc[num].iconwin = 0 ;

    Pc[num].pix[0] = XCreatePixmap( Pc_dis,Pc[num].win,*xsize,*ysize,Pc_depth ) ;

    Pc[num].pix[1] = XCreatePixmap( Pc_dis,Pc[num].win,*xsize,*ysize,Pc_depth ) ;

    gv.fill_style = FillTiled ;
    gv.fill_rule = WindingRule ;
    gv.tile = Pc[num].pix[1] ;
    Pc[num].pxgc = XCreateGC( Pc_dis,Pc[num].win,GCFillStyle|GCFillRule|GCTile,&gv ) ;
    
    /* 絵を保存する設定をする */
    /* att.backing_store = WhenMapped ; */
    /* Xサーバの負担を減らすため，子プロセスの再描画に頼る */
    /*
    att.backing_store = NotUseful ;
    XChangeWindowAttributes( Pc_dis, Pc[num].win, CWBackingStore, &att ) ;
    */


    /* ウィンドゥに枠をつけない */
    if( Pc[num].attributes & OVERRIDE ){
	att.override_redirect = True ;
	XChangeWindowAttributes( Pc_dis, Pc[num].win, CWOverrideRedirect, &att ) ;
    }

    if( Pc_storename != NULL )
	XStoreName( Pc_dis, Pc[num].win, Pc_storename ) ;
    else
	XStoreName( Pc_dis, Pc[num].win, Pname ) ;
    if( Pc_iconname != NULL )
	XSetIconName( Pc_dis, Pc[num].win, Pc_iconname ) ;
    else
	XSetIconName( Pc_dis, Pc[num].win, Pname ) ;
    if( Pc_classhint_res_name != NULL )
	classHint.res_name = Pc_classhint_res_name ;
    else classHint.res_name = Pname ;
    if( Pc_classhint_res_class != NULL ){
	classHint.res_class = Pc_classhint_res_class ;
	XSetClassHint( Pc_dis, Pc[num].win , &classHint);
    }
    else{
	classHint.res_class = strdup_toupper(Pname) ;
	XSetClassHint( Pc_dis, Pc[num].win , &classHint);
	free(classHint.res_class) ;
    }

    if( Pc[num].attributes & DOCKAPP ){
	if( Pc_storename != NULL )
	    XStoreName( Pc_dis, Pc[num].iconwin, Pc_storename ) ;
	else
	    XStoreName( Pc_dis, Pc[num].iconwin, Pname ) ;
	if( Pc_iconname != NULL )
	    XSetIconName( Pc_dis, Pc[num].iconwin, Pc_iconname ) ;
	else
	    XSetIconName( Pc_dis, Pc[num].iconwin, Pname ) ;
	if( Pc_classhint_res_name != NULL )
	    classHint.res_name = Pc_classhint_res_name ;
	else classHint.res_name = Pname ;
	if( Pc_classhint_res_class != NULL ){
	    classHint.res_class = Pc_classhint_res_class ;
	    XSetClassHint( Pc_dis, Pc[num].iconwin , &classHint);
	}
	else{
	    classHint.res_class = strdup_toupper(Pname) ;
	    XSetClassHint( Pc_dis, Pc[num].iconwin , &classHint);
	    free(classHint.res_class) ;
	}
    }

    /*
    if( XStringListToTextProperty(&Pname, 1, &name) != 0 ){
	XSetWMName( Pc_dis, Pc[num].win, &name);
    }
    */
    XSelectInput( Pc_dis, Pc[num].win, ExposureMask ) ;
    if( Pc[num].attributes & DOCKAPP ){
	XSelectInput( Pc_dis, Pc[num].iconwin, ExposureMask ) ;
    }
    XMapWindow( Pc_dis, Pc[num].win ) ;	/* 窓の表示 */
    
    do{					/* 窓が開くの待つループ */
	XNextEvent( Pc_dis, &ev ) ;
    } while( ev.type != Expose ) ;

    if( Pc[num].attributes & DOCKAPP ){
	XSelectInput( Pc_dis, Pc[num].iconwin, 0 ) ;
    }

    Pc[num].gc = XCreateGC( Pc_dis, Pc[num].win,0,0 ) ;
    Pc[num].bggc = XCreateGC( Pc_dis, Pc[num].win,0,0 ) ;
    /* XSetGraphicsExposures( Pc_dis, Pc[num].gc, False ) ; */
    
    XSetForeground( Pc_dis, Pc[num].bggc, Pc[num].bgcolor ) ;
    XFillRectangle( Pc_dis, Pc[num].pix[0], Pc[num].bggc, 0,0,*xsize,*ysize ) ;
    XFillRectangle( Pc_dis, Pc[num].pix[1], Pc[num].bggc, 0,0,*xsize,*ysize ) ;
    XDrawRectangle( Pc_dis, Pc[num].pix[0], Pc[num].bggc, 0,0,*xsize,*ysize ) ;
    XDrawRectangle( Pc_dis, Pc[num].pix[1], Pc[num].bggc, 0,0,*xsize,*ysize ) ;

    XSetForeground( Pc_dis, Pc[num].gc, GetColor(Pc_dis,"White") ) ;

    /* フォントセット */
    Pc[num].fontset = NULL ;
    eggx_gsetfontset(num,DEFAULTFONTSET) ;
    
    XFlush( Pc_dis ) ;			/* リクエストの強制送信 */

    Pc[num].wszx = *xsize ;		/* グラフィックサイズ */
    Pc[num].wszy = *ysize ;
    Pc[num].winxs = 0.0 ;		/* ウィンドゥ */
    Pc[num].winxe = (*xsize)-1 ;
    Pc[num].winys = 0.0 ;
    Pc[num].winye = (*ysize)-1 ;
    Pc[num].wicx = 1 ;
    Pc[num].wicy = 1 ;

    if( rtnum!=NULL ) *rtnum=num ;

    XSelectInput( Pc_dis, Pc[num].win, 0 ) ;

    if( Pc[num].attributes & AUTOREDRAW ){
	/* pid_t cpid ; */
	char arg2[16] ;
	char arg3[16],arg4[16] ;
	char arg5[16],arg6[16] ;
	char arg7[16],arg8[16] ;
	char arg9[16] ;
	char *args[11] ;
	sprintf(arg2,"%ld",(long)Pid) ;
	sprintf(arg3,"%ld",(Pc[num].attributes & DOCKAPP)) ;
	sprintf(arg4,"%ld",Pc[num].win) ;
	sprintf(arg5,"%ld",Pc[num].iconwin) ;
	sprintf(arg6,"%ld",Pc[num].pix[0]) ;
	sprintf(arg7,"%ld",Pc[num].pix[1]) ;
	sprintf(arg8,"%d",Pc[num].wszx) ;
	sprintf(arg9,"%d",Pc[num].wszy) ;
	args[0]=Exec_slave_tmp ;
	args[1]="1" ;
	args[2]=arg2 ;
	args[3]=arg3 ;
	args[4]=arg4 ;
	args[5]=arg5 ;
	args[6]=arg6 ;
	args[7]=arg7 ;
	args[8]=arg8 ;
	args[9]=arg9 ;
	args[10]=NULL ;
	while(1){
	    if( mkexecfile() == -1 ){
		fprintf(stderr,"/tmp/ にファイルが作成できません．\n") ;
		Pc[num].cpid=0 ;
		break ;
	    }
	    if( Exec_fd != -1 ){
		close(Exec_fd) ;
		Exec_fd=-1 ;
	    }
	    /* この間でファイルが消されると…子が生まれないので， */
	    /* ループの最後にmkexecfileする */
	    if( (Pc[num].cpid=(Cpid_tmp=fork()))<0 ){
		fprintf(stderr,"子プロセスの生成に失敗しました．\n") ;
		exit(-1) ;
	    }
	    if( Cpid_tmp==0 ){	/* 子 */
		/* fprintf(stderr,"execv: ppid=%d pid=%d\n",getppid(),getpid()) ; */
		if( execv(*args,args)==-1 ){
		    if( Pid == getppid() )
			kill(Pid,SIGUSR2) ;	/* エラーを通知する */
		    /*
		    fprintf(stderr,"ppid=%d pid=%d ファイル %s が実行できません．\n",
			    getppid(),getpid(),*args) ;
		    */
		    _exit(-1) ;
		}
	    }
	    /* ↓親↓ */
	    while( Bsyflg==0 ){		/* ★ imgsaveで使うフラグを流用 ★ */
		eggx_msleep( 10 ) ;
	    }
	    if( Bsyflg==1 ){		/* 起動できない場合は，Bsyflg==-1 になる */
		rmexecfile() ;
		Bsyflg=0 ;
		break ;
	    }
	    else{	/* Bsyflg==-1 */
		i=0 ;
		while( Cpid_tmp != 0 ){
		    /* fprintf(stderr,"waiting...Pid=%d cpid=%d \n",Pid,Cpid_tmp) ; */
		    if( i==10 ){
			i=0 ;
			/* fprintf(stderr,"check child = %d\n",kill(0,Cpid_tmp)) ; */
			if( kill(0,Cpid_tmp) ){
			    /* Strange, but he died... */
			    break ;
			}
		    }
		    eggx_msleep( 10 ) ;
		    i++ ;
		}
		Bsyflg=0 ;
	    }
	} 
    }
    else{
	Pc[num].cpid=0 ;
    }
}

void plots_( void )
{
    integer x=640,y=400 ;
    gopen_( &x, &y, NULL ) ;
}

int eggx_gopen( int xsize, int ysize )
{
    integer rtnum,xs,ys ;
    xs=(integer)xsize ;
    ys=(integer)ysize ;
    gopen_( &xs, &ys, &rtnum ) ;
    return( (int)rtnum ) ;
}

void eggx_gsetinitialattributes( int flag, long att )
{
    if( flag == ENABLE ){
	Pc_attributes |= att ;
    }
    else if( flag == DISABLE ){
	Pc_attributes &= ~att ;
    }
}

void eggx_gsetborder( int wn, int width, const char *argsformat, ... )
{
    int f,nn ;
    FILE *fp ;
    va_list ap ;
    int fl=0 ;
    unsigned long pix ;
    char *color=NULL ;

    if( 0 <= width ){
	XSetWindowBorderWidth( Pc_dis, Pc[wn].win, width ) ;
	if( Pc[wn].attributes & DOCKAPP ){
	    XSetWindowBorderWidth( Pc_dis, Pc[wn].iconwin, width ) ;
	}
	fl=1 ;
    }

    if( argsformat != NULL ){
	va_start( ap, argsformat ) ;
	f=_procall_dev_null_w_open() ;
	fp=fdopen(f,"w") ;
	if( fp == NULL ){
	    fprintf(stderr,"/dev/null がオープンできません．\n") ;
	    exit(1) ;
	}
	nn=vfprintf(fp,argsformat,ap) ;
	fclose(fp) ;
	close(f) ;

	color=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
	vsprintf(color,argsformat,ap) ;
	pix = GetColor( Pc_dis, color ) ;
	XSetWindowBorder( Pc_dis, Pc[wn].win, pix ) ;
	if( Pc[wn].attributes & DOCKAPP ){
	    XSetWindowBorder( Pc_dis, Pc[wn].iconwin, pix ) ;
	}
	fl=1 ;

	va_end(ap) ;
    }
    if( fl ) XFlush( Pc_dis ) ;
    if( color != NULL ) free(color) ;
}

void eggx_gsetinitialborder( int width,
			     const char *argsformat, ... )
{
    int f,nn ;
    FILE *fp ;
    va_list ap ;
    
    if( 0 <= width ) Or_wth = width ;
    
    if( argsformat != NULL ){
	va_start( ap, argsformat ) ;
	f=_procall_dev_null_w_open() ;
	fp=fdopen(f,"w") ;
	if( fp == NULL ){
	    fprintf(stderr,"/dev/null がオープンできません．\n") ;
	    exit(1) ;
	}
	nn=vfprintf(fp,argsformat,ap) ;
	fclose(fp) ;
	close(f) ;
	
	if( Pc_bordercolor!=NULL ){
	    free(Pc_bordercolor) ;
	    Pc_bordercolor=NULL ;
	}
	Pc_bordercolor = (char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
	vsprintf(Pc_bordercolor,argsformat,ap) ;
	
	va_end(ap) ;
    }
    /*
    else{
	if( Pc_bgcolor != NULL ){
	    free(Pc_bordercolor) ;
	    Pc_bordercolor = NULL ;
	}
    }
    */
}

void eggx_gsetbgcolor( int wn, const char *argsformat, ... )
{
    int f,nn ;
    FILE *fp ;
    va_list ap ;

    char *color=NULL ;

    if( argsformat != NULL ){
	va_start( ap, argsformat ) ;
	f=_procall_dev_null_w_open() ;
	fp=fdopen(f,"w") ;
	if( fp == NULL ){
	    fprintf(stderr,"/dev/null がオープンできません．\n") ;
	    exit(1) ;
	}
	nn=vfprintf(fp,argsformat,ap) ;
	fclose(fp) ;
	close(f) ;

	color=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
	vsprintf(color,argsformat,ap) ;
	Pc[wn].bgcolor = GetColor(Pc_dis,color) ;
	XSetForeground( Pc_dis, Pc[wn].bggc, Pc[wn].bgcolor ) ;
	XSetWindowBackground( Pc_dis, Pc[wn].win, 
			      Pc[wn].bgcolor ) ;
	if( Pc[wn].attributes & DOCKAPP ){
	    XSetWindowBackground( Pc_dis, Pc[wn].iconwin, 
				  Pc[wn].bgcolor ) ;
	}

	va_end(ap) ;
    }
    if( color != NULL ) free(color) ;
}

void gsetbgcolor_( integer *wn, char *colorname )
{
    eggx_gsetbgcolor( *wn, colorname ) ;
}

void eggx_gsetinitialbgcolor( const char *argsformat, ... )
{
    int f,nn ;
    FILE *fp ;
    va_list ap ;

    if( argsformat == NULL ){
	if( Pc_bgcolor != NULL ){
	    free(Pc_bgcolor) ;
	    Pc_bgcolor = NULL ;
	}
    }
    else{
	va_start( ap, argsformat ) ;
	f=_procall_dev_null_w_open() ;
	fp=fdopen(f,"w") ;
	if( fp == NULL ){
	    fprintf(stderr,"/dev/null がオープンできません．\n") ;
	    exit(1) ;
	}
	nn=vfprintf(fp,argsformat,ap) ;
	fclose(fp) ;
	close(f) ;
	
	if( Pc_bgcolor!=NULL ){
	    free(Pc_bgcolor) ;
	    Pc_bgcolor=NULL ;
	}
	Pc_bgcolor = (char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
	vsprintf(Pc_bgcolor,argsformat,ap) ;
	
	va_end(ap) ;
    }
}

void eggx_gsetinitialparsegeometry( const char *argsformat, ... )
{

    int f,nn ;
    FILE *fp ;
    va_list ap ;

    if( argsformat == NULL ){
	if( Pc_geometry!=NULL ){
	    free(Pc_geometry) ;
	    Pc_geometry=NULL ;
	}
    }
    else{
	va_start( ap, argsformat ) ;
	f=_procall_dev_null_w_open() ;
	fp=fdopen(f,"w") ;
	if( fp == NULL ){
	    fprintf(stderr,"/dev/null がオープンできません．\n") ;
	    exit(1) ;
	}
	nn=vfprintf(fp,argsformat,ap) ;
	fclose(fp) ;
	close(f) ;
	
	if( Pc_geometry!=NULL ){
	    free(Pc_geometry) ;
	    Pc_geometry=NULL ;
	}
	Pc_geometry = (char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
	vsprintf(Pc_geometry,argsformat,ap) ;
	
	va_end(ap) ;
    }
}

void eggx_gsetinitialwinname( char *storename, char *iconname,
			      char *resname, char *classname )
{
    if( Pc_storename!=NULL ){
	free(Pc_storename) ;
	Pc_storename=NULL ;
    }
    if( Pc_iconname!=NULL ){
	free(Pc_iconname) ;
	Pc_iconname=NULL ;
    }
    if( Pc_classhint_res_name!=NULL ){
	free(Pc_classhint_res_name) ;
	Pc_classhint_res_name=NULL ;
    }
    if( Pc_classhint_res_class!=NULL ){
	free(Pc_classhint_res_class) ;
	Pc_classhint_res_class=NULL ;
    }

    if( storename != NULL )
	Pc_storename=strdup(storename) ;
    if( iconname != NULL )
	Pc_iconname=strdup(iconname) ;
    if( resname != NULL )
	Pc_classhint_res_name=strdup(resname) ;
    if( classname != NULL )
	Pc_classhint_res_class=strdup(classname) ;
}

void gsetinitialwinname_( char *storename, char *iconname,
			  char *resname, char *classname )
{
    eggx_gsetinitialwinname( storename, iconname,
			     resname, classname ) ;
}

int eggx_winname( int wn, const char *argsformat, ... )
{
    int f,nn ;
    FILE *fp ;
    va_list ap ;

    char *name=NULL ;

    va_start( ap, argsformat ) ;
    f=_procall_dev_null_w_open() ;
    fp=fdopen(f,"w") ;
    if( fp == NULL ){
	fprintf(stderr,"/dev/null がオープンできません．\n") ;
	exit(1) ;
    }
    nn=vfprintf(fp,argsformat,ap) ;
    fclose(fp) ;
    close(f) ;

    name=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
    vsprintf(name,argsformat,ap) ;
    XStoreName( Pc_dis, Pc[wn].win, name ) ;
    XSetIconName( Pc_dis, Pc[wn].win, name ) ;
    if( Pc[wn].attributes & DOCKAPP ){
	XStoreName( Pc_dis, Pc[wn].iconwin, name ) ;
	XSetIconName( Pc_dis, Pc[wn].iconwin, name ) ;
    }
    XFlush( Pc_dis ) ;

    va_end(ap) ;

    if( name != NULL ) free(name) ;
    return(nn) ;
}

/* ウィンドゥの名前を決める */
void winname_( integer *wn, char *name )
{
    XStoreName( Pc_dis, Pc[*wn].win, name ) ;
    XSetIconName( Pc_dis, Pc[*wn].win, name ) ;
    if( Pc[*wn].attributes & DOCKAPP ){
	XStoreName( Pc_dis, Pc[*wn].iconwin, name ) ;
	XSetIconName( Pc_dis, Pc[*wn].iconwin, name ) ;
    }
    XFlush( Pc_dis ) ;
}

/* Windowを設定する[0] */
void eggx_window( int wn, float xs, float ys, float xe, float ye )
{
    Pc[wn].winxs=xs ;
    Pc[wn].winxe=xe ;
    Pc[wn].winys=ys ;
    Pc[wn].winye=ye ;
    if( Pc[wn].wszx <= 1 ) Pc[wn].wicx = 1 ;
    else Pc[wn].wicx = (float)Pc[wn].wszx/ 
	     ((float)(Pc[wn].wszx)*(Pc[wn].winxe-Pc[wn].winxs)/(float)(Pc[wn].wszx-1))  ;
    if( Pc[wn].wszy <= 1 ) Pc[wn].wicy = 1 ;
    else Pc[wn].wicy = (float)Pc[wn].wszy/
	     ((float)(Pc[wn].wszy)*(Pc[wn].winye-Pc[wn].winys)/(float)(Pc[wn].wszy-1))  ;
}

void newwindow_( integer *wn, real *xs, real *ys, real *xe, real *ye )
{
    eggx_window( *wn, *xs, *ys, *xe, *ye ) ;
}

/* Windowを設定する(互換routine) */
void window_( real *xs, real *ys, real *xe, real *ye )
{
    eggx_window( Wn,*xs,*ys,*xe,*ye ) ;
}

void vport_( real *x0, real *y0, real *x1, real *y1 )
{
}

void setal_( integer *x, integer *y )
{
}

/* 端末のクリア */
void tclr_()
{
    printf("\033[H\033[2J") ;
    fflush(stdout) ;
}

void clsc_()
{
    printf("\033[H\033[2J") ;
    fflush(stdout) ;
}

/* 窓を閉じる */
void eggx_gclose( int wn )
{
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    if( Pc[wn].cpid != 0 )
	kill(Pc[wn].cpid,SIGTERM) ;
    XDestroyWindow( Pc_dis, Pc[wn].win ) ;
    if( Pc[wn].attributes & DOCKAPP )
	XDestroyWindow( Pc_dis, Pc[wn].iconwin ) ;
    XFreePixmap( Pc_dis, Pc[wn].pix[0] ) ;
    XFreePixmap( Pc_dis, Pc[wn].pix[1] ) ;
    XFreeGC( Pc_dis, Pc[wn].pxgc ) ;
    XFreeGC( Pc_dis, Pc[wn].bggc ) ;
    XFreeGC( Pc_dis, Pc[wn].gc ) ;
    XFreeFontSet(Pc_dis,Pc[wn].fontset) ;
    XFreeStringList(Pc[wn].fontset_ml) ;
    if( Pc[wn].fontstruct != NULL ){
	XFreeFont(Pc_dis,Pc[wn].fontstruct) ;
	Pc[wn].fontstruct = NULL ;
    }
    Pc[wn].fsz=-1;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
    Pc[wn].flg = 0 ;
}

void gclose_( integer *wn )
{
    eggx_gclose( *wn ) ;
}

/* すべての窓を閉じて，Xサーバと断つ */
void gcloseall_( void )
{
    int i ;
    /* 接続されてない時 */
    if( Wn < 0 ) return ;
    if( getpid()!=Pid ) return ;
    wait_child() ;	/* imgsave中は待たせる */
    iusr_end() ;
    for( i=0 ; i<Mlc ; i++ ){
	if( Pc[i].flg!=0 ){
	    eggx_gclose(i) ;
	}
    }
    if( Pc_cmap != DefaultColormap(Pc_dis,DefaultScreen(Pc_dis)) ){
	XFreeColormap(Pc_dis,Pc_cmap) ;
    }
    if( Pc_vinfo_ptr!=NULL ){
	XFree((char *)Pc_vinfo_ptr) ;
	Pc_vinfo_ptr=NULL ;
    }
    XCloseDisplay( Pc_dis ) ;	/* Xserverと断線 */
    Pc_dis=NULL ;
    Wn = -2 ;
}

/* 窓を選択する */
void selwin_( integer *wn )
{
    Wn = *wn ;
}

/* RGBで色を指定する */
void eggx_newrgbcolor( int wn, int r, int g, int b )
{
    XColor col ;
    Colormap cmap ;
    unsigned long pxl ;

    if( r<0 ) r=0 ;
    if( g<0 ) g=0 ;
    if( b<0 ) b=0 ;
    if( r>255 ) r=255 ;
    if( g>255 ) g=255 ;
    if( b>255 ) b=255 ;

    wait_child() ;
    Ihflg=1 ;
    if( Pc_depth==8 ){	/* 256色時カラーマップに登録 */
	col.green = g<<8 ;
	col.red   = r<<8 ;
	col.blue  = b<<8 ;
	cmap = Pc_cmap /* DefaultColormap( Pc_dis, 0 ) */ ;
	XAllocColor( Pc_dis, cmap, &col ) ;
	pxl=col.pixel ;
    }
    else{
	pxl  = (r>>(8-Red_depth))<<Red_sft ;
	pxl |= (g>>(8-Green_depth))<<Green_sft  ;
	pxl |= (b>>(8-Blue_depth))<<Blue_sft ;
    }
    XSetForeground( Pc_dis, Pc[wn].gc, pxl ) ;
    Ihflg=0 ;
    chkexit() ;
}

void newrgbcolor_( integer *wn, integer *pr, integer *pg, integer *pb )
{
    eggx_newrgbcolor( *wn, *pr, *pg, *pb ) ;
}

/* 直接色を指定する[1] */
void eggx_newcolor( int wn, const char *argsformat, ... )
{
    int f,nn ;
    FILE *fp ;
    va_list ap ;
    char *color=NULL ;

    if( argsformat != NULL ){
	va_start( ap, argsformat ) ;
	f=_procall_dev_null_w_open() ;
	fp=fdopen(f,"w") ;
	if( fp == NULL ){
	    fprintf(stderr,"/dev/null がオープンできません．\n") ;
	    exit(1) ;
	}
	nn=vfprintf(fp,argsformat,ap) ;
	fclose(fp) ;
	close(f) ;

	color=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
	vsprintf(color,argsformat,ap) ;

	wait_child() ;	/* imgsave中は待たせる */
	Ihflg=1 ;	/* 割り込み禁止 */
	XSetForeground( Pc_dis, Pc[wn].gc, GetColor( Pc_dis, color ) ) ;
	Ihflg=0 ;	/* 割り込み禁止解除 */
	
	va_end(ap) ;
    }
    if( color != NULL ) free(color) ;
    chkexit() ;
}

void newcolor_( integer *wn, char *color )
{
    eggx_newcolor( *wn, color ) ;
}

/* 色を指定する[2] */
void eggx_newpen( int wn, int n )
{
    char *color[16] = { "Black","White","Red","Green",
			"Blue","Cyan","Magenta","Yellow",
			"DimGray","Grey","red4","green4",
			"blue4","cyan4","magenta4","yellow4" } ;
    if( 0 <= n && n <= 15 ){
	wait_child() ;	/* imgsave中は待たせる */
	Ihflg=1 ;	/* 割り込み禁止 */
	XSetForeground( Pc_dis, Pc[wn].gc, GetColor( Pc_dis, color[n] ) ) ;
	Ihflg=0 ;	/* 割り込み禁止解除 */
	chkexit() ;
    }
}

void newpencolor_( integer *wn, integer *n )
{
    eggx_newpen( *wn, *n ) ;
}

/* 色を指定する(互換routine) */
void newpen_( integer *n )
{
    eggx_newpen( Wn, *n ) ;
}

/* 消去する */
void eggx_gclr( int wn )
{
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */

    XFillRectangle( Pc_dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].bggc, 
		   0, 0, Pc[wn].wszx, Pc[wn].wszy ) ;
    XDrawRectangle( Pc_dis, Pc[wn].pix[Pc[wn].wly], Pc[wn].bggc, 
		   0, 0, Pc[wn].wszx, Pc[wn].wszy ) ;
    if( Pc[wn].wly==Pc[wn].sly ){
	XClearWindow( Pc_dis, Pc[wn].win ) ;
	if( Pc[wn].attributes & DOCKAPP ){
	    XClearWindow( Pc_dis, Pc[wn].iconwin ) ;
	}
	XFlush( Pc_dis ) ;
    }
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void gclr_( integer *wn )
{
    eggx_gclr( *wn ) ;
}

/* 消去する(互換routine) */
void clsx_( void )
{
    eggx_gclr( Wn ) ;
}

/* 線を引く[3] */
void eggx_line( int wn, float xg, float yg, int mode )
{
    int xxg,yyg,f ;
    xyconv(wn,xg,yg,&xxg,&yyg) ;
    
    switch( mode ){
    case PENDOWN:
	wait_child() ;	/* imgsave中は待たせる */
	Ihflg=1 ;	/* 割り込み禁止 */
	f=XX_DrawLine( Pc_dis, wn, Pc[wn].plx, Pc[wn].ply, xxg, yyg ) ;
	Pc[wn].plx=xxg ;
	Pc[wn].ply=yyg ;
	if(f) XFlush( Pc_dis ) ;
	Ihflg=0 ;	/* 割り込み禁止解除 */
	chkexit() ;
	break ;
    case PENUP:
	Pc[wn].plx=xxg ;
	Pc[wn].ply=yyg ;
	break ;
    case PSET:
	Pc[wn].plx=xxg ;	/* 0.74 */
	Pc[wn].ply=yyg ;	/* 0.74 */
	wait_child() ;	/* imgsave中は待たせる */
	Ihflg=1 ;	/* 割り込み禁止 */
	f=X_DrawPoint( Pc_dis, wn, xxg, yyg ) ;
	if(f) XFlush( Pc_dis ) ;
	Ihflg=0 ;	/* 割り込み禁止解除 */
	chkexit() ;
	break ;
    }
}

void eggx_pset( int wn, float xg, float yg )
{
    int xxg,yyg,f ;
    xyconv(wn,xg,yg,&xxg,&yyg) ;
    
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    f=X_DrawPoint( Pc_dis, wn, xxg, yyg ) ;
    if(f) XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void line_( integer *wn, real *xg, real *yg, integer *mode )
{
    eggx_line( *wn, *xg, *yg, *mode ) ;
}

void pset_( integer *wn, real *xg, real *yg )
{
    eggx_pset( *wn, *xg, *yg ) ;
}

/* 線を引く(互換routine) */
void plot_( real *xg, real *yg, integer *mode )
{
    eggx_line( Wn, *xg, *yg, *mode ) ;
}

/*
typedef struct MyFont
{
  char *name;
  XFontStruct *font;
  XFontSet fontset;
  int height;
  int y;
} MyFont;
*/

/* フォントセットを生成する */
int eggx_gsetfontset( int wn, const char *argsformat, ... )
{
    XFontSetExtents *fset_extents ;
    char *ds ;
    char *fn_tmp ;
    int mc,fn_tmp_length,rtv=0 ;
    char *fontname=NULL ;

    int f,nn ;
    FILE *fp ;
    va_list ap ;

    va_start( ap, argsformat ) ;
    f=_procall_dev_null_w_open() ;
    fp=fdopen(f,"w") ;
    if( fp == NULL ){
	fprintf(stderr,"/dev/null がオープンできません．\n") ;
	exit(1) ;
    }
    nn=vfprintf(fp,argsformat,ap) ;
    fclose(fp) ;
    close(f) ;

    fontname=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
    vsprintf(fontname,argsformat,ap) ;
    
    if( Pc[wn].fontset!=NULL ){
	XFreeFontSet(Pc_dis,Pc[wn].fontset) ;
	XFreeStringList(Pc[wn].fontset_ml) ;
    }
    Pc[wn].fontset=XCreateFontSet(Pc_dis,fontname,&(Pc[wn].fontset_ml),&mc,&ds) ;
    if( Pc[wn].fontset==NULL ){
	rtv=1 ;
	/* fprintf(stderr,"Can't get font %s\n",fontname) ; */
	fn_tmp_length = strlen(fontname) + strlen(",-*--14-*") ;
	fn_tmp = (char *)_procall_xmalloc(sizeof(char)*(fn_tmp_length+1)) ;
	strcpy(fn_tmp,fontname) ;
	strcat(fn_tmp,",-*--14-*") ;
	/* fprintf(stderr,"Trying... %s\n",fn_tmp) ; */
	if (( Pc[wn].fontset = XCreateFontSet(Pc_dis, fn_tmp,
					      &(Pc[wn].fontset_ml), &mc, &ds)) == NULL) {
	    /* fprintf(stderr,"Can't get font %s\n",fn_tmp) ; */
	    /* fprintf(stderr,"Trying... fixed,-*--14-*\n") ; */
	    if (( Pc[wn].fontset = XCreateFontSet(Pc_dis, "fixed,-*--14-*",
						  &(Pc[wn].fontset_ml), &mc, &ds)) == NULL) {
		rtv=-1 ;
		/* fprintf(stderr,"ERROR: No fontset available\n") ; */
		/* exit(1) ; */
	    }
	}
	free(fn_tmp) ;
    }
    /* XFontsOfFontSet(Pc[wn].fontset, &fs_list, &sl) ; */
    /* Pc[wn].font = fs_list[0] ; */
    if( rtv != -1 ){
	fset_extents = XExtentsOfFontSet(Pc[wn].fontset) ;
	Pc[wn].fontheight = fset_extents->max_logical_extent.height ;
    }
    /* Pc[wn].fonty = Scr.StdFont.font->ascent ; */
    /* Pc[wn].entryheight = Pc[wn].fontheight + HEIGHT_EXTRA +2 ; */

    va_end(ap) ;
    if( fontname != NULL ) free(fontname) ;
    return(rtv) ;
}

void gsetfontset_( integer *wn, char *fset, integer *status )
{
    *status = (integer)eggx_gsetfontset( *wn, fset ) ;
}

/* 文字を描く[4] */
void drawstr_( integer *wn, real *xg, real *yg, real *size,
	       char *str, real *theta, integer *in_len )
{
    int fsize ;
    int xxg,yyg ;
    unsigned short font_height ;
    int i,f=0,lf=0,dlen,line=0,len=0 ;
    char *ptr,*ptr1,*nptr,*last0_ptr ;
    char *buf=NULL ;
    
    xyconv(*wn,*xg,*yg,&xxg,&yyg) ;
    if( 1.0 <= *size && *size <= 24.0 ) fsize=(int)(*size) ;
    else{
	if( *size < 1.0 ) fsize=FONTSET ;
	else fsize=24 ;
    }
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    if( Pc[*wn].fsz!=fsize ){
	if( FONTSET < fsize ){
	    if( Pc[*wn].fontstruct != NULL ){
		XFreeFont( Pc_dis, Pc[*wn].fontstruct ) ;
		Pc[*wn].fontstruct = NULL ;
	    }
	    Pc[*wn].fontstruct = XLoadQueryFont( Pc_dis, Pc_fnt[fsize-1] ) ;
	    XSetFont( Pc_dis, Pc[*wn].gc, Pc[*wn].fontstruct->fid ) ;
	}
	else{
	    XFontStruct **fs_list;
	    char **sl;
	    XGCValues gv;
	    XFontsOfFontSet(Pc[*wn].fontset, &fs_list, &sl);
	    gv.font = fs_list[0]->fid;
	    XChangeGC( Pc_dis, Pc[*wn].gc, GCFont, &gv ) ;
	}
	Pc[*wn].fsz=fsize ;
    }

    if( FONTSET < fsize )
	font_height = Pc[*wn].fontstruct->ascent + Pc[*wn].fontstruct->descent ;
    else
	font_height = Pc[*wn].fontheight ;

    if( 0 <= (*in_len) ){
	len = (*in_len) ;
	buf=(char *)_procall_xmalloc(sizeof(char)*(len+1)) ;
    }
    else{
	len = strlen(str) ;
	buf=(char *)_procall_xmalloc(sizeof(char)*(len+1)) ;
    }

    for( i=0 ; i<len ; i++ ) buf[i]=str[i] ;
    /* strncpy(buf,str,len) ; */
    buf[len]='\0' ;
    nptr = buf ;
    last0_ptr = buf + len ;
    do {
	ptr = strchr(nptr,'\n') ;
	ptr1 = strchr(nptr,'\r') ;
	if( ptr != NULL || ptr1 != NULL ){
	    if( ptr != NULL && ptr1 != NULL ){
		if( ptr1-ptr < 0 ){
		    ptr=ptr1 ;
		    lf=1 ;
		}
		else lf=2 ;
	    }
	    else{
		if( ptr1 != NULL ){
		    ptr=ptr1 ;
		    lf=1 ;
		}
		else lf=2 ;
	    }
	    dlen = ptr - nptr ;
	}
	else{
	    dlen = last0_ptr - nptr ;
	    lf=0 ;
	}
	if( 0 < dlen ){
	    if( FONTSET < fsize )
		f=X_DrawString( Pc_dis, *wn, xxg, yyg + font_height*line, nptr, dlen ) ;
	    else
		f=X_mbDrawString( Pc_dis, *wn, xxg, yyg + font_height*line, nptr, dlen ) ;
	}
	if( lf==2 ){
	    nptr = ptr + 1 ;
	    line++ ;
	}
	else if( lf==1 ){
	    nptr = ptr + 1 ;
	}
    } while( lf ) ;
    if(f) XFlush( Pc_dis ) ;

    if( buf != NULL ) free(buf) ;

    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

int eggx_drawstr( int wn, float x, float y, int size, float theta,
		  const char *argsformat, ... )
{
    int f,nn ;
    FILE *fp ;
    va_list ap ;

    char *str=NULL ;
    integer w,l ;
    real sz,xx,yy,ttheta ;

    va_start( ap, argsformat ) ;
    f=_procall_dev_null_w_open() ;
    fp=fdopen(f,"w") ;
    if( fp == NULL ){
	fprintf(stderr,"/dev/null がオープンできません．\n") ;
	exit(1) ;
    }
    nn=vfprintf(fp,argsformat,ap) ;
    fclose(fp) ;
    close(f) ;

    str=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;

    w=(integer)wn ;
    xx=(real)x ;
    yy=(real)y ;
    sz=(real)size ;
    ttheta=(real)theta ;
    vsprintf(str,argsformat,ap) ;
    l=strlen(str) ;
    drawstr_(&w,&xx,&yy,&sz,str,&ttheta,&l) ;
    
    va_end(ap) ;
    if( str != NULL ) free(str) ;
    return(nn) ;
}

/* センターシンボルを描く[5] */
void eggx_drawsym( int wn, float xg, float yg, int size, int sym )
{
    int x0,y0,x1,y1 ;
    int xx0=0,yy0=0,xx1=0,yy1=0 ;
    int hs,f=0 ;
    int xxg,yyg ;
    
    xyconv(wn,xg,yg,&xxg,&yyg) ;
    switch( sym ){
    case 1:
	hs=(int)(size/8.0) ;
	break ;
    default:
	if( sym==2 || sym==8 || sym==9 || sym==10 ){
	    hs = (int)(size/4.0) ;
	}
	else hs = (int)(size/2.0)-1 ;
	if( hs<0 ) hs=0 ;
	break ;
    }
    y0 = yyg -hs ;
    if( sym==7 ) hs = (int)(size/4.0) ;
    x0 = xxg -hs ;
    x1 = xxg +hs ;
    y1 = yyg +hs ;
    if( sym==3 || sym==6 ){
	hs = (int)((float)hs*0.7) ;
	xx0 = xxg -hs ;
	yy0 = yyg -hs ;
	xx1 = xxg +hs ;
	yy1 = yyg +hs ;
    }

    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    switch( sym ){
    case 1:
	f=XX_DrawLine( Pc_dis, wn, xxg, y0, x1, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xxg, y0, x0, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xxg, y1, x1, yyg ) ;
	X_DrawLine( Pc_dis, wn, xxg, y1, x0, yyg ) ;
	break ;
    case 2:
	f=XX_DrawLine( Pc_dis, wn, xxg, y0, xxg, y1 ) ;
	XX_DrawLine( Pc_dis, wn, x0, yyg, x1, yyg ) ;
	break ;
    case 3:
	f=XX_DrawLine( Pc_dis, wn, xxg, y0, xxg, y1 ) ;
	XX_DrawLine( Pc_dis, wn, x0, yyg, x1, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xx0, yy0, xx1, yy1 ) ;
	XX_DrawLine( Pc_dis, wn, xx1, yy0, xx0, yy1 ) ;
	break ;
    case 4:
	f=X_DrawArc( Pc_dis, wn, x0, y0, x1-x0, y1-y0, 0, 64*360 ) ;
	break ;
    case 5:
	f=XX_DrawLine( Pc_dis, wn, x0, y0, x1, y1 ) ;
	XX_DrawLine( Pc_dis, wn, x1, y0, x0, y1 ) ;
	break ;
    case 6:
	f=XX_DrawLine( Pc_dis, wn, xx0, yy0, xxg, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xx1, yy0, xxg, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xxg, yyg, xxg, y1 ) ;
	break ;
    case 7:
	f=XX_DrawLine( Pc_dis, wn, xxg, y0, xxg, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xxg, y0, x0, y1 ) ;
	XX_DrawLine( Pc_dis, wn, xxg, y0, x1, y1 ) ;
	X_DrawLine( Pc_dis, wn, x0, y1, x1, y1 ) ;	
	break ;
    case 8:
	f=XX_DrawLine( Pc_dis, wn, xxg, yyg, xxg, y0 ) ;
	XX_DrawLine( Pc_dis, wn, x0, y0, x1, y0 ) ;
	XX_DrawLine( Pc_dis, wn, x1, y0, x1, y1 ) ;
	XX_DrawLine( Pc_dis, wn, x1, y1, x0, y1 ) ;
	X_DrawLine( Pc_dis, wn, x0, y1, x0, y0 ) ;
	break ;
    case 9:
	f=XX_DrawLine( Pc_dis, wn, x0, y0, x1, y1 ) ;
	XX_DrawLine( Pc_dis, wn, x1, y0, x0, y1 ) ;
	X_DrawLine( Pc_dis, wn, x0, y0, x1, y0 ) ;
	break ;
    case 10:
	f=XX_DrawLine( Pc_dis, wn, xxg, y0, xxg, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xxg, y0, x1, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xxg, y0, x0, yyg ) ;
	XX_DrawLine( Pc_dis, wn, xxg, y1, x1, yyg ) ;
	X_DrawLine( Pc_dis, wn, xxg, y1, x0, yyg ) ;
	break ;
    }
    if(f) XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void drawsym_( integer *wn, real *xg, real *yg, real *size, integer *sym )
{
    eggx_drawsym( *wn, *xg, *yg, *size, *sym ) ;
}

/* センターシンボルを描く(互換routine) */
void symbol_( real *xg, real *yg, real *size, 
	      void *k, real *theta, integer *len )
{
    integer *sym ;
    char *str ;
    if( *len < 0 ){
	sym = (integer *)k ;
	drawsym_( &(Wn),xg,yg,size,sym ) ;
    }
    else {
	str = (char *)k ;
	drawstr_( &(Wn),xg,yg,size,str,theta,len ) ;
    }
}

static int podr( integer n )
{
    int rt=1 ;
    if( n==0 ) return(0) ;
    while( (n/=10)!=0 ) rt++ ;
    return(rt) ;
}
/* 変数を文字列に変換する */
/* 引き数: 変数，小数点数 */
static char *rtoc( real *v, integer *n )
{
    static int mlc=0,mlc1=0 ;
    static char *adr,*fmt ;
    int f,nn ;
    float vv ;
    FILE *fp ;

    if( -1 <= *n ) vv=*v ;
    else vv = *v*pow(10,1+*n) ;
    if( mlc==0 ){
	mlc = STRMLC ;
	mlc1 = STRMLC ;
	adr=(char *)_procall_xmalloc(sizeof(char)*mlc) ;
	fmt=(char *)_procall_xmalloc(sizeof(char)*mlc1) ;
    }
    while( 1 ){
	if( 0 < *n ){
	    if( podr(*n)+4<=mlc1 ){
		sprintf(fmt,"%%.%df",(int)(*n)) ;
		f=0 ;
	    }
	    else f=-1 ;
	}
	else{
	    if( *n==0 ) sprintf(fmt,"%%.0f.") ;
	    else sprintf(fmt,"%%.0f") ;
      	    break ;
	}
	if( f!=-1 ) break ;
	mlc1+=STRMLC ;
	fmt=(char *)_procall_xrealloc(fmt,sizeof(char)*mlc1) ;
    }
    /* 書き込まれる文字数をテストする */
    f=_procall_dev_null_w_open() ;
    fp=fdopen(f,"w") ;
    if( fp == NULL ){
	fprintf(stderr,"/dev/null がオープンできません．\n") ;
	exit(1) ;
    }
    nn=fprintf(fp,fmt,vv) ;
    fclose(fp) ;
    close(f) ;
    while( mlc<=nn ){
	mlc+=STRMLC ;
	adr=(char *)_procall_xrealloc(adr,sizeof(char)*mlc) ;
    }
    sprintf(adr,fmt,vv) ;
    return( adr ) ;
}

/* 変数を文字列に変換(ProFORTRAN式) */
/* 変数,小数点数,文字数,格納先,あまり文字数 */
void rtoc_( real *v, integer *n, integer *dn, char *dist, integer *m )
{
    char *adr ;
    adr=rtoc( v, n ) ;
    strncpy( dist, adr, *dn-1 ) ;
    dist[*dn-1]='\0' ;
    *m=*dn-1-strlen(adr) ;
}

/* 変数の値を描く[6] */
void drawnum_( integer *wn, real *xg, real *yg, real *size, 
	       real *v, real *theta, integer *n )
{
    char *adr ;
    integer len ;
    adr = rtoc( v, n ) ;
    len = strlen(adr) ;
    drawstr_( wn, xg, yg, size, adr, theta, &len ) ;
}

/* 変数の値を描く(互換routine) */
void number_( real *xg, real *yg, real *size, 
	      real *v, real *theta, integer *n )
{
    drawnum_( &(Wn), xg,yg,size,v,theta,n ) ;
}

static int dwtop( int wn, int si, int sj,
		  int xx[], int yy[], 
		  int x1[], int y1[],
		  int x2[], int y2[],
		  int x3[], int y3[] )
{
    int i=1 ;
    int f=0 ;
    XPoint points[3] ;
    do{
	switch(sj){
	case 1:
	    f |= XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x1[i],y1[i] ) ;
	    XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x2[i],y2[i] ) ;
	    X_DrawLine( Pc_dis, wn, x1[i],y1[i],x2[i],y2[i] ) ;
	    break ;
	case 2:
	    f |= XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x1[i],y1[i] ) ;
	    XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x2[i],y2[i] ) ;
	    X_DrawLine( Pc_dis, wn, x1[i],y1[i],x2[i],y2[i] ) ;
	    if( si==0 ) X_DrawLine( Pc_dis, wn, xx[i],yy[i],x3[i],y3[i] ) ;
	    break ;
	case 3:
	    f |= XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x1[i],y1[i] ) ;
	    XX_DrawLine( Pc_dis, wn, x1[i],y1[i],x3[i],y3[i] ) ;
	    if( si==0 ) X_DrawLine( Pc_dis, wn, xx[i],yy[i],x3[i],y3[i] ) ;
	    break ;
	case 4:
	    f |= XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x1[i],y1[i] ) ;
	    XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x2[i],y2[i] ) ;
	    if( si==0 ) XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x3[i],y3[i] ) ;
	    break ;
	case 5:
	    f |= XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x1[i],y1[i] ) ;
	    if( si==0 ) XX_DrawLine( Pc_dis, wn, xx[i],yy[i],x3[i],y3[i] ) ;
	    break ;
	case 6:
	    points[0].x=xx[i] ;
	    points[0].y=yy[i] ;
	    points[1].x=x1[i] ;
	    points[1].y=y1[i] ;
	    points[2].x=x2[i] ;
	    points[2].y=y2[i] ;
	    f |= X_FillPolygon( Pc_dis,wn,points,3,Convex,CoordModeOrigin) ;
	    break ;
	case 7:
	    points[0].x=xx[i] ;
	    points[0].y=yy[i] ;
	    points[1].x=x1[i] ;
	    points[1].y=y1[i] ;
	    points[2].x=x3[i] ;
	    points[2].y=y3[i] ;
	    f |= X_FillPolygon( Pc_dis,wn,points,3,Convex,CoordModeOrigin) ;
	    break ;
	}
    } while( --i > 1-si ) ;
    return(f) ;
}

/* 矢印を描く[7] */
void eggx_drawarrow( int wn, float xs, float ys, float xt, float yt, 
		     float s, float w, int shape )
{
    int xx[2],yy[2] ;
    int si,sj ;		/* shape */
    float r ;
    float ss,ww ;
    float theta,phi ;
    float xl,yl ;
    int x1[2],x2[2],y1[2],y2[2],x3[2],y3[2] ;
    int rx1,rx2,ry1,ry2,rx3,ry3 ;
    int f=0 ;

    xyconv( wn,xs,ys,xx,yy ) ;
    xyconv( wn,xt,yt,xx+1,yy+1 ) ;
    xl = xx[0]-xx[1] ;
    yl = yy[0]-yy[1] ;
    if( shape<100 ){
	ss=s ;
	ww=w/2.0 ;
	si = shape/10 ;
    }
    else {
	ww = sqrt(xl*xl+yl*yl) ;
	ss = ww * s ;
	ww *= w ;
	ww /= 2.0 ;
	si = shape/10-10 ;
    }
	sj = shape % 10 ;
    r  = sqrt( ss*ss+ww*ww ) ;
    theta = atan2(yl,xl) ;
    phi = atan2(ww,ss) ;
    x1[1] = xx[1] + (rx1=r*cos(theta-phi)) ;
    y1[1] = yy[1] + (ry1=r*sin(theta-phi)) ;
    x2[1] = xx[1] + (rx2=r*cos(theta+phi)) ;
    y2[1] = yy[1] + (ry2=r*sin(theta+phi)) ;
    x3[1] = xx[1] + (rx3=r*cos(theta)) ;
    y3[1] = yy[1] + (ry3=r*sin(theta)) ;
    if( si==2 ){
	x1[0] = xx[0] - rx1 ;
	y1[0] = yy[0] - ry1 ;
	x2[0] = xx[0] - rx2 ;
	y2[0] = yy[0] - ry2 ;
	x3[0] = xx[0] - rx3 ;
	y3[0] = yy[0] - ry3 ;
    }
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    f |= dwtop( wn, si, sj, xx,yy,x1,y1,x2,y2,x3,y3 ) ;
    switch( si ){
    case 1:
	if( 2<=sj ){
	    f |= X_DrawLine( Pc_dis, wn, xx[0],yy[0],xx[1],yy[1] ) ;
	}
	else f |= X_DrawLine( Pc_dis, wn, xx[0],yy[0],x3[1],y3[1] ) ;
	f |= X_DrawPoint( Pc_dis, wn, xx[0], yy[0] ) ;
	break ;
    case 2:
	if( 2<=sj ){
	    f |= X_DrawLine( Pc_dis, wn, xx[0],yy[0],xx[1],yy[1] ) ;
	}
	else f |= X_DrawLine( Pc_dis, wn, x3[0],y3[0],x3[1],y3[1] ) ;
	break ;
    }
    if(f) XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void drawarrow_( integer *wn, real *xs, real *ys, real *xt, real *yt,
		 real *s, real *w, integer *shape )
{
    eggx_drawarrow( *wn, *xs, *ys, *xt, *yt, 
		    *s, *w, *shape ) ;
}

/* 矢印を描く(互換routine) */
void arohd_( real *xs, real *ys, real *xt, real *yt,
	     real *s, real *w, integer *shape )
{
    eggx_drawarrow( Wn ,*xs,*ys,*xt,*yt,*s,*w,*shape ) ;
}

/* 円弧を塗り潰す */
void eggx_fillarc( int wn, float xcen, float ycen, float xrad, float yrad,
		   float sang, float eang, int idir )
{
    int sa,da ;
    int x0,y0,x1,y1,xsize,ysize ;

    xyconv(wn,xcen-xrad,ycen-yrad,&x0,&y0) ;
    xyconv(wn,xcen+xrad,ycen+yrad,&x1,&y1) ;
    xsize=abs(x1-x0) ;
    ysize=abs(y1-y0) ;
    if( x1<x0 ) x0=x1 ;
    if( y1<y0 ) y0=y1 ;
    
    if( idir == -1 ){
	sa=sang*64.0 ;
	if( eang<sang ) da=-sa+ eang*64 ;
	else da=-sa-(360-eang)*64 ;
    }
    else{
	sa=sang*64.0 ;
	da=eang*64.0-sa ;
    }
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    if( X_FillArc( Pc_dis, wn, x0, y0, xsize, ysize, sa, da ) )
	XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void fillarc_( integer *wn, real *xcen, real *ycen, real *xrad, real *yrad,
	       real *sang, real *eang, integer *idir )
{
    eggx_fillarc( *wn, *xcen, *ycen, *xrad, *yrad,
		  *sang, *eang, *idir ) ;
}

/* 円弧を描く[8] */
void eggx_drawarc( int wn, float xcen, float ycen, float xrad, float yrad, 
		   float sang, float eang, int idir )
{
    int sa,da ;
    int x0,y0,x1,y1,xsize,ysize ;

    xyconv(wn,xcen-xrad,ycen-yrad,&x0,&y0) ;
    xyconv(wn,xcen+xrad,ycen+yrad,&x1,&y1) ;
    xsize=abs(x1-x0) ;
    ysize=abs(y1-y0) ;
    if( x1<x0 ) x0=x1 ;
    if( y1<y0 ) y0=y1 ;
    
    if( idir == -1 ){
	sa=sang*64.0 ;
	if( eang < sang ) da=-sa+ eang*64 ;
	else da=-sa-(360-eang)*64 ;
    }
    else{
	sa=sang*64.0 ;
	da=eang*64.0-sa ;
    }
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    if( X_DrawArc( Pc_dis, wn, x0, y0, xsize, ysize, sa, da ) )
	XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void eggx_circle( int wn, float xcen, float ycen, float xrad, float yrad ) 
{
    eggx_drawarc( wn,xcen,ycen,xrad,yrad,0,360,1 ) ;
}

void drawarc_( integer *wn, real *xcen, real *ycen, real *xrad, real *yrad,
	       real *sang, real *eang, integer *idir )
{
    eggx_drawarc( *wn, *xcen, *ycen, *xrad, *yrad, 
		  *sang, *eang, *idir ) ;
}

void drawcirc_( integer *wn, real *xcen, real *ycen, real *xrad, real *yrad )
{
    eggx_drawarc( *wn, *xcen, *ycen, *xrad, *yrad, 0,360,1 ) ;
}

/* 円弧を描く(互換routine) */
void arc_( real *xcen, real *ycen, real *rad,
	   real *sang, real *eang, integer *idir )
{
    eggx_drawarc( Wn,*xcen,*ycen,*rad,*rad,*sang,*eang,*idir ) ;
}

/* 円弧を描く(互換routine) */
void circ1_( real *xcen, real *ycen, real *rad )
{
    eggx_drawarc( Wn,*xcen,*ycen,*rad,*rad,0,360,1) ;
}

/* 長方形を描く */
void eggx_drawrect( int wn, float x, float y, float w, float h )
{
    int x0,y0,x1,y1,xs,ys,width,height ;
    xyconv( wn,x,y,&x0,&y0 ) ;
    xyconv( wn,x+w,y+h,&x1,&y1 ) ;
    if( x0<x1 ) xs=x0 ;
    else xs=x1 ;
    if( y0<y1 ) ys=y0 ;
    else ys=y1 ;
    width=abs(x1-x0) ;
    height=abs(y1-y0) ;
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    if( X_DrawRectangle( Pc_dis,wn,xs,ys,width,height ) )
	XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void drawrect_( integer *wn, real *x, real *y, real *w, real *h )
{
    eggx_drawrect( *wn, *x, *y, *w, *h ) ;
}

/* 長方形を塗り潰す */
void eggx_fillrect( int wn, float x, float y, float w, float h )
{
    int x0,y0,x1,y1,xs,ys,width,height,f ;
    xyconv( wn,x,y,&x0,&y0 ) ;
    xyconv( wn,x+w,y+h,&x1,&y1 ) ;
    if( x0<x1 ) xs=x0 ;
    else xs=x1 ;
    if( y0<y1 ) ys=y0 ;
    else ys=y1 ;
    width=abs(x1-x0) ;
    height=abs(y1-y0) ;
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    f=X_FillRectangle( Pc_dis,wn,xs,ys,width,height ) ;
    /* X_DrawRectangle( Pc_dis,*wn,xs,ys,width,height ) ; */
    if(f) XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void fillrect_( integer *wn, real *x, real *y, real *w, real *h )
{
    eggx_fillrect( *wn, *x, *y, *w, *h ) ;
}

/* 多角形を塗り潰す */
void eggx_fillpoly( int wn, float x[], float y[], int n, int shape )
{
    int sh=Complex ;
    int xx,yy,i ;
    XPoint *points=NULL ;
    points = (XPoint *)_procall_xmalloc(sizeof(XPoint)*n) ;
    for( i=0 ; i<n ; i++ ){
	xyconv( wn,x[i],y[i],&xx,&yy ) ;
	points[i].x=xx ;
	points[i].y=yy ;
    }
    if( shape ) sh=Convex ;
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    if( X_FillPolygon( Pc_dis,wn,points,n,sh,CoordModeOrigin) )
	XFlush( Pc_dis ) ;
    Ihflg=0 ;	/* 割り込み禁止解除 */
    if( points != NULL ) free(points) ;
    chkexit() ;
}

void fillpoly_( integer *wn, real x[], real y[], integer *n, integer *shape )
{
    int i ;
    float *xx ;
    float *yy ;
    xx=(float *)_procall_xmalloc(sizeof(float)*(*n)) ;
    yy=(float *)_procall_xmalloc(sizeof(float)*(*n)) ;
    for( i=0 ; i < *n ; i++ ) xx[i] = (float)(x[i]) ;
    for( i=0 ; i < *n ; i++ ) yy[i] = (float)(y[i]) ;
    eggx_fillpoly( *wn, xx, yy, *n, *shape ) ;
    free(yy) ;
    free(xx) ;
}

void eggx_copylayer( int wn, int src, int dst )
{
    XGCValues gv ;
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */

    gv.tile = Pc[wn].pix[src] ;
    XChangeGC( Pc_dis, Pc[wn].pxgc, GCTile, &gv ) ;

    XFillRectangle( Pc_dis, Pc[wn].pix[dst], Pc[wn].pxgc, 
		    0,0, Pc[wn].wszx,Pc[wn].wszy ) ;
    if( dst == Pc[wn].sly ){
	XFillRectangle( Pc_dis, Pc[wn].win, Pc[wn].pxgc, 
			0,0, Pc[wn].wszx,Pc[wn].wszy ) ;
	if( Pc[wn].attributes & DOCKAPP ){
	    XFillRectangle( Pc_dis, Pc[wn].iconwin, Pc[wn].pxgc, 
			    0,0, Pc[wn].wszx,Pc[wn].wszy ) ;
	}
	XFlush( Pc_dis ) ;
    }

    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
}

void copylayer_( integer *wn, integer *src, integer *dst )
{
    eggx_copylayer( *wn, *src, *dst ) ;
}

/* 表示，書き込むレイヤを選択する．sly:表示 wly:書込 */
void eggx_layer( int wn, int _sly, int _wly )
{
    int sl=0,wl=0 ;
    if( _sly!=0 ) sl=1 ;
    if( _wly!=0 ) wl=1 ;
    if( sl != Pc[wn].sly ){
	XGCValues gv ;
	wait_child() ;	/* imgsave中は待たせる */
	Ihflg=1 ;	/* 割り込み禁止 */
	if( Pc[wn].cpid != 0 ){
	    if( sl ) kill(Pc[wn].cpid,SIGUSR2) ;
	    else kill(Pc[wn].cpid,SIGUSR1) ;
	}
	gv.tile = Pc[wn].pix[sl] ;
	XChangeGC( Pc_dis, Pc[wn].pxgc, GCTile, &gv ) ;
	XFillRectangle( Pc_dis, Pc[wn].win, Pc[wn].pxgc, 
			0,0, Pc[wn].wszx,Pc[wn].wszy ) ;
	if( Pc[wn].attributes & DOCKAPP ){
	    XFillRectangle( Pc_dis, Pc[wn].iconwin, Pc[wn].pxgc, 
			    0,0, Pc[wn].wszx,Pc[wn].wszy ) ;
	}
	XFlush( Pc_dis ) ;
	Ihflg=0 ;	/* 割り込み禁止解除 */
	chkexit() ;
    }
    Pc[wn].sly = sl ;
    Pc[wn].wly = wl ;
}

void layer_( integer *wn, integer *sly, integer *wly )
{
    eggx_layer( *wn, *sly, *wly ) ;
}

/* for C... */
int eggx_putimg24( int wn, float x, float y,
		   int width, int height, unsigned char *buf )
{
    XImage image ;
    int xx,yy ;
    unsigned char *tbuf = NULL ;
    if( Pc_depth < 16 ) return(-1) ;
    xyconv( wn,x,y,&xx,&yy ) ;
    yy-=height-1 ;
    image.format           = ZPixmap ;
    image.width            = width ;
    image.height           = height ;
    image.xoffset          = 0 ;
    image.byte_order       = MSBFirst ;
    image.bitmap_bit_order = MSBFirst ;
    if( 16 < Pc_depth ){	/* 24bppの場合 */
	image.bits_per_pixel   = 32 ;
	image.bytes_per_line   = width*4 ;
	image.bitmap_unit      = 32 ;
	image.bitmap_pad       = 32 ;
	image.depth            = 24 ;
	if( Red_sft==16 && Green_sft==8 && Blue_sft==0 ){
	    image.data             = (char *)buf ;
	}
	else{
	    int i,j,k,fm=0 ;
	    if( Red_sft != 24 && Green_sft != 24 && Blue_sft != 24 ) fm = 0 ;
	    else if( Red_sft != 0 && Green_sft != 0 && Blue_sft != 0 ) fm = 3 ;
	    else if( Red_sft != 8 && Green_sft != 8 && Blue_sft != 8 ) fm = 2 ;
	    else if( Red_sft != 16 && Green_sft != 16 && Blue_sft != 16 ) fm = 1 ;
 
	    tbuf=(unsigned char *)_procall_xmalloc(sizeof(unsigned char)*width*height*4) ;
	    image.data             = (char *)tbuf ;
	    for( j=0,i=0,k=0 ; i<width*height ; i++ ){
		k++ ;
		tbuf[j+3-Red_sft/8] = buf[k++] ;
		tbuf[j+3-Green_sft/8] = buf[k++] ;
		tbuf[j+3-Blue_sft/8] = buf[k++] ;
		tbuf[j+fm] = 0 ;
		j+=4 ;
	    }
	}
    }
    else{
	int i,j,k ;
	image.bits_per_pixel   = 16 ;
	image.bytes_per_line   = width*2 ;
	image.bitmap_unit      = 16 ;
	image.bitmap_pad       = 16 ;
	image.depth            = 16 ;

	tbuf=(unsigned char *)_procall_xmalloc(sizeof(unsigned char)*width*height*2) ;
	image.data             = (char *)tbuf ;
	for( j=0,i=0,k=0 ; i<width*height ; i++ ){
	    unsigned short tmp_img = 0 ;
	    k++ ;
	    tmp_img |=
		(buf[k++] >> (8-Red_depth)) << Red_sft ;
	    tmp_img |=
		(buf[k++] >> (8-Green_depth)) << Green_sft ;
	    tmp_img |=
		(buf[k++] >> (8-Blue_depth)) << Blue_sft ;
	    tbuf[j++] = (unsigned char)(tmp_img >> 8) ;
	    tbuf[j++] = (unsigned char)(tmp_img & 0x0ff) ;
	}
    }
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    XPutImage( Pc_dis,Pc[wn].pix[Pc[wn].wly],Pc[wn].gc,
	       &image,0,0,xx,yy,width,height) ;
    if( Pc[wn].wly==Pc[wn].sly ){
	XGCValues gv ;
	gv.tile = Pc[wn].pix[Pc[wn].wly] ;
	XChangeGC( Pc_dis, Pc[wn].pxgc, GCTile, &gv ) ;
	XFillRectangle( Pc_dis, Pc[wn].win, Pc[wn].pxgc, 
			0,0, Pc[wn].wszx,Pc[wn].wszy ) ;
	if( Pc[wn].attributes & DOCKAPP ){
	    XFillRectangle( Pc_dis, Pc[wn].iconwin, Pc[wn].pxgc, 
			    0,0, Pc[wn].wszx,Pc[wn].wszy ) ;
	}
	XFlush( Pc_dis ) ;
    }
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
    if( tbuf != NULL ){
	free(tbuf) ;
	tbuf=NULL ;
    }
    return(0) ;
}

/* for FORTRAN */
void putimg24_( integer *wn, real *x, real *y,
		integer *width, integer *height, integer *buf )
{
    unsigned char *lbuf ;
    unsigned char *cadr ;
    integer *ladr ;
    int i,n ;

    n=(*width)*(*height) ;
    lbuf=(unsigned char *)_procall_xmalloc(sizeof(unsigned char)*n*4) ;
    cadr=lbuf ;
    ladr=buf ;
    for( i=0 ; i<n ; i++ ){
	*cadr++=0 ;
	*cadr++=(unsigned char)(*ladr++) ;
	*cadr++=(unsigned char)(*ladr++) ;
	*cadr++=(unsigned char)(*ladr++) ;
    }
    if( eggx_putimg24( *wn,*x,*y,*width,*height,lbuf ) == -1 ){
	fprintf(stderr,"X サーバの depth が 16 以上ではありません．\n") ;
    }
    free(lbuf) ;
}

int eggx_ggetxpress( int wn, int *code, float *x, float *y )
{
    int rt=0 ;
    XEvent ev;
    KeySym key;
    char string[8] ;
    wait_child() ;	/* imgsave中は待たせる */
    Ihflg=1 ;	/* 割り込み禁止 */
    XSelectInput( Pc_dis, Pc[wn].win, ButtonPressMask|KeyPressMask );
    while(1){
	XNextEvent( Pc_dis, &ev );
	if( ev.type == ButtonPress ){
	    *code = ev.xbutton.button ;
	    *x = (float)(ev.xbutton.x) / Pc[wn].wicx + Pc[wn].winxs ;
	    *y = (float)(Pc[wn].wszy-1-ev.xbutton.y) / Pc[wn].wicy + Pc[wn].winys ;
	    rt = ButtonPress ;
	    break ;
	}
	else if( ev.type == KeyPress ){
	    XLookupString((XKeyEvent *)&ev,string,sizeof(string),&key,NULL) ;
	    /* printf("[%X]",key) ;  fflush(stdout) ; */
	    switch( key ){
	    case XK_Right:		/* カーソルキーを 1c〜1fに割り当てる */
		*code = 0x01c ;
		break ;
	    case XK_KP_Right:
		*code = 0x01c ;
		break ;
	    case XK_Left:
		*code = 0x01d ;
		break ;
	    case XK_KP_Left:
		*code = 0x01d ;
		break ;
	    case XK_Up:
		*code = 0x01e ;
		break ;
	    case XK_KP_Up:
		*code = 0x01e ;
		break ;
	    case XK_Down:
		*code = 0x01f ;
		break ;
	    case XK_KP_Down:
		*code = 0x01f ;
		break ;
	    case XK_Page_Up:		/* PageUp,PageDown を Ctrl+B,Ctrl+F に割り当てる */
		*code = 0x002 ;
		break ;
	    case XK_KP_Page_Up:
		*code = 0x002 ;
		break ;
	    case XK_Page_Down:
		*code = 0x006 ;
		break ;
	    case XK_KP_Page_Down:
		*code = 0x006 ;
		break ;
	    case XK_Home:		/* Home,End を Ctrl+A,Ctrl+E に割り当てる */
		*code = 0x001 ;
		break ;
	    case XK_KP_Home:
		*code = 0x001 ;
		break ;
	    case XK_End:
		*code = 0x005 ;
		break ;
	    case XK_KP_End:
		*code = 0x005 ;
		break ;
	    case XK_Pause:		/* Pause を Ctrl+C に割り当てる */
		*code = 0x003 ;
		break ;
	    case XK_KP_Delete:
		*code = 0x07f ;
		break ;
	    default:
		*code = string[0] ;
		break ;
	    }
	    if( *code != 0 ){
		rt = KeyPress ;
		break ;
	    }
	}	/* else if... */
    }	/* while(1)... */
    XSelectInput( Pc_dis, Pc[wn].win, 0 );
    Ihflg=0 ;	/* 割り込み禁止解除 */
    chkexit() ;
    return( rt ) ;
}

void ggetxpress_( integer *wn, integer *type, integer *code, real *x, real *y )
{
    float xx ;
    float yy ;
    int i_code ;
    *type = (integer)eggx_ggetxpress(*wn,&i_code,&xx,&yy) ;
    *code = (integer)i_code ;
    *x = (real)xx ;
    *y = (real)yy ;
}

int eggx_ggetch( int wn )
{
    int rt ;
    float x,y ;
    while( eggx_ggetxpress(wn,&rt,&x,&y) != KeyPress ) ;
    return(rt) ;
}

void ggetch_( integer *wn, integer *rt )
{
    *rt = (integer)eggx_ggetch( *wn ) ;
}

void inkeydollar_( integer *wn, integer *rt )
{
    *rt = (integer)eggx_ggetch( *wn ) ;
}

/* バックグラウンドで画像をsaveする(C言語) */
int eggx_saveimg( int wn, int ly, float xs, float ys, float xe, float ye, 
		  char *filter, int depth, const char *argsformat, ... )
{
    char *fn=NULL,*tmp1=NULL ;
    char **args=NULL ;
    int sx0,sy0,sx1,sy1,width,height ;
    int i,j,mlc=8 ;
    int dpt,rtv=0 ;

    int f,nn ;
    FILE *fp ;
    va_list ap ;

    char **args_c=NULL ;
    char ag1[16],ag2[16],ag3[16],ag4[16] ;
    char ag5[16],ag6[16],ag7[16],ag8[16] ;
    
    wait_child() ;

    XFlush( Pc_dis ) ;
    XSync( Pc_dis,0 ) ;

    /* ファイル名を作る */
    va_start( ap, argsformat ) ;
    f=_procall_dev_null_w_open() ;
    fp=fdopen(f,"w") ;
    if( fp == NULL ){
	fprintf(stderr,"/dev/null がオープンできません．\n") ;
	exit(1) ;
    }
    nn=vfprintf(fp,argsformat,ap) ;
    fclose(fp) ;
    close(f) ;
    fn=(char *)_procall_xmalloc(sizeof(char)*(nn+1)) ;
    vsprintf(fn,argsformat,ap) ;
    va_end(ap) ;

    /* 座標 */
    xyconv(wn,xs,ys,&sx0,&sy0) ;
    xyconv(wn,xe,ye,&sx1,&sy1) ;

    /* 座標チェック */
    if( Pc[wn].wszx <= sx0 ) sx0=Pc[wn].wszx-1 ;
    if( Pc[wn].wszx <= sx1 ) sx1=Pc[wn].wszx-1 ;
    if( Pc[wn].wszy <= sy0 ) sy0=Pc[wn].wszy-1 ;
    if( Pc[wn].wszy <= sy1 ) sy1=Pc[wn].wszy-1 ;
    if( sx0<0 ) sx0=0 ;
    if( sx1<0 ) sx1=0 ;
    if( sy0<0 ) sy0=0 ;
    if( sy1<0 ) sy1=0 ;
    width=abs(sx1-sx0)+1 ;
    height=abs(sy1-sy0)+1 ;
    if( sx1<sx0 ) sx0=sx1 ;
    if( sy1<sy0 ) sy0=sy1 ;

    i=0 ;
    if( *filter!='\0' ){		/* コンバートする */
	/* argsの作成 */
	tmp1=strdup(filter) ;
	args=(char **)_procall_xmalloc(sizeof(char *)*mlc) ;
	args[i++]=strtok(tmp1," ") ;
	while( (args[i++]=strtok(NULL," "))!=NULL ){
	    if( mlc==i ){
		mlc += 8 ;
		args=(char **)_procall_xrealloc(args,sizeof(char *)*mlc) ;
	    }
	}
    }
    dpt= 65536/depth ;
    
    args_c=(char **)_procall_xmalloc(sizeof(char *)*(11+i+1)) ;
    sprintf(ag1,"%ld",(long)Pid) ;
    sprintf(ag2,"%ld",Pc[wn].pix[(ly)]) ;
    sprintf(ag3,"%d",sx0) ;
    sprintf(ag4,"%d",sy0) ;
    sprintf(ag5,"%d",width) ;
    sprintf(ag6,"%d",height) ;
    sprintf(ag7,"%d",dpt) ;
    sprintf(ag8,"%ld",(unsigned long)Pc_cmap) ;
    args_c[0]=Exec_slave_tmp ;
    args_c[1]="2" ;
    args_c[2]=ag1 ;
    args_c[3]=ag2 ;
    args_c[4]=ag3 ;
    args_c[5]=ag4 ;
    args_c[6]=ag5 ;
    args_c[7]=ag6 ;
    args_c[8]=ag7 ;
    args_c[9]=ag8 ;
    args_c[10]=fn ;
    for( j=0 ; j<i ; j++ ){
	args_c[11+j]=args[j] ;
    }
    args_c[11+j]=NULL ;
        
    while(1){
	if( mkexecfile() == -1 ){
	    fprintf(stderr,"/tmp/ にファイルが作成できません．\n") ;
	    rtv=-1 ;
	    goto quit ;
	}
	if( Exec_fd != -1 ){
	    close(Exec_fd);
	    Exec_fd=-1 ;
	}
	if( (Cpid_imgsave=fork())<0 ){
	    fprintf(stderr,"子プロセスの生成に失敗しました．\n") ;
	    rtv=-1 ;
	    goto quit ;
	}
	if( Cpid_imgsave==0 ){
	    /* 子プロセス */
	    if( execv(*args_c,args_c)==-1){
		if( Pid == getppid() )
		    kill(Pid,SIGUSR2) ;
		/* fprintf(stderr,"file not found: %s\n",Exec_slave_tmp) ; */
		_exit(-1) ;
	    }
	}
	while( Bsyflg == 0 ){
	    eggx_msleep( 10 ) ;
	}
	if( Bsyflg==1 ){	/* 起動できない場合は，Bsyflg==-1 になる */
	    rmexecfile() ;
	    break ;
	}
	else{	/* Bsyflg==-1 */
	    i=0 ;
	    while( Cpid_imgsave != 0 ){
		/* fprintf(stderr,"waiting...Pid=%d cpid=%d \n",Pid,Cpid_imgsave) ; */
		if( i==10 ){
		    i=0 ;
		    /* fprintf(stderr,"check child = %d\n",kill(0,Cpid_tmp)) ; */
		    if( kill(0,Cpid_imgsave) ){
			/* Strange, but he died... */
			break ;
		    }
		}
		eggx_msleep( 10 ) ;
		i++ ;
	    }
	    Bsyflg=0 ;
	}
    }
 quit:
    if( args_c!=NULL ) free(args_c) ;
    if( args!=NULL ) free(args) ;
    if( tmp1!=NULL ) free(tmp1) ;
    if( fn!=NULL ) free(fn) ;
    return(rtv) ;
}

/* FORTRAN用 saveimg */
void saveimg_( integer *wn, integer *ly, real *xs, real *ys, real *xe, real *ye,
	       char *fname, integer *cnt, char *filter, integer *depth )
{
    char *tmp=NULL,*tmp1,*tmp2 ;
    tmp=strdup(fname) ;
    tmp1=strrchr(tmp,'.') ;
    if( tmp1!=NULL ){
	*tmp1='\0' ;
	tmp1=tmp ;
	tmp2=strrchr(fname,'.') ;
    }
    else{
	tmp1=tmp ;
	tmp2=tmp+strlen(tmp) ;
    }
    if( -1< *cnt ){
	eggx_saveimg( *wn, *ly, *xs, *ys, *xe, *ye,
		      filter, *depth, "%s%d%s",tmp1,(int)(*cnt),tmp2 ) ;
    }
    else{
	eggx_saveimg( *wn, *ly, *xs, *ys, *xe, *ye,
		      filter, *depth, "%s",fname ) ;
    }
    if( tmp!=NULL ) free(tmp) ;
}

/* ========================== */
/* ここからはFORTRANの不便さを解消するための関数 */
void isnan_( real *value, integer *flag )
{
    int rtf ;
    rtf = isnan( *value ) ;
    rtf |= ISINF( *value ) ;
    *flag = (integer)rtf ;
}

void eggx_msleep( unsigned long msec )
{
#ifndef NO_USLEEP
    unsigned long t ;
    t=(unsigned long)(msec*1000) ;
    usleep( t ) ;
#else
    int rt ;
    struct timeval delay ;
    delay.tv_sec = (msec*1000) / 1000000L ;
    delay.tv_usec = (msec*1000) % 1000000L ;
    rt = select(0,
		(fd_set *) NULL,
		(fd_set *) NULL,
		(fd_set *) NULL,
		&delay) ;
    if( rt == -1 ){
        /* perror("select") ; */
        /* return(rt) ; */
	return ;
    }
    /* return(rt) ; */
    return ;
#endif	/* NO_USLEEP */
}

void msleep_( integer *time )
{
    eggx_msleep( (unsigned long)(*time) ) ;
}

/* ========================== */
/* 互換性用 : 将来削除予定 */
void xwindow_( integer *wn, real *xs, real *ys, real *xe, real *ye )
{
    eggx_window( *wn, *xs, *ys, *xe, *ye ) ;
}

void xnewpen_( integer *wn, integer *n )
{
    eggx_newpen( *wn, *n ) ;
}

void xclsx_( integer *wn )
{
    eggx_gclr( *wn ) ;
}

void xplot_( integer *wn, real *xg, real *yg, integer *mode )
{
    eggx_line( *wn, *xg, *yg, *mode ) ;
}

void xarohd_( integer *wn, real *xs, real *ys, real *xt, real *yt,
	      real *s, real *w, integer *shape )
{
    eggx_drawarrow( *wn, *xs, *ys, *xt, *yt, 
		    *s, *w, *shape ) ;    
}

void xnumber_( integer *wn, real *xg, real *yg, real *size, 
	       real *v, real *theta, integer *n )
{
    char *adr ;
    integer len ;
    adr = rtoc( v, n ) ;
    len = strlen(adr) ;
    drawstr_( wn, xg, yg, size, adr, theta, &len ) ;
}

int eggx_depthinfo( void )
{
    int d,w,h,f ;
    f=eggx_ggetdisplayinfo(&d,&w,&h) ;
    if( f ) return(f) ;
    else return(d) ;
}

void depthinfo_( integer *rt )
{
    *rt = (integer)eggx_depthinfo() ;
}

void eggx_drawnum( int wn, float x, float y, int size, float v, float theta, int n )
{
    integer w,nn ;
    real xx,yy,sz,vv,ttheta ;
    w=(integer)wn ;
    xx=(real)x ;
    yy=(real)y ;
    sz=(real)size ;
    vv=(real)v ;
    ttheta=(real)theta ;
    nn=(integer)n ;
    drawnum_(&w,&xx,&yy,&sz,&vv,&ttheta,&nn) ;
}

void imgsave_( integer *wn, integer *ly, real *xs, real *ys, real *xe, real *ye,
	       char *fname, integer *cnt, char *filter, integer *depth )
{
    saveimg_(wn,ly,xs,ys,xe,ye,fname,cnt,filter,depth) ;
}
