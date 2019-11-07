
import asyncdispatch, asyncfile, os

proc readFiles() {.async.} =
  var file = openAsync("/home/xiongxin/Code/build-x/misc/async/test.txt", fmRead)
  let data = await file.readAll()
  echo data
  file.close()


while true:
  sleep(3000)
  waitFor readFiles()
  echo "in while true"




# Every time the await keyword is used, the
# execution of readFiles procedure is paused until the
# Future that's awaited is completed

# procedure controls event loop directly uses case/description
# runForever Yes Usually used for server applications that need to stay alive indefinitely
# waitFor    Yes Usually used for application that need to quit after a specific asynchronous procedure finishes its execution
# poll       Yes Listens for event for the specified amount of time
# asyncCheck No Used for discarding futures safely, typically to execute an async proc without worrying about its result
# await      No Pauses the execution of an async proc 