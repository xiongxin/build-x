import json

type
    Message* = object
        username*: string
        message*: string

proc parseMessage*(data: string) : Message =
    let dataJson = parseJson(data)
    result.username = dataJson["username"].getStr()
    result.message  = dataJson["message"].getStr()

proc createMessage*(username, message: string): string =
    # {"key1": "value1", "key2": "value2"} is the same as [("key1", "value1"), ("key2, "value2")] .
    result = $(%{
        "username": %username,
        "message" : %message
    }) & "\c\l"

when isMainModule:
    block test:
        let data = """{"username": "John", "message": "Hi!"}"""
        let parsed = parseMessage(data)
        echo parsed.message
        echo parsed.username
    block test:
        let data = "foobar"
        try:
            let parsed = parseMessage(data)
            doAssert false
        except JsonParsingError:
            doAssert true
        except:
            doAssert false
    block test:
        let data = { "a": 1, "b": 2 }
        echo repr(data)
        let a = { 1, 2 }
        echo repr(a.len)
    block test:
        let str = createMessage("John", "Hi")
        echo str