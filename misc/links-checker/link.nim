import os, httpclient
import strutils
import times
import asyncdispatch
import threadpool


type
    LinkCheckReslt = ref object
        link: string
        state: bool

proc checkLink(link: string): LinkCheckReslt =
    var client = newHttpClient()
    try:
        result = LinkCheckReslt(link: link, state: client.get(link).code == Http200)
    except:
        result = LinkCheckReslt(link: link, state: false)

proc sequentialLinksChecker(links: seq[string]): void =
    for index, link in links:
        if link.strip() != "":
            let res = checkLink(link)
            echo res.link, " is ", res.state

proc asyncCheckLink(link: string): Future[LinkCheckReslt] {.async.} =
    var client = newAsyncHttpClient()
    let future = client.get(link)
    # yield future means okay i'm done for now dear event loop 
    # you can schedule other tasks and continue my execution 
    # when you have more update on my fancy future 
    # when the eventloop comes back because the future now has some updates
    yield future
    if future.failed:
        return LinkCheckReslt(link: link, state: false)
    else:
        let resp = future.read()
        return LinkCheckReslt(link: link, state: resp.code == Http200)

proc asyncLinksChecker(links: seq[string]) {.async.} =
    var futures = newSeq[Future[LinkCheckReslt]]()

    for index, link in links:
        if link.strip() != "":
            echo "await ", index
            futures.add(asyncCheckLink(link))
    # waitFor -> call async proc from sync proc
    # await   -> call async proc from async proc
    let done = await all(futures)
    for x in done:
        echo x.link , " is ", x.state
when isMainModule:
    echo getTime()
    waitFor asyncLinksChecker(@["https://yahoo.com", "https://baidu.com", "https://oschina.net", "https://github.com", ""])
    echo getTime()