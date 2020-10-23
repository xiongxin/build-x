# 项目来源 https://xmonader.github.io/nimdays/day12_resp.html

https://redis.io/topics/protocol
解析规则
- For Simple Strings the first byte of the reply is "+"
- For Errors the first byte of the reply is "-"
- For Integers the first byte of the reply is ":"
- For Bulk Strings the first byte of the reply is "$"
- For Arrays the first byte of the reply is "*"