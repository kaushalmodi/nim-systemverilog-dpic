#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <fcntl.h>

int readexecfile( char *filename, unsigned char **buffer )
{
    int fd ;
    struct stat st ;
    unsigned char *buf ;
    if( stat(filename,&st) ) return(-1) ;
    buf=malloc(sizeof(unsigned char)*st.st_size) ;
    fd = open(filename,O_RDONLY) ;
    if( fd == -1 ) return(-1) ;
    read( fd, buf, st.st_size ) ;
    close(fd) ;
    *buffer = buf ;
    return(st.st_size) ;
}

int main( int argc, char *argv[] )
{
    int i,len ;
    unsigned char *buffer ;
    if( argc < 2 ) return(1) ;
    if( (len=readexecfile(argv[1],&buffer)) < 0 ) return(-1) ;
    printf("unsigned char %s[] = {",argv[1]) ;
    for( i=0 ; i<len ; i++ ){
	if( i!=0 ) printf(",") ;
	if( (i % 16)==0 ){
	    printf("\n") ;
	}
	printf("0x%02x",buffer[i]) ;
    }
    printf(" } ;\n\n") ;
    free(buffer) ;
    return( 0 ) ;
}

