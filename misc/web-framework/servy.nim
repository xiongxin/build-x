import options, tables, strutils,parseutils, asyncdispatch, asyncnet, cgi, strformat
type
  HttpVersion* = enum
    HttpVer11,
    HttpVer10
  
  HttpMethod* = enum
    HttpHead,
    HttpGet,
    HttpPost,
    HttpPut,
    HttpDelete,
    HttpTrace,
    HttpOptions,
    HttpConnect,
    HttpPatch

  HttpHeaders* = ref object
    table*: TableRef[string, seq[string]]
  
  HttpHeaderValues = seq[string]

  HttpCode* = distinct range[0 .. 599]

  Request = object
    httpMethod*: HttpMethod
    httpVersion*: HttpVersion
    headers*: HttpHeaders
    path*: string
    body*: string
    queryParams*: TableRef[string, string]
    formData*: TableRef[string, string]
    urlParams*: TableRef[string, string]

  Response = object
    headers: HttpHeaders
    httpver: HttpVersion
    code: HttpCode
    content: string

  ServerOptions* = object
    address: string
    port: Port
    debug: bool

  MiddlewareFunc* = proc(req: var Request, resp: var Response): bool
  HandlerFunc* = proc(req: var Request, resp: var Response): void

  RouterValue* = object
    handlerFunc: HandlerFunc
    httpMethod: HttpMethod
    middlewares: seq[MiddlewareFunc]

  Router* = object
    table: Table[string, RouterValue]
    notFoundHandler: HandlerFunc
  
  Servy = object
    options: ServerOptions
    router: Router
    middlewares: seq[MiddlewareFunc]
    staticDir: string
    sock: AsyncSocket


const
  Http100* = HttpCode(100)
  Http101* = HttpCode(101)
  Http200* = HttpCode(200)
  Http201* = HttpCode(201)
  Http202* = HttpCode(202)
  Http203* = HttpCode(203)
  Http204* = HttpCode(204)
  Http205* = HttpCode(205)
  Http206* = HttpCode(206)
  Http300* = HttpCode(300)
  Http301* = HttpCode(301)
  Http302* = HttpCode(302)
  Http303* = HttpCode(303)
  Http304* = HttpCode(304)
  Http305* = HttpCode(305)
  Http307* = HttpCode(307)
  Http400* = HttpCode(400)
  Http401* = HttpCode(401)
  Http403* = HttpCode(403)
  Http404* = HttpCode(404)
  Http405* = HttpCode(405)
  Http406* = HttpCode(406)
  Http407* = HttpCode(407)
  Http408* = HttpCode(408)
  Http409* = HttpCode(409)
  Http410* = HttpCode(410)
  Http411* = HttpCode(411)
  Http412* = HttpCode(412)
  Http413* = HttpCode(413)
  Http414* = HttpCode(414)
  Http415* = HttpCode(415)
  Http416* = HttpCode(416)
  Http417* = HttpCode(417)
  Http418* = HttpCode(418)
  Http421* = HttpCode(421)
  Http422* = HttpCode(422)
  Http426* = HttpCode(426)
  Http428* = HttpCode(428)
  Http429* = HttpCode(429)
  Http431* = HttpCode(431)
  Http451* = HttpCode(451)
  Http500* = HttpCode(500)
  Http501* = HttpCode(501)
  Http502* = HttpCode(502)
  Http503* = HttpCode(503)
  Http504* = HttpCode(504)
  Http505* = HttpCode(505)
const maxLine = 8 * 1024

proc newHttpHeaders*(): HttpHeaders =
  result = new HttpHeaders
  result.table = newTable[string, seq[string]]()

proc newHttpHeaders*(keyValuePairs: seq[tuple[key: string, val: string]]) : HttpHeaders =
  var pairs: seq[tuple[key: string, val: seq[string]]] = @[]
  for pair in keyValuePairs:
    pairs.add((pair.key.toLowerAscii(), @[pair.val]))
  
  result = new HttpHeaders
  result.table = newTable[string, seq[string]](pairs)


proc clear*(headers: HttpHeaders) =
  headers.table.clear()

