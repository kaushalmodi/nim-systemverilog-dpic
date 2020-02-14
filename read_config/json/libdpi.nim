import svdpi
import strformat, json
from os import getCurrentDir, `/`
from sequtils import mapIt

let
  configFile = getCurrentDir() / "config.json"
  cfg = json.parseFile(configFile)

proc dump_cfg() {.exportc, dynlib.} =
  echo fmt"Config read from {configFile}:"
  echo cfg.pretty()

# Include the nim code common for reading TOML or JSON config files.
include "read_config_common.nim"
