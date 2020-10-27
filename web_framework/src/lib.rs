use std::collections::HashMap;
use std::fmt;
use std::ops::Index;

#[macro_use]
extern crate lazy_static;

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

pub fn http_method_from_string(txt: &str) -> Option<&HttpMethod> {
  HTTPMETHODMAP.get(txt)
}

struct HttpCode(usize);

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
      401 => write!(f, "400 Bad Request"),
      402 => write!(f, "400 Bad Request"),
      403 => write!(f, "400 Bad Request"),
      404 => write!(f, "400 Bad Request"),
      405 => write!(f, "400 Bad Request"),
      406 => write!(f, "400 Bad Request"),
      407 => write!(f, "400 Bad Request"),
      408 => write!(f, "400 Bad Request"),
      409 => write!(f, "400 Bad Request"),
      410 => write!(f, "400 Bad Request"),
      412 => write!(f, "400 Bad Request"),
      413 => write!(f, "413 Request Entity Too Large"),
      other => write!(f, "{}", other),
    }
  }
}

pub struct HttpHeaders {
  map: HashMap<String, HttpHeaderValues>,
}

pub type HttpHeaderValues = Vec<String>;

impl HttpHeaders {
  pub fn new() -> HttpHeaders {
    HttpHeaders {
      map: HashMap::new(),
    }
  }

  pub fn from_key_value(kv_pairs: Vec<(String, Vec<String>)>) -> HttpHeaders {
    let mut map = HashMap::new();
    for item in kv_pairs {
      map.insert(item.0, item.1);
    }

    HttpHeaders { map }
  }

  pub fn get(&self, key: &str) -> Option<&HttpHeaderValues> {
    self.map.get(key)
  }

  pub fn set(&mut self, key: &str, value: &str) {
    self.map.insert(key.to_owned(), vec![value.to_owned()]);
  }

  pub fn set_vec_value(&mut self, key: &str, value: Vec<String>) {
    self.map.insert(key.to_owned(), value);
  }

  pub fn add(&mut self, key: &str, value: &str) {
    if self.map.contains_key(key) {
      self.map.get_mut(key).unwrap().push(value.to_owned());
    } else {
      self.map.insert(key.to_owned(), vec![value.to_owned()]);
    }
  }

  pub fn add_many(&mut self, key: &str, value: &[&str]) {
    for val in value {
      self.add(key, val);
    }
  }

  pub fn del(&mut self, key: &str) {
    self.map.remove(key);
  }

  fn clear(&mut self) {
    self.map.clear();
  }
}

impl Index<&str> for HttpHeaders {
  type Output = HttpHeaderValues;

  fn index(&self, index: &str) -> &Self::Output {
    self.map.get(index).unwrap()
  }
}

struct Request {
  http_method: HttpMethod,
  http_version: HttpVersion,
  headers: HttpHeaders,
  path: String,
  body: String,
  query_params: HashMap<String, String>,
  form_data: HashMap<String, String>,
  url_params: HashMap<String, String>,
}
