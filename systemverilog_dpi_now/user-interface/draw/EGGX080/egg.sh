#!/bin/sh

USERCC="@USERCC@"
USERCCFLAGS="@USERCCFLAGS@"

USERFC="@USERFC@"
USERFCFLAGS="@USERFCFLAGS@"

IINC="@IINC@"
LLIB="@LLIB@"

LOCALINC="@LOCALINC@"
LOCALLIB="@LOCALLIB@"

#LOCALINC=""
#LOCALLIB=""
#LOCALINC="-I${HOME}/EGGX"
#LOCALLIB="-L${HOME}/EGGX"
#LOCALINC="-I${HOME}/include"
#LOCALLIB="-L${HOME}/lib"

LLINKS="@LLINKS@"

if [ ! -f `echo $LOCALINC/eggx.h|sed -e 's/^-I//'` ] ; then
  LOCALINC=""
fi
if [ ! -f `echo $LOCALLIB/libeggx.a|sed -e 's/^-L//'` ] ; then
  LOCALLIB=""
fi

BASENAME=`basename $0`
if [ "$LOCALINC" = "" -o "$LOCALLIB" = "" ] ; then
  EGGXDIR=`echo $0 | sed -e "s/\/${BASENAME}\$//"`
  if [ "$LOCALINC" = "" ] ; then
    LOCALINC="-I$EGGXDIR"
  fi
  if [ "$LOCALLIB" = "" ] ; then
    LOCALLIB="-L$EGGXDIR"
  fi
fi

s_match () { case $1 in $2) return 0; ;; *) return 1; ;; esac ; }

FORTRAN=""
for i in $@ ; do
  if s_match "$i" "*.c" ; then
    FORTRAN="0"
  elif s_match "$i" "*.f" ; then
    FORTRAN="1"
  fi
done

if [ "$FORTRAN" = "0" ] ; then
  CMD="$USERCC $USERCCFLAGS $@ $LOCALINC $LOCALLIB $IINC $LLIB $LLINKS"
  echo "$CMD"
  $CMD
elif [ "$FORTRAN" = "1" ] ; then
  CMD="$USERFC $USERFCFLAGS $@ $LOCALLIB $LLIB $LLINKS"
  echo "$CMD"
  $CMD
else
  echo "${BASENAME}: No input files specified."
fi

