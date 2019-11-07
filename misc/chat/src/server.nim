import asyncdispatch, asyncnet

type
    Client = ref object
        socket: AsyncSocket
        netAddr: string
        id: int
        connected: bool
    
    Server = ref object
        socket: AsyncSocket
        clients: seq[Client]

# constructs naming conventions
# object -> initMyType
# ref object -> newMyTYpe
proc newServer(): Server = Server(socket: newAsyncSocket(), clients: @[])
proc `$`(client: Client): string =
    $client.id & "(" & client.netAddr & ")"

proc processMessages(server: Server, client: Client) {.async.} =
    while true:
        let line = await client.socket.recvLine() 
        #this will pause its execution when await client.socket.recvLine() is called
        if line.len == 0: # signifies that the socket has disconnected from the server.
            echo client, " disconnected!"
            client.connected = false
            client.socket.close()
            return # stops ayn futher processing of messages
        echo client, " sent: ", line
        for c in server.clients:
            if c.id != client.id and c.connected:
                await c.socket.send(line & "\c\l")

proc loop(server: Server, port = 7687) {.async.} =
    server.socket.bindAddr(port.Port)
    server.socket.listen()

    while true:
        let (netAddr, clientSocket) = await server.socket.acceptAddr()
        echo "Accepted connection from ", netAddr
        let client = Client(
            socket: clientSocket,
            netAddr: netAddr,
            id: server.clients.len,
            connected: true
        )
        server.clients.add(client)
        # asynCheck command that run the processMessage procedure in the background
        # asynCheck command can be used to run asynchronous procedures without waiting one their result
        asyncCheck processMessages(server, client)

var server = newServer()
waitFor loop(server)
