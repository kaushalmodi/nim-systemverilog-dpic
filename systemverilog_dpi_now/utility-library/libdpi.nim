import svdpi
import rusage
# import strformat

type
  RusageP = ptr Rusage

proc c_malloc(size: csize): pointer {.importc: "malloc", header: "<stdlib.h>".}

proc timer_new(): RusageP =
  ## Malloc a new rusage structure.
  return cast[RusageP](c_malloc(sizeof(Rusage)))

proc timer_restart(rp: RusageP) =
  ## Given an existing rusage structure, "refill" the entries from now.
  if getrusage(RUSAGE_SELF, rp) != 0:
    # Error
    stderr.writeLine("timer_restart()")
    quit 1

proc timer_start(): RusageP {.exportc.} =
  ## Create a new Rusage object, fill it in, and return a pointer to it.
  let
    rp = timer_new()
  rp.timer_restart()
  return rp

#                    ∨∨∨-- This "var" is needed because the argument of timer_split is inout in SV.
proc timer_split(rp: var RusageP): clonglong {.exportc.} =
  ## Returns the number of useconds since either the start of the
  ## timer (rp[]) or the last split time.
  ##
  ## The parameter "rp" will have its contents reset to the current
  ## "rusage" at the end of this function. It is an inout.
  var
    seconds, useconds: clonglong
    now: Rusage

  timer_restart(addr now)

  seconds = clonglong(now.ru_utime.tv_sec) - clonglong(rp[].ru_utime.tv_sec)
  useconds = clonglong(now.ru_utime.tv_usec) - clonglong(rp[].ru_utime.tv_usec)

  # echo fmt"now = {now}"
  # echo fmt"rp = {rp[]}"

  if useconds < 0:
    # We need to borrow 1 seconds worth of microseconds.
    if seconds > 0:
      seconds -= 1
      useconds += 1000000
    else:
      # Error? Or just a clock rounding error? Call it ZERO.
      seconds = 0
      useconds = 0
  result = (seconds * 1_000_000) + useconds
  rp.timer_restart() # Reset the timer for the next split
