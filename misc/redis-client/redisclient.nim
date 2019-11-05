import redisparser, strformat, tables, json, strutils, sequtils, hashes, net, asyncdispatch, asyncnet, os, strutils, parseutils, deques, options, net

# TSocket: socket object that can be the blocking
# net.Socket or the nonoblocking asyncnet.AsyncSocket
type
  ReidsBase[TSocket] = ref object of RootObj
    socket: TSocket
    connected: bool
    timeout*: int
    pipeline*: seq[RedisValue]

  Redis* = ref object of ReidsBase[net.Socket]
  AsyncRedis* = ref object of ReidsBase[asyncnet.AsyncSocket]

proc open*(host = "localhost", port = 6379.Port, ssl = false, timeout = 0) :
  Redis = 
  result = Redis(
    socket: newSocket()
  )

  result.pipeline = @[]
  result.timeout = timeout
  ## ... code omitted for supporting ssl
  result.socket.connect(host, port)
  result.connected = true

# proc openAsync*(host = "localhost", port = 6379.Port, ssl = false, timeout = 0) :
#   Future[AsyncRedis] {.async.} = 
#   result = AsyncRedis(
#     socket: newAsyncSocket()
#   )

#   result.pipeline = @[]
#   result.timeout = timeout
#   ## ... code omitted for supporting ssl
#   await result.socket.connect(host, port)
#   result.connected = true
proc readForm(this: Redis): string
proc exeCommand*(this: Redis, command: string, args: seq[string]) : RedisValue =
  let cmdArgs = concat(@[command], args)
  var cmdAsRedisValues = newSeq[RedisValue]()
  for cmd in cmdArgs:
    cmdAsRedisValues.add(RedisValue(kind: vkBulkStr, bs: cmd))
  var arr = RedisValue(kind: vkArray, l: cmdAsRedisValues)
  this.socket.send(encode(arr))
  let form = this.readForm()
  let val = decodeString(form)
  return val

# Readers
# readForm is responsible for reading X amount of bytes from the socket
# until we have a complete RedisValue object
proc receiveManaged*(this: Redis, size = 1): string =
  result = newString(size)
  if this.timeout == 0:
    discard this.socket.recv(result, size)
  else:
    discard this.socket.recv(result, size, this.timeout)

# 读取到指定的终止符为止
proc readStream(this: Redis, breakAfter: string): string =
  var data = ""
  while true:
    if data.endsWith(breakAfter):
      break
    let strRead = this.receiveManaged()
    data &= strRead
  return data

# encodes some information about the values lengths we can totally make use of that
proc readMany(this: Redis, count: int = 1): string =
  if count == 0:
    return ""
  let data = this.receiveManaged(count)
  return data



proc readForm(this: Redis): string =
  var form = ""
  while true:
    let b = this.receiveManaged()
    form &= b
    if b == "+":
      form &= this.readStream(CRLF)
      return form
    elif b == "$":
      let bulklenstr = this.readStream(CRLF)
      let bulklenI = parseInt(bulklenstr.strip()) 
      form &= bulklenstr
      if bulklenI == -1:
        form &= CRLF
      # elif bulklenI == 0:
      #   echo "IN HERE.."
      #   form &= await this.readMany(1)
      #   echo fmt"FORM NOW >{form}<"
      #   form &= await this.readStream(CRLF)
        # echo fmt"FORM NOW >{form}<"
      else:
        form &= this.readMany(bulklenI)
        form &= this.readStream(CRLF)

      return form

  return form

when isMainModule:
  let redis = open()
  echo redis.exeCommand("get", @["a"])
