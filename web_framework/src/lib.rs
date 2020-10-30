use std::collections::HashMap;
use std::fmt;
use std::net::*;
use std::ops::Index;
use thiserror::Error;

#[macro_use]
extern crate lazy_static;

#[derive(Debug)]
pub enum HttpVersion {
  HttpVer11,
  HttpVer10,
}

impl fmt::Display for HttpVersion {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    match self {
      HttpVersion::HttpVer11 => write!(f, "HTTP/1.1"),
      HttpVersion::HttpVer10 => write!(f, "HTTP/1.0"),
    }
  }
}

#[derive(Debug)]
pub enum HttpMethod {
  Head,
  Get,
  Post,
  Put,
  Delete,
  Trace,
  Options,
  Connect,
  Patch,
}

#[derive(Debug)]
pub struct HttpCode(usize);

const MaxLine: usize = 8 * 1024; // 最大解析http请求数据大小8M
const Http200: HttpCode = HttpCode(200);
const Http201: HttpCode = HttpCode(201);
const Http202: HttpCode = HttpCode(202);
const Http204: HttpCode = HttpCode(204);
const Http205: HttpCode = HttpCode(205);

const Http300: HttpCode = HttpCode(300);
const Http301: HttpCode = HttpCode(301);
const Http302: HttpCode = HttpCode(302);
const Http303: HttpCode = HttpCode(303);

const Http400: HttpCode = HttpCode(400);
const Http401: HttpCode = HttpCode(401);
const Http402: HttpCode = HttpCode(402);
const Http403: HttpCode = HttpCode(403);
const Http404: HttpCode = HttpCode(404);
const Http405: HttpCode = HttpCode(405);
const Http406: HttpCode = HttpCode(406);

const Http451: HttpCode = HttpCode(451);
const Http500: HttpCode = HttpCode(500);

impl fmt::Display for HttpCode {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    match self.0 {
      100 => write!(f, "100 Continue"),
      101 => write!(f, "101 Switching Protocols"),

      200 => write!(f, "200 OK"),
      201 => write!(f, "201 Created"),
      202 => write!(f, "202 Accepted"),
      204 => write!(f, "204 No Content"),
      205 => write!(f, "205 Rest Content"),
      206 => write!(f, "206 Partial Content"),

      300 => write!(f, "300 Multiple Choices"),
      301 => write!(f, "301 Moved Permanently"),
      302 => write!(f, "302 Found"),
      303 => write!(f, "303 See Other"),
      304 => write!(f, "304 Not Modified"),
      305 => write!(f, "305 Use Proxy"),
      306 => write!(f, "307 Teporary Redirect"),
      308 => write!(f, "308 Permanent Redirect"),

      400 => write!(f, "400 Bad Request"),
      401 => write!(f, "401 Unauthorized"),
      403 => write!(f, "403 Forbidden"),
      404 => write!(f, "404 Not Found"),
      405 => write!(f, "405 Method Not Allowed"),
      406 => write!(f, "406 Not Acceptable"),
      407 => write!(f, "407 Proxy Authentication Required"),
      408 => write!(f, "408 Reques Timeout"),
      409 => write!(f, "409 Confict"),
      410 => write!(f, "410 Gone"),
      411 => write!(f, "411 Length Required"),
      412 => write!(f, "412 Precondition Failed"),
      413 => write!(f, "413 Request Entity Too Large"),
      414 => write!(f, "414 Request-URI Too Long"),
      415 => write!(f, "415 Unsupported Media Type"),
      416 => write!(f, "416 Requested Range Not Satisfiable"),
      417 => write!(f, "417 Expectation Failed"),
      418 => write!(f, "418 I'm a teapot"),
      421 => write!(f, "421 Misdirected Request"),
      422 => write!(f, "422 Unprocessable Entity"),
      426 => write!(f, "426 Upgrade Required"),
      428 => write!(f, "428 Precondition Required"),
      429 => write!(f, "429 Too Many Requests"),
      431 => write!(f, "431 Request Header Fields Too Large"),
      451 => write!(f, "451 Unavailable For Legal Reasons"),

      500 => write!(f, "500 Internal Server Error"),
      501 => write!(f, "501 Not Implemented"),
      502 => write!(f, "502 Bad Gateway"),
      503 => write!(f, "503 Service Unavailable"),
      504 => write!(f, "504 Gateway Timeout"),
      505 => write!(f, "505 HTTP Version Not Supported"),
      506 => write!(f, "506 Variant Also Negotiates"),
      507 => write!(f, "507 Insufficient Storage"),
      508 => write!(f, "508 Loop Detected"),
      510 => write!(f, "510 Not Extended"),
      511 => write!(f, "511 Network Authentication Required"),
      599 => write!(f, "599 Network Connect Timout Error"),
      other => write!(f, "{}", other),
    }
  }
}

pub type HttpHeaders = HashMap<String, HttpHeaderValues>;

pub type HttpHeaderValues = Vec<String>;

pub enum SameSite {
  None,
  Strict,
  Lax,
}

pub fn build_set_cookie_header(
  cookiename: &str,
  cookievalue: &str,
  domain: &str,
  expires: &str,
  maxage: usize,
  path: &str,
  same_site: SameSite,
  secure: bool,
  httponly: bool,
) -> String {
  let mut valid_strs = Vec::new();
  let mut result = String::from("Set-Cookie: ");
  result += &format!("{}={}", cookiename, cookievalue);

  if expires.len() > 0 {
    valid_strs.push(format!("Expires={}", expires));
  }
  if domain.len() > 0 {
    valid_strs.push(format!("Domain={}", domain));
  }
  if maxage > 0 {
    valid_strs.push(format!("Max-Age={}", maxage));
  }
  if path.len() > 0 {
    valid_strs.push(format!("Path={}", path));
  }
  if secure {
    valid_strs.push(format!("Secure"));
  }
  if httponly {
    valid_strs.push(format!("HttpOnly"));
  }

  match same_site {
    SameSite::Strict => valid_strs.push(format!("SameSite=Strict")),
    SameSite::Lax => valid_strs.push(format!("SameSite=Lax")),
    _ => {}
  }

  result += &valid_strs.join("; ");

  result
}

lazy_static! {
  static ref HTTPMETHODMAP: HashMap<&'static str, HttpMethod> = {
    let mut m = HashMap::new();
    m.insert("head", HttpMethod::Head);
    m.insert("get", HttpMethod::Get);
    m.insert("post", HttpMethod::Post);
    m.insert("put", HttpMethod::Put);
    m.insert("delete", HttpMethod::Delete);
    m.insert("trace", HttpMethod::Trace);
    m.insert("options", HttpMethod::Options);
    m.insert("connect", HttpMethod::Connect);
    m.insert("patch", HttpMethod::Patch);

    m
  };
}

#[derive(Error, Debug)]
enum HeaderError {
  #[error("header key parse error from line : {0}")]
  HeaderKeyParseError(String),
}

pub fn http_method_from_string(txt: &str) -> Option<&HttpMethod> {
  HTTPMETHODMAP.get(txt)
}

/// Parse a single raw header HTTP line into key value pairs
///
/// Used by http internally and should not be used by you.
fn parse_header(line: &str, sep: &str) -> Result<(String, HttpHeaderValues), HeaderError> {
  let mut colon_index = line
    .find(":")
    .ok_or(HeaderError::HeaderKeyParseError(format!("{}", line)))?;
  let key = &line[..colon_index];
  colon_index += 1; // skip :

  let mut value = Vec::new();

  if colon_index < line.len() {
    value = line[colon_index..]
      .split(sep)
      .map(str::trim)
      .map(str::to_owned)
      .collect();
  } else if key.len() > 0 {
    value = vec![String::from("")];
  }

  Ok((key.to_owned(), value))
}

#[derive(Debug)]
struct FormPart {
  name: String,
  headers: HttpHeaders,
  filename: String,
  body: String,
}

impl FormPart {
  fn new() -> FormPart {
    FormPart {
      name: String::new(),
      headers: HttpHeaders::new(),
      filename: String::new(),
      body: String::new(),
    }
  }
}

impl fmt::Display for FormPart {
  fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
    write!(
      f,
      "name: {} filename: {} headers: {:?}, body: {}",
      self.name, self.filename, self.headers, self.body
    )
  }
}

type FormMultiPart = HashMap<String, FormPart>;

#[derive(Debug)]
struct Request {
  pub http_method: HttpMethod,
  pub request_uri: String,
  pub http_version: HttpVersion,
  pub headers: HttpHeaders,
  pub path: String,
  pub body: String,
  pub raw_body: String,
  pub query_params: HashMap<String, String>,
  pub form_data: FormMultiPart,
  pub url_params: HashMap<String, String>,
  pub cookies: HashMap<String, String>,
  pub socket: TcpStream,
}

#[derive(Debug)]
pub struct Response {
  pub headers: HttpHeaders,
  pub httpver: HttpVersion,
  pub code: HttpCode,
  pub content: String,
}

type MiddlewareFunc = Box<FnMut(&mut Request, &mut Response) -> bool>;
type HandlerFunc = Box<FnMut(&mut Request, &mut Response)>;

struct RouterValue {
  handler_func: HandlerFunc,
  http_method: HttpMethod,
  middlewares: Vec<MiddlewareFunc>,
}

struct Router {
  map: HashMap<String, RouterValue>,
  not_found_handler: HandlerFunc,
}

pub fn abort_with(res: &mut Response, msg: &str, code: HttpCode) {
  res.content = msg.to_owned();
  res.code = code;
}

pub fn redirect_to()

#[cfg(test)]
mod test {
  use super::*;

  #[test]
  fn test_parse_header() {
    let h1 = "head1: v1, v2";
    println!("{:?}", parse_header(h1, ":").unwrap());
  }

  fn mf(request: &mut Request, response: &mut Response) -> bool {
    request.body = String::from("s: &str");
    true
  }

  #[test]
  fn test_form_multi_part() {
    let formMP = FormMultiPart::new();
  }

  #[test]
  fn test_middle_func() {
    let mdf = Box::new(mf);
  }
}
