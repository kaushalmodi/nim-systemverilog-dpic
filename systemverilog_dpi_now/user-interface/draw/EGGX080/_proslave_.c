#include <X11/Xlib.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/time.h>
#include <unistd.h>

#define  CBN 64		/* XColorのバッファ数 */

volatile Pixmap Pix0,Pix1,Pix ;
volatile pid_t Cpid=0 ;
char Tmpfile_name_ppm[21+4] ;
volatile int Chld_exist=1,Tmpfile_fd=-1 ;
Window Win,Iconwin ;
Display* Dis ;
int Wszx,Wszy ;
GC Gc ;
pid_t Ppid,Pid ;
long Dockapp ;

static void _m_sleep( unsigned long msec )
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

/* 親からSIGUSR1がきたら呼び出される */
void xhandler( int dummy )
{
    /* 逆転させる */
    /*
    if( Pix==Pix0 ) Pix=Pix1 ;
    else Pix=Pix0 ;
    */
    Pix=Pix0 ;
}

void xhandler2( int dummy )
{
    Pix=Pix1 ;
}

/* 割り込みセット */
/* Only for AUTOREDRAW */
void iusr_set( void )
{
    _procall_signal( SIGUSR1, SA_RESTART, &xhandler ) ;
    _procall_signal( SIGUSR2, SA_RESTART, &xhandler2 ) ;
}

/* Only for saveimg */
void exithandler( int dummy )
{
    int i,status ;
    /* waitpid( Cpid,&status,WNOHANG ) ; */
    if( Tmpfile_fd != -1 )
	remove(Tmpfile_name_ppm) ;
    i=0 ;
    while( Chld_exist ){
	if( i==10 ){
	    i=0 ;
	    if( kill(0,Cpid) ){
		/* Strange, but he died... */
		break ;
	    }
	}
	_m_sleep( 10 ) ;
	i++ ;
    }
    waitpid( Cpid,&status,WNOHANG ) ;
    exit(0) ;
}

/* Only for saveimg */
void chldexithandler( int dummy )
{
    Chld_exist=0 ;
}

