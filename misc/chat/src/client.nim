import os,threadpool, asyncdispatch, asyncnet
import protocol

proc connect(socket: AsyncSocket, serverAddr: string) {.async.} =
    echo "Connecting to ", serverAddr
    await socket.connect(serverAddr, 7687.Port)
    echo "Connected!"

    while true:
        let line = await socket.recvLine()
        let parsed = parseMessage(line)
        echo parsed.username, " said ", parsed.message


echo "Chat application statred"

if paramCount() == 0:
    quit("Please specify the server address, e.g. ./client localhost")

let serverAddr = paramStr(1)
echo "Connecting to ", serverAddr
var messageFlowVar = spawn stdin.readLine()
var socket = newAsyncSocket()

asyncCheck socket.connect(serverAddr)

while true:
    if messageFlowVar.isReady():
        let message = createMessage("Anonymous", ^messageFlowVar)
        asyncCheck socket.send(message)
        messageFlowVar = spawn stdin.readLine()
    asyncdispatch.poll()

# 项目优化点
# 1. 允许输入用户名
# 2. 实现客户端存活的监测 ping 命令
# 3. 强制用户下线