import strformat, tables, json, strutils, hashes


type
  BencodeKind* = enum
    btString
    btInt
    btList
    btDict
  BencodeType* = ref object
    case kind*: BencodeKind
    of BencodeKind.btString:
      s*: string
    of BencodeKind.btInt:
      i*: int
    of BencodeKind.btList:
      l*: seq[BencodeType]
    of BencodeKind.btDict:
      d*: OrderedTable[BencodeType, BencodeType]
  Encoder* = ref object
  Decoder* = ref object

# note if you define your own variant you should define hash, == procs
# to be able to compare or hash the values
proc hash*(obj: BencodeType): Hash =
  case obj.kind
  of btString: result = !$(hash(obj.s))
  of btInt: result = !$(hash(obj.i))
  of btList: result = !$(hash(obj.l))
  of btDict:
    var h = 0
    for k, v in obj.d.pairs:
      h = hash(k) !& hash(v)
    result = !$(h)

proc `$`* (a: BencodeType): string = 
  case a.kind
  of btString:  fmt("<Bencode {a.s}>")
  of btInt: fmt("<Bencode {a.i}>")
  of btList: fmt("<Bencode {a.l}>")
  of btDict: fmt("<Bencode {a.d}")

### 主要解决递归调用问题
### forward declarating to encode proc because to encode a list
### might encode another value, so we will recursively call
### encode if needed
proc encode(this: Encoder,  obj: BencodeType) : string

proc encode_s(this: Encoder, str: string): string =
  result = $str.len & ":" & str

proc encode_i(this:Encoder, i: int): string =
  result = fmt("i{i}e")

proc encode_l(this: Encoder, list: seq[BencodeType]): string =
  result = "l"
  for elem in list:
    result &= this.encode(elem)
  result &= "e"

proc encode_d(this: Encoder, d: OrderedTable[BencodeType, BencodeType]): string =
  result = "d"
  for k, v in d.pairs:
    assert k.kind == BencodeKind.btString
    result &= this.encode(k) & this.encode(v)
  result &= "e"

proc encode(this: Encoder, obj: BencodeType): string =
  case obj.kind
  of btString: result = this.encode_s(obj.s)
  of btInt: result = this.encode_i(obj.i)
  of btList: result = this.encode_l(obj.l)
  of btDict: result = this.encode_d(obj.d)

#proc decode(this: Decoder,  source: string) : (BencodeType, int)


proc decode_s(this: Decoder, s: string): (BencodeType, int) =
  let lengthpart = s.split(":")[0]
  let sizelength = lengthpart.len
  let strlen = parseInt(lengthpart)

  return (
    BencodeType(kind: BencodeKind.btString, s: s[sizelength+1 .. strlen+1]),
    sizelength + 1 + strlen # eat string length
  )


when isMainModule:
  var btDictSample1 = initOrderedTable[BencodeType, BencodeType]()
  btDictSample1[BencodeType(kind:btString, s:"name")] = BencodeType(kind:btString, s:"dmdm")
  btDictSample1[BencodeType(kind:btString, s:"lang")] = BencodeType(kind:btString, s:"nim")
  btDictSample1[BencodeType(kind:btString, s:"age")] = BencodeType(kind:btInt, i:50)

  let bt = BencodeType(
    kind: BencodeKind.btList,
    l: @[
      BencodeType(kind: BencodeKind.btString, s: "abc"),
      BencodeType(kind: BencodeKind.btDict, d: btDictSample1)
    ]
  )
  let encoder = new(Encoder)
  let decoder = new(Decoder)
  echo encoder.encode(bt)
  echo decoder.decode_s("3:abc")