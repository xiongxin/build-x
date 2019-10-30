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

when isMainModule:
  let redis = open()
  echo repr(redis)
