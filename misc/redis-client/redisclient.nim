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

proc openAsync*(host = "localhost", port = 6379.Port, ssl = false, timeout = 0) :
  Future[AsyncRedis] {.async.} = 
  result = AsyncRedis(
    socket: newAsyncSocket()
  )

  result.pipeline = @[]
  result.timeout = timeout
  ## ... code omitted for supporting ssl
  await result.socket.connect(host, port)
  result.connected = true

proc readForm(this: Redis|AsyncRedis): Future[string]

proc exeCommand*(this: Redis|AsyncRedis, command: string, args: seq[string]) : Future[RedisValue] {.multisync.} =
  let cmdArgs = concat(@[command], args)
  var cmdAsRedisValues = newSeq[RedisValue]()
  for cmd in cmdArgs:
    cmdAsRedisValues.add(RedisValue(kind: vkBulkStr, bs: cmd))
  var arr = RedisValue(kind: vkArray, l: cmdAsRedisValues)
  await this.socket.send(encode(arr))
  let form = await this.readForm()
  let val = decodeString(form)
  return val

# Readers
# readForm is responsible for reading X amount of bytes from the socket
# until we have a complete RedisValue object

# encodes some information about the values lengths we can totally make use of that
proc readMany(this: Redis|AsyncRedis, count: int = 1): Future[string] {.multisync.} =
  if count == 0:
    return ""
  let data = await this.receiveManaged(count)
  return data

proc receiveManaged*(this: Redis|AsyncRedis, size = 1): Future[string] {.multisync.} =
  result = newString(size)
  when this is Redis:
    if this.timeout == 0:
      discard this.socket.recv(result, size)
    else:
      discard this.socket.recv(result, size, this.timeout)
  else:
    discard await this.socket.recvInto(addr result[0], size)

proc readForm(this: Redis|AsyncRedis): Future[string] {.multisync.} =
  var form = ""

  return form

when isMainModule:
  let redis = open()
  echo repr(redis)
