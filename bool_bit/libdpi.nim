import std/[strformat]

const
  numElems = 3

type
  MyObj = object                   #    Size (32-bit comp)                 Size (64-bit comp)
                                   # -----------------------       -------------------------------
    scalarBool: bool               #  |...b| = (3) + 1 bytes        |.......b| = (7) + 1 bytes
    scalarReal: cdouble            #  |dddd| =  0  + 4 bytes        |dddddddd| =  0  + 8 bytes
                                   #  |dddd| =  0  + 4 bytes         ^^ cdouble will occupy the whole word for itself
    arrBool: array[numElems, bool] #  |iBBB| =  1  + 3 bytes        |.iiiiBBB| = (1) + 4 + 3 bytes
    scalarInt: cint                #  |.iii| = (1) + 3 bytes
                                   # -----------------------       -------------------------------
                                   #   Total = 4 * 5 = 20 bytes          Total = 8 * 3 = 24 bytes

  MyEffObj = object                #    Size (32-bit comp)                 Size (64-bit comp)
                                   # -----------------------       -------------------------------
    scalarBool: bool               #  |BBBb| = 3 + 1 bytes          |iiiiBBBb| = 4 + 3 + 1 bytes
    arrBool: array[numElems, bool]
    scalarInt: cint                #  |iiii| = 0 + 4 bytes
    scalarReal: cdouble            #  |dddd| = 0 + 4 bytes          |dddddddd| = 0  + 8 bytes
                                   #  |dddd| = 0 + 4 bytes            ^^ cdouble will occupy the whole word for itself
                                   # -----------------------       -------------------------------
                                   #   Total = 4 * 4 = 16 bytes          Total = 8 * 2 = 16 bytes

proc printObj(obj: auto) =
  echo &" size of scalar bool          = {sizeof(obj.scalarBool):2} bytes"
  echo &" size of scalar double        = {sizeof(obj.scalarreal):2} bytes"
  echo &" size of {numElems} element bool array = {sizeof(obj.arrBool):2} bytes"
  echo &" size of scalar int           = {sizeof(obj.scalarInt):2} bytes"
  echo &" size of the whole object     = {sizeof(obj):2} bytes"
  echo &"obj (type {$type(obj)}) = {obj}"
  echo ""

proc printMyObj(objPtr: ptr MyObj) {.exportc, dynlib.} =
  printObj(objPtr[])

proc printMyEffObj(objPtr: ptr MyEffObj) {.exportc, dynlib.} =
  printObj(objPtr[])

proc populateObj[T](objPtr: ptr T) =
  var
    obj = T(scalarBool: true,
            scalarReal: 70.57,
            arrBool: [true, false, true],
            scalarInt: 6622)
  objPtr[] = obj

proc populateMyObj(objPtr: ptr MyObj) {.exportc, dynlib.} =
  populateObj[MyObj](objPtr)

proc populateMyEffObj(objPtr: ptr MyEffObj) {.exportc, dynlib.} =
  populateObj[MyEffObj](objPtr)
