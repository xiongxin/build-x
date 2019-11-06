import asyncdispatch, os, httpclient

# 异步调度器

proc s1():Future[string] {.async.} = 
    echo "in s1() proc"
    sleep(3000)
    return "s1"
proc s2() {.async.} =
    sleep(3000)
    echo "in s2() proc"
proc process() {.async.} =
    var client = newAsyncHttpClient()

    while true:

        var s = await client.getContent("https://nim-lang.org/docs/asyncnet.html")
        echo s[0..10]
        echo "process"


proc loop() {.async.} = 
    var client = newAsyncHttpClient()

    while true:
        
        var s = await client.getContent("https://nim-lang.org/docs/asyncdispatch.html")
        echo s[0..10]
        asyncCheck process()
        echo 1111

waitFor(loop())