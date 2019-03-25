import svdpi
import strformat, parsetoml
from os import getCurrentDir, `/`
from sequtils import mapIt

let
  configFile = getCurrentDir() / "config.toml"
  cfg = parsetoml.parseFile(configFile).getTable()

proc dump_cfg() {.exportc.} =
  echo fmt"Config read from {configFile}:"
  parsetoml.dump(cfg)

proc get_cfg_int(group, key: cstring): cint {.exportc.} =
  return cfg[$group][$key].getInt().cint

proc get_cfg_float(group, key: cstring): cdouble {.exportc.} =
  return cfg[$group][$key].getFloat().cdouble

proc get_cfg_string(group, key: cstring): cstring {.exportc.} =
  return cfg[$group][$key].getStr().cstring

proc get_cfg_int_array_num_elems(group, key: cstring): cint {.exportc.} =
  result = cfg[$group][$key].getElems().len.cint

proc get_cfg_int_array(group, key: cstring; dyn_arr_ptr: svOpenArrayHandle) {.exportc.} =
  let
    seq_cint = cfg[$group][$key].getElems().mapIt(it.getInt().cint)
  for idx, val in seq_cint:
    let
      elemPtr = cast[ptr cint](svGetArrElemPtr1(dyn_arr_ptr, idx.cint))
    elemPtr[] = val

# static array
# proc get_cfg_int_array(group, key: cstring; arr_int: var array[10, cint]) {.exportc.} =
#   let
#     seq_cint = cfg[$group][$key].getElems().mapIt(it.getInt().cint)
#   for idx, val in seq_cint:
#     arr_int[idx] = val
