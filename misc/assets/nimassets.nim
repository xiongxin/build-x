import strformat, os,parseopt, base64, threadpool

const buildBranchName* = staticExec("git rev-parse --abbrev-ref HEAD") ## \
const buildCommit* = staticExec("git rev-parse HEAD")  ## \
# const latestTag* = staticExec("git describe --abbrev=0 --tags") ## \

const versionString = fmt("0.0.1 ({buildBranchName}/{buildCommit})")

let assetsFileHeader = """
import os, tables, strformat, base64, ospaths
var assets = initTable[string, string]()
proc getAsset*(path: string): string = 
  result = assets[path].decode()
"""

proc wirteHelp() =
  echo fmt"""
nimassets {versionString} (Bundle you assets into nim file)
  -h | --help     : show help
  -v | --version  : show version
  -o | --output   : output filename
  -f | --fast     : faster geeration
  -d | --dir      : dir to include (recursively)
"""

proc writeVersion() =
  echo fmt"nimassets version {versionString}"

proc createAssetsFile(dirs:seq[string], outputfile="assets.nim", fast=false, compress=false)
  
proc cli() =
  var
    compress, fast: bool = false
    dirs = newSeq[string]()
    output = "assets.nim"

  if paramCount() == 0:
    wirteHelp()
    quit(0)

  for kind, key, val in getopt():
    case kind
    of cmdLongOption, cmdShortOption:
      case key
      of "help", "h":
        wirteHelp()
        quit()
      of "version", "v":
        writeVersion()
        quit()
      of "fast", "f": fast = true
      of "dir", "d": dirs.add(val)
      of "output", "o": output = val
      else: discard
    else: discard

    for d in dirs:
      if not dirExists(d):
        echo fmt"[-] Directory doesnt exist {d}"
        quit(2)
      echo fmt"compress: {compress} fast: {fast} dirs:{dirs} output:{output}"

proc generateDirAssetsSimple(dir: string): string =
  var key, val, valString: string
  for path in expandTilde(dir).walkDirRec():
    key = path
    val = readFile(path).encode()
    valString = " \"\"\"" & val & "\"\"\" "
    result &= fmt"""assets.add("{path}", {valString})""" & "\n\n"

proc handleFile(path: string): string {.thread.} =
  var val, valString: string
  val = readFile(path).encode()
  valString = " \"\"\"" & val & "\"\"\" "
  result = fmt"""assets.add("{path}", {valString})""" & "\n\n"

proc generateDirAssetsSpawn(dir: string): string =
  var results = newSeq[FlowVar[string]]()
  for path in expandTilde(dir).walkDirRec():
    results.add(spawn handleFile(path))
  for r in results:
    result &= ^r

proc createAssetsFile(dirs:seq[string], outputfile="assets.nim", fast=false, compress=false) =
  var generator: proc(s: string): string
  var data = assetsFileHeader

  if fast:
    #discard
    generator = generateDirAssetsSpawn
  else:
    generator = generateDirAssetsSimple

  for d in dirs:
    data &= generator(d)

  writeFile(outputfile, data)
when isMainModule:
  echo buildBranchName, ", ", buildCommit, ", ", versionString
  writeVersion()
  wirteHelp()
  createAssetsFile(@["/home/xiongxin/Code/build-x/misc"], "assets.nim", false)