# https://github.com/nim-lang/Nim/pull/10484/files
import posix

type
  Rusage* {.importc: "struct rusage",
           header: "<sys/resource.h>",
           pure,
           final.} = object
    ru_utime*, ru_stime*: Timeval                       # User and system time
    ru_maxrss*, ru_ixrss*, ru_idrss*, ru_isrss*,        # memory sizes
      ru_minflt*, ru_majflt*, ru_nswap*,                # paging activity
      ru_inblock*, ru_oublock*, ru_msgsnd*, ru_msgrcv*, # IO activity
      ru_nsignals*, ru_nvcsw*, ru_nivcsw*: clong        # switching activity

const
  RUSAGE_SELF* = cint(0)
  RUSAGE_CHILDREN* = cint(-1)
  RUSAGE_THREAD* = cint(1)    # This one is less std; Linux, BSD agree though.

proc getrusage*(who: cint, rusage: ptr Rusage): cint
  {.importc, header: "<sys/resource.h>", discardable.}

proc wait4*(pid: Pid, status: ptr cint, options: cint, rusage: ptr Rusage): Pid
  {.importc, header: "<sys/wait.h>", discardable.}
