import strformat, strutils, sequtils, hashes

const CRLF = "\r\n" # \13\10
const REDISNIL = "\0\0"

type
  Redis* = ref object
  ValueKind = enum
    vkStr, vkError, vkInt, vkBulkStr, vkArray
  RedisValue* = ref object
    case kind*: ValueKind
    of vkStr:
      s*: string
    of vkError:
      err*: string
    of vkInt:
      i*: int
    of vkBulkStr:
      bs*: string
    of vkArray:
      l*: seq[RedisValue]

proc `$`*(obj: RedisValue): string =
  result = case obj.kind
  of vkStr: obj.s
  of vkBulkStr: obj.bs
  of vkInt: $obj.i
  of vkArray: $obj.l
  of vkError: obj.err

proc hash*(obj: RedisValue): Hash =
  result = case obj.kind
  of vkStr: !$(hash(obj.s))
  of vkBulkStr: !$(hash(obj.bs))
  of vkInt: !$(hash(obj.i))
  of vkArray: !$(hash(obj.l))
  of vkError: !$(hash(obj.err))

proc `==`* (a, b: RedisValue): bool =
  ## Check two nodes for equality
  if a.isNil:
    result = b.isNil
  elif b.isNil or a.kind != b.kind:
    result = false
  else:
    case a.kind
    of vkStr:
        result = a.s == b.s
    of vkBulkStr:
        result = a.s == b.s
    of vkInt:
        result = a.i == b.i
    of vkArray:
        result = a.l == b.l
    of vkError:
        result = a.err == b.err


# Enocder

proc encodeStr(v: RedisValue): string =
  result = fmt("+{v.s}{CRLF}")

proc encodeErr(v: RedisValue): string =
  result = fmt("-{v.err}{CRLF}")

proc encodeInt(v: RedisValue): string =
  result = fmt(":{v.i}{CRLF}")

proc encodeBulkStr(v: RedisValue): string =
  result = fmt("${v.bs.len}{CRLF}{v.bs}{CRLF}")

proc encode*(v: RedisValue): string

proc encodeArray(v: RedisValue): string =
  result = "*" & $len(v.l) & CRLF
  for el in v.l:
    result &= encode(el)
  result &= CRLF

proc encode*(v: RedisValue): string =
  case v.kind
  of vkStr: result = encodeStr(v)
  of vkBulkStr: result = encodeBulkStr(v)
  of vkInt: result = encodeInt(v)
  of vkArray: result = encodeArray(v)
  of vkError: result = encodeErr(v)

# Decoder
proc decodeStr(s: string): (RedisValue, int) =
  let crlfpos = s.find(CRLF)
  result = ( 
    RedisValue(kind: vkStr, s: s[1 .. crlfpos - 1]),
    s.len
  )

proc decodeBulkStr(s: string): (RedisValue, int) =
  let crlfpos = s.find(CRLF)
  var bulklen = 0
  let slen = s[1 .. crlfpos - 1]
  bulklen = parseInt(slen)
  
  var bulk: string

  if bulklen == -1:
    result = ( 
      RedisValue(kind: vkBulkStr, bs: REDISNIL),
      crlfpos + len(CRLF)
    )
  else:
    let nextcrlf = s.find(CRLF, crlfpos + len(CRLF))
    bulk = s[crlfpos+len(CRLF) .. nextcrlf - 1]
    result = ( 
      RedisValue(kind: vkBulkStr, bs: bulk),
      nextcrlf + len(CRLF)
    )

proc decodeInt(s: string): (RedisValue, int) =
  let crlfpos = s.find(CRLF)
  var i: int
  let sInt = s[1 .. crlfpos - 1]
  if sInt.isDigit():
    i = parseInt(sInt)
  result = ( 
    RedisValue(kind: vkInt, i: i),
    s.len
  )

proc decodeErr(s: string): (RedisValue, int) =
  let crlfpos = s.find(CRLF)
  result = ( 
    RedisValue(kind: vkError, err: s[1 .. crlfpos - 1]),
    s.len
  )

proc decode(s: string): (RedisValue, int)
proc decodeArray(s: string): (RedisValue, int) =
  var arr = newSeq[RedisValue]()
  var arrlen = 0
  var crlfpos = s.find(CRLF)
  var arrlenStr = s[1 .. crlfpos - 1]
  arrlen = parseInt(arrlenStr)

  var nextobjpost = s.find(CRLF) + len(CRLF)
  var i = nextobjpost

  if arrlen == -1:
    return (RedisValue(kind: vkArray, l: arr), i)
  
  while i < len(s) and len(arr) < arrlen:
    var pair = decode(s[i .. len(s)])
    var obj = pair[0]
    arr.add(obj)
    i += pair[1]

  return (RedisValue(kind: vkArray, l: arr), i + len(CRLF))
proc decode(s: string): (RedisValue, int) =
  var i = 0
  while i < len(s):
    var curchar = $s[i]
    if curchar == "+":
      var pair = decodeStr(s[i .. s.find(CRLF, i) + len(CRLF)])
      var obj = pair[0]
      var count = pair[1]
      i += count
      return (obj, i)
    elif curchar == "-":
      var pair = decodeErr(s[i .. s.find(CRLF, i) + len(CRLF)])
      var obj = pair[0]
      var count = pair[1]
      i += count
      return (obj, i)
    elif curchar == "$":
      var pair = decodeBulkStr(s[i .. ^1])
      var obj = pair[0]
      var count = pair[1]
      i += count
      return (obj, i)
    elif curchar == ":":
      var pair = decodeInt(s[i .. s.find(CRLF, i) + len(CRLF)])
      var obj = pair[0]
      var count = pair[1]
      i += count
      return (obj, i)
    elif curchar == "*":
      var pair = decodeArray(s[i .. s.find(CRLF, i) + len(CRLF)])
      var obj = pair[0]
      var count = pair[1]
      i += count
      return (obj, i)
    else:
      echo fmt("Unrecognized char {curchar}")
      break

# In redis, commands are sent as List of ReidsValues
# so GET USER is converted to *2\r\n$3\r\nGET\r\n$4\r\nUSER\r\n\r\n
proc preparedCommand*(this: Redis, command: string, args:seq[string]): string =
  let cmdArgs = concat(@[command], args)
  var cmdAsRedisValues = newSeq[RedisValue]()
  for cmd in cmdArgs:
    cmdAsRedisValues.add(RedisValue(kind: vkBulkStr, bs: cmd))
  var arr = RedisValue(kind: vkArray, l: cmdAsRedisValues)

  result = encode(arr)


when isMainModule:
  var s = encode(RedisValue(kind:vkArray, l: @[RedisValue(kind:vkStr, s:"Hello World"), RedisValue(kind:vkInt, i:23)] ))
  s = "abc" # 3.. 3 + 4
  echo s[0 .. 2]
  echo s.find(CRLF)
  let redis = Redis()
  echo preparedCommand(redis, "GET", @["USER"])