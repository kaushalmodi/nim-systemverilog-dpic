import svdpi

proc show (a: svLogic) {.exportc} =
  if a == 0:
    echo "a is 0"
  elif a == 1:
    echo "a is 1"
  elif a == 2:
    echo "a is x"
  elif a == 3:
    echo "a is z"
