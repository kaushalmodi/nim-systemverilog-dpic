task genc, "Compile Nim to C library":
  switch("out", "libdpi.so")
  switch("app", "lib")
  setCommand("c")
