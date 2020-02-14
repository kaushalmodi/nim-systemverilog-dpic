import svdpi
import strformat, parsetoml
from os import getCurrentDir, `/`
from sequtils import mapIt

let
  configFile = getCurrentDir() / "config.toml"
  cfg = parsetoml.parseFile(configFile).getTable()

proc dump_cfg() {.exportc, dynlib.} =
  echo fmt"Config read from {configFile}:"
  parsetoml.dump(cfg)

# Include the nim code common for reading TOML or JSON config files.
include "read_config_common.nim"