proc `[]`*(headers: HttpHeaders, key: string): HttpHeaderValues =
  ## Returns the values associated with the given `key`.
  return headers.table[key.toLowerAscii].HttpHeaderValues

proc `[]`*(headers: HttpHeaders, key: string, i: int) : string =
  return headers.table[key.toLowerAscii()][i]

proc `[]=`*(headers: HttpHeaders, key, value: string) =
  headers.table[key.toLowerAscii()] = @[value]

proc `[]=`*(headers: HttpHeaders, key: string, value: seq[string]) =
  headers.table[key.toLowerAscii] = value

proc add*(headers: HttpHeaders, key, value: string) =
  if not headers.table.hasKey(key.toLowerAscii()):
    headers.table[key.toLowerAscii()] = @[value]
  else:
    headers.table[key.toLowerAscii()].add(value)


proc del*(headers: HttpHeaders, key: string) =
  ## Delete the header entries associated with ``key``
  headers.table.del(key.toLowerAscii)

iterator pairs*(headers: HttpHeaders): tuple[key, value: string] =
  ## Yields each key, value pair.
  for k, v in headers.table:
    for value in v:
      yield (k, value)

proc contains*(values: HttpHeaderValues, value: string): bool =
  ## Determines if ``value`` is one of the values inside ``values``. Comparison
  ## is performed without case sensitivity.
  for val in seq[string](values):
    if val.toLowerAscii == value.toLowerAscii: return true

proc hasKey*(headers: HttpHeaders, key: string): bool =
  return headers.table.hasKey(key.toLowerAscii())

proc getOrDefault*(headers: HttpHeaders, key: string,
    default = @[""].HttpHeaderValues): HttpHeaderValues =
  ## Returns the values associated with the given ``key``. If there are no
  ## values associated with the key, then ``default`` is returned.
  if headers.hasKey(key):
    return headers[key]
  else:
    return default

proc parseList(line: string, list: var seq[string], start: int): int =
  var i = 0
  var current = ""
  while start + i < line.len and line[start + i] notin { '\c', '\l' }:
    i += line.skipWhitespace(start + i) # 跳过前置空格
    i += line.parseUntil(current, { '\c', '\l', ',' }, start + i)
    list.add(current)

proc parseHeader*(line: string): tuple[key: string,value: seq[string]] =
  result.value = @[]
  var i = 0
  i = line.parseUntil(result.key, ":")
  inc(i)  # skip :
  if i < len(line):
    i += parseList(line, result.value, i)
  elif result.key.len > 0:
    result.value = @[""]
  else:
    result.value = @[]

proc len*(headers: HttpHeaders): int = return headers.table.len

proc `$`*(headers: HttpHeaders): string =
  return $headers.table

proc `$`(ver: HttpVersion) : string =
  case ver
  of HttpVer10: result = "HTTP/1.0"
  of HttpVer11: result = "HTTP/1.1"

proc `$`(code: HttpCode) : string =
  case code.int:
  of 100: "100 Continue"
  of 101: "101 Switching Protocols"
  of 200: "200 OK"
  of 201: "201 Created"
  of 202: "202 Accepted"
  of 203: "203 Non-Authoritaive Information"
  of 204: "204 No Content"
  of 205: "205 Reset Content"
  of 206: "300 Multiple Choices"
  of 300: "300 Multiple Choices"
  of 301: "301 Moved Permanently"
  of 302: "302 Found"
  of 303: "303 See Other"
  of 304: "304 Not Modified"
  of 305: "307 Use Proxy"
  of 307: "307 Temporary Redirect"
  of 400: "400 Bad Request"
  of 401: "401 Unauthorized" # 未验证
  of 403: "403 Forbidden"    # 未授权
  of 404: "404 Not Found"
  of 407: "407 Proxy Authentication"
  of 408: "408 Request Timeout"
  of 409: "409 Conflict"
  of 410: "410 Gone"
  of 411: "411 Length Required"
  of 412: "412 Precondition Failed"
  of 413: "413 Request Entity Too Large"
  of 414: "414 Request-URI Too Long"
  of 415: "415 Unsupported Media Type"
  of 416: "416 Requested Range Not Satisfiable"
  of 417: "417 Expectation Failed"
  of 418: "418 I'm a teapot"
  of 421: "421 Misdirected Request"
  of 422: "422 Unprocessable Entity"
  of 426: "426 Upgrade Required"
  of 428: "428 Precondition Required"
  of 429: "429 Too Many Requests"
  of 431: "431 Request Header Fields Too Large"
  of 451: "451 Unavailable For Legal Reasons"
  of 500: "500 Internal Server Error"
  of 501: "501 Not Implemented"
  of 502: "502 Bad Gateway"
  of 503: "503 Service Unavailable"
  of 504: "504 Gateway Timeout"
  of 505: "505 HTTP Version Not Supported"
  of 506: "506 Variant Also Negotiates"
  of 507: "507 Insufficient Storage"
  of 508: "508 Loop Detected"
  of 510: "510 Not Extended"
  of 511: "511 Network Authentication Required"
  of 599: "599 Network Connect Timeout Error"
  else: $(code.int)