/* 画像をsaveする */
int imgsv( char **argv )
{
    int status,rt_val=0 ;
    int i,ii,j,k=0,wd ;
    int sx0,sy0,width,height ;
    int dpt,depth ;
    int pfds[2],fd ;
    static int cln=0,clw,clr,clf,imagc_argc ;
    long long px ;
    char *fn ;
    char **fargv ;
    char *badr ;
    char tmpfile_name[21]="/tmp/EgGxCoNv_XXXXXX" ;
    /* struct stat *file_stat ; */
    FILE *fp ;
    XImage *image ;
    XColor cl[CBN] ;
    Colormap cmap ;

    Pix=atol(*++argv) ;
    sx0=atoi(*++argv) ;
    sy0=atoi(*++argv) ;
    width=atoi(*++argv) ;
    height=atoi(*++argv) ;
    dpt=atoi(*++argv) ;
    depth=65536/dpt ;
    cmap=atol(*++argv) ;
    fn=*++argv ;
    fargv=++argv ;

    Tmpfile_fd = -1 ;

    if( fargv[0]==NULL ){
	fp=fopen(fn,"w") ;
	if( fp==NULL ){
	    fprintf(stderr,"ファイルが作成できません．\n") ;
	    return(-1) ;
	}
    }
#ifdef CYGWIN
    else if( strcmp(fargv[0],"convert.exe")==0 ){	/* ImageMagick */
#else
    else if( strcmp(fargv[0],"convert")==0 ){	/* ImageMagick */
#endif
	strcpy(tmpfile_name,"/tmp/EgGxCoNv_XXXXXX") ;
#ifdef NO_MKSTEMP	/* mkstempがない場合 */
	if( mktemp( tmpfile_name ) == NULL ){
	    fprintf(stderr,"テンポラリファイルが作成できません．\n") ;
	    return( -1 ) ;
	}
	Tmpfile_fd = open( tmpfile_name, O_RDWR|O_CREAT|O_EXCL, S_IRUSR|S_IWUSR) ;
#else
	Tmpfile_fd = mkstemp( tmpfile_name ) ;
#endif
	if( Tmpfile_fd == -1 ){
	    fprintf(stderr,"テンポラリファイルが作成できません．\n") ;
	    return( -1 ) ;
	}
	strcpy(Tmpfile_name_ppm,tmpfile_name) ;
	strcat(Tmpfile_name_ppm,".ppm") ;
	/*
	if( stat(Tmpfile_name_ppm,&file_stat)==0 ){
	    close(Tmpfile_fd) ;
	    Tmpfile_fd=-1 ;
	    remove(tmpfile_name) ;
	    strcpy(tmpfile_name,"/tmp/EgGxCoNv_XXXXXX") ;
	}
	if( Tmpfile_fd == -1 ){
	    fprintf(stderr,"テンポラリファイルが作成できません．\n") ;
	    return( -1 ) ;
	}
	*/
	fp=fdopen(Tmpfile_fd,"w") ;
	if( fp==NULL ){
	    fprintf(stderr,"ファイルがオープンできません．\n") ;
	    return(-1) ;
	}
	for( i=0 ; fargv[i]!=NULL ; i++ ) ;
	imagc_argc=i+2 ;
    }
    else{
	/* fileのcreate */
	fd=open(fn,O_WRONLY|O_CREAT|O_TRUNC,
		S_IRUSR|S_IWUSR|S_IRGRP|S_IROTH ) ;
	if( fd==-1 ){
	    fprintf(stderr,"ファイルが作成できません．\n") ;
	    return(-1) ;
	}
	/* コンバータを起動する */
	if( pipe(pfds)<0 ){
	    fprintf(stderr,"パイプが開けません．\n") ;
	    return(-1) ;
	}
	if( (Cpid=fork())<0 ){
	    fprintf(stderr,"子プロセスの生成に失敗しました．\n") ;
	    return(-1) ;
	}
	if( Cpid==0 ){		/* 子プロセス */
	    dup2( fd,1 ) ;
	    dup2( pfds[0],0 ) ;
	    close( pfds[1] ) ;
	    close( pfds[0] ) ;
	    execvp( fargv[0], fargv ) ;
	    fprintf(stderr,"ファイル %s が実行できません．\n",fargv[0]) ;
	    if( Pid == getppid() )
		kill(Pid,SIGUSR1) ;
	    _exit(-1) ;
	}
	close(fd) ;
	close(pfds[0]) ;
	fp=fdopen( pfds[1],"w" ) ;	/* 送信用 */
	if( fp==NULL ){
	    fprintf(stderr,"パイプ接続に失敗しました．\n") ;
	    return(-1) ;
	}
    }
    /* cmap=DefaultColormap(Dis,0) ; */	/* カラーマップID */
    image=XGetImage( Dis,Pix,sx0,sy0,width,height,
		     0xffffffff,ZPixmap ) ;
    XFlush( Dis ) ;

    wd = (image->bits_per_pixel)/8 ;
    /* If your Xserver returns wrong image->bit_per_pixel, */
    /* use this determination method of wd. */
    /*
    if( 16 < image->depth ) wd=4 ;
    else wd=(7+image->depth)/8 ;
    */

    /*
    fprintf(stderr,"bits_per_pixel = %d\n",image->bits_per_pixel) ;
    fprintf(stderr,"bytes_per_line = %d\n",image->bytes_per_line) ;
    fprintf(stderr,"width*wd = %d\n",width*wd) ;
    */

    fprintf(fp,"P3\n") ;
    fprintf(fp,"%d %d\n",width,height) ;
    fprintf(fp,"%d\n",depth-1) ;
    if( cln==0 ){
	clw=CBN-1 ;	/* write */
	clf=clw ;	/* offset */
	cl[clw].pixel=0 ;
	XQueryColor( Dis,cmap,&(cl[clw]) ) ;
	cl[clw].red /= dpt ;
	cl[clw].green /= dpt ;
	cl[clw].blue /= dpt ;
	clr=0 ;		/* read */
	cln++ ;
    }
    /* ppmを作成 */
    badr=image->data ;
    /*
    if( image->byte_order==MSBFirst )
	fprintf(stderr,"This Display is MSBFirst\n") ;
    else
	fprintf(stderr,"This Display is LSBFirst\n") ;
    */
    for( i=0 ; i<height ; i++ ){
      for( ii=0 ; ii<width ; ii++,badr+=wd ){
	if( image->byte_order==MSBFirst ){	/* big */
	    for( j=0,px=0 ; j<wd ; j++ ){
		px <<= 8 ;
		px |= ( badr[j] & 0xff ) ;
	    }
	}
	else{					/* little */
	    for( j=wd-1,px=0 ; 0<=j ; j-- ){
		px <<= 8 ;
		px |= ( badr[j] & 0xff ) ;
	    }
	}
	for( j=0 ; j<cln ; j++ ){
	    k=clf+((clr+j)%cln) ;
	    if( cl[k].pixel==px ){
		clr=k-clf ;
		break ;
	    }
	}
	if( j==cln ){
	    if( ++cln>CBN ) cln-- ;	/* 個数 */
	    if( --clf<0 ) clf=0 ;	/* offset */
	    if( --clw<0 ) clw+=CBN ;
	    clr=clw-clf ;
	    cl[clw].pixel=px ;
	    XQueryColor( Dis,cmap,&(cl[clw]) ) ;
	    k=clw ;
	    cl[k].red /= dpt ;
	    cl[k].green /= dpt ;
	    cl[k].blue /= dpt ;
	}
	fprintf(fp,"%d %d %d\n",cl[k].red,cl[k].green,cl[k].blue) ;
      }
      badr += ( image->bytes_per_line - width*wd ) ;
    }
    fclose(fp) ;
    free( image->data ) ;
    image->data = NULL ;
    XFree( image ) ;
    if( fargv[0]!=NULL ){		/* netpbm or ImageMagick */
	if( Tmpfile_fd == -1 ){		/* netpbm */
	    close( pfds[1] ) ;
	    while(wait(&status)!=Cpid) ;
	}
	else{				/* ImageMagick */
	    char **imagc_argv=NULL ;
	    imagc_argv=(char **)malloc(sizeof(char *)*(imagc_argc+1)) ;
	    if( imagc_argv == NULL ){
		remove(tmpfile_name) ;
		rt_val = -1 ;
	    }
	    else{	/* malloc ok */
	      imagc_argv[imagc_argc]=NULL ;
	      close(Tmpfile_fd) ;
	      if( rename(tmpfile_name,Tmpfile_name_ppm) ){
		fprintf(stderr,"なぜか %s を %s にリネームできません．\n",
			tmpfile_name,Tmpfile_name_ppm) ;
		remove(tmpfile_name) ;
		rt_val = -1 ;
	      }
	      else{	/* OK */
		for( i=0 ; i<imagc_argc-2 ; i++ ){
		  imagc_argv[i] = fargv[i] ;
		}
		imagc_argv[i++]=Tmpfile_name_ppm ;
		imagc_argv[i]=fn ;
		if( (Cpid=fork())<0 ){
		  fprintf(stderr,"子プロセスの生成に失敗しました．\n") ;
		  remove(Tmpfile_name_ppm) ;
		  rt_val = -1 ;
		}
		else{	/* OK */
		  if( Cpid==0 ){	/* 子 */
		    execvp( imagc_argv[0], imagc_argv ) ;
		    fprintf(stderr,"ファイル %s が実行できません．\n",
			    imagc_argv[0]) ;
		    if( Pid == getppid() )
			kill(Pid,SIGUSR1) ;
		    _exit(-1) ;
		  }
		  else{		/* 親 */
		    while(wait(&status)!=Cpid) ;
		    remove(Tmpfile_name_ppm) ;
		  }
		}
	      }
	      free(imagc_argv) ;
	    }	/* malloc ok */
	}
    }
    return(rt_val) ;
}

int main( int argc, char **argv )
{
    int cmd,rt=0 ;
    XEvent ev ;
    Pid=getpid() ;
    /* fprintf(stderr,"exec:ok\n") ; */
    if( 1<argc ){
	cmd=atoi(*++argv) ;
	switch(cmd){
	case 1:
	    Ppid=atol(*++argv) ;
	    Dockapp=atol(*++argv) ;
	    Win=atol(*++argv) ;
	    Iconwin=atol(*++argv) ;
	    Pix0=atol(*++argv) ;
	    Pix1=atol(*++argv) ;
	    Pix=Pix0 ;
	    Wszx=atoi(*++argv) ;
	    Wszy=atoi(*++argv) ;
	    iusr_set() ;
	    Dis=XOpenDisplay(NULL) ;
	    Gc=XCreateGC(Dis,Win,0,0) ;
	    XSelectInput( Dis, Win, ExposureMask | StructureNotifyMask ) ;
	    if( Dockapp )
		XSelectInput( Dis, Iconwin, ExposureMask ) ;
	    if( Ppid == getppid() )
		kill(Ppid,SIGUSR1) ;	/* 親プロセスに送信 */
	    while(1){
		XNextEvent( Dis, &ev ) ;
		if( ev.type == Expose ){
		    GC gc ;
		    XGCValues gv ;
		    gv.tile = Pix ;
		    gv.fill_style = FillTiled ;
		    gv.fill_rule = WindingRule ;
		    gc=XCreateGC( Dis,Win,GCFillStyle|GCFillRule|GCTile,&gv ) ;
		    if( ev.xany.window == Win )
			XFillRectangle( Dis, Win, gc, 0,0, Wszx,Wszy ) ;
		    if( ev.xany.window == Iconwin )
			XFillRectangle( Dis, Iconwin, gc, 0,0, Wszx,Wszy ) ;
		    XFreeGC( Dis,gc ) ;
		}
		if( ev.type == DestroyNotify ){
		    XCloseDisplay(Dis) ;
		    if( Ppid == getppid() )
			kill(Ppid,SIGTERM) ;
		    break ;
		}
	    }
	    break ;
	case 2:
	    Ppid=atol(*++argv) ;
	    _procall_signal( SIGUSR1, 0, &exithandler ) ;
	    _procall_signal( SIGCHLD, SA_NOCLDSTOP, &chldexithandler ) ;
	    if( Ppid == getppid() )
		kill(Ppid,SIGUSR1) ;			/* 親プロセスに送信 */
	    Dis=XOpenDisplay(NULL) ;
	    if( Dis==NULL ){
		fprintf(stderr,"Xサーバと接続できません．\n") ;
		return(1) ;
	    }
	    rt=imgsv(argv) ;
	    XCloseDisplay(Dis) ;
	    break ;
	default:
	    rt=1 ;
	    break ;
	}
    }
    else rt=1 ;
    return(rt) ;
}


