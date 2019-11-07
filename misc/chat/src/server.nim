import asyncdispatch, asyncnet, os

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

proc*()
