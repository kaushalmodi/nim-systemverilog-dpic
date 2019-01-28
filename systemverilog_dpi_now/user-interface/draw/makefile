X11=/usr/X11R6

all: mandel draw.so

include makefile.inc

EGGX_LIB=${STOW_PKGS_TARGET}/lib
EGGX_INC=${STOW_PKGS_TARGET}/include

LIBS=-L$(EGGX_LIB) -L$(LIBX11) -leggx -lX11 -lm
INCLUDES=-I$(X11)/include -I$(EGGX_INC)

CFLAGS=-O2 -fPIC

mandel: mandel.o draw.so
	$(CC) $(CFLAGS) -o mandel mandel.o draw.so $(LIBS)

win32:
	$(CC) $(CFLAGS) -o mandel mandel.o draw.o $(EGGX) /usr/X11R6/lib/libX11.dll.a

draw.so: draw.c
	$(CC) $(CFLAGS) $(INCLUDES) -c draw.c
	$(CC) $(CFLAGS) $(INCLUDES) -shared -o draw.so draw.o $(EGGX_LIB)/libeggx.a

mandel.o: mandel.c
	$(CC) $(CFLAGS) $(INCLUDES) -c mandel.c

xdraw: xdraw.o
	$(CC) $(CFLAGS) -o draw draw.o $(LIBS)

xdraw.o: draw.c
	$(CC) $(CFLAGS) $(INCLUDES) -o xdraw.o -c draw.c

tools:
	tar xvfz EGGX080.tar.gz
	# cd EGGX080; make
	# For 64 bit LINUX - ModelSim linux_x86_64 (Operton)
	cd EGGX080; make LLIB=-L/usr/X11R6/lib64 CFLAGS="-O2 -Wall -fPIC"
	rm -f EGGX;
	ln -s EGGX080 EGGX

clean::
	rm -f draw.exe draw.o draw.so
	rm -f *.o
	rm -f ld.exe.stackdump
	rm -f mandel draw nim_mandel

cleanall:: clean
	rm -rf EGGX080
	rm -f EGGX