proc httpMethodFrom(txt: string) : Option[HttpMethod] =
  let s2m = {
    "GET": HttpGet, 
    "POST": HttpPost, 
    "PUT":HttpPut, 
    "PATCH": HttpPatch, 
    "DELETE": HttpDelete, 
    "HEAD":HttpHead
    }.toTable()
  if txt in s2m:
    result = some(s2m[txt.toUpper()])
  else:
    result = none(HttpMethod)

proc parseQueryParams(content: string): TableRef[string, string]

proc parseRequestFromConnection(s: ref Servy, conn: AsyncSocket): Future[Request] {.async.} =
  result.queryParams = newTable[string, string]()
  result.formData = newTable[string, string]()
  result.urlParams = newTable[string, string]()

  let requestLine = $await conn.recvLine(maxLength = maxLine)
  echo fmt"requestLine: >{requestLine}< "
  var meth, path, httpver: string
  var parts = requestLine.splitWhitespace()
  meth = parts[0]
  path = parts[1]
  httpver = parts[2]
  var contentLength = 0
  echo meth, path, httpver
  let m = httpMethodFrom(meth)
  if m.isSome():
    result.httpMethod = m.get()
  else:
    echo meth
    raise newException(OSError, "invalid httpmethod")
  if "1.1" in httpver:
    result.httpVersion = HttpVer11
  elif "1.0" in httpver:
    result.httpVersion = HttpVer10
  else:
    raise newException(OSError, "unsporrt http version")
  
  result.path = path

  if "?" in path:
    result.queryParams = parseQueryParams(path)
  
  result.headers = newHttpHeaders()

  # parse headers
  var line = ""
  line = $(await conn.recvLine(maxLength = maxLine))
  echo fmt"line: >{line}<"
  while line != "\r\n":
    # a header line
    let kv = parseHeader(line)
    result.headers[kv.key] = kv.value
    if kv.key.toLowerAscii == "content-length":
      contentLength = parseInt(kv.value[0])
    line = $(await conn.recvLine(maxLength = maxLine))

proc parseQueryParams(content: string): TableRef[string, string] =
  result = newTable[string, string]()
  var consumed = 0
  if "?" notin content and "=" notin content:
    return
  if "?" in content:
    consumed += content.skipUntil({ '?' }, consumed)

  inc consumed # skip ?
  
  while consumed < content.len:
    if "=" notin content[consumed .. ^1]:
      break
    var key = ""
    var val = ""
    consumed += content.parseUntil(key, "=", consumed)
    inc consumed # skip =
    consumed += content.parseUntil(val, "&", consumed)
    inc consumed # skip &
    result.add(decodeUrl(key), decodeUrl(val))
    echo "consumed:" & $consumed
    echo "contentLen:" & $content.len

when isMainModule:
  echo parseHeader("Content-Type: text/html")
  echo parseQueryParams("/?a=1&b=22&aaa[]=asasdf&aaa[]=xxx&aaa[]=ddd").getOrDefault("aaa[]")