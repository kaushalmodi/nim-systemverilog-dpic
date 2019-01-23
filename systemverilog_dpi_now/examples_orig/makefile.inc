WINLIBS =
LIBX11=/usr/X11R6/lib

ifeq "$(PLATFORM)" "linux_x86_64"
    CFLAGS = -fPIC -shared
	LIBX11=/usr/X11R6/lib64
endif
ifeq "$(PLATFORM)" "linux"
    CFLAGS = -shared -fPIC
endif
ifeq "$(PLATFORM)" "sunos5"
    CFLAGS = -G
endif
ifeq "$(PLATFORM)" "sunos5v9"
    CFLAGS = -G -m64
endif
ifeq "$(PLATFORM)" "win32"
    CFLAGS = -shared 
    WINLIBS = draw/draw.o draw/EGGX078/libeggx.a /usr/X11R6/lib/libX11.dll.a
endif

# vlog -sv -dpiheader dpiheader.h -isymfile vlcode.isym vlcode.v 

clean::
	rm -f vsim_stacktrace.vstf
	rm -f *.so dpiheader.h transcript
	rm -rf work

cleanall:: clean

