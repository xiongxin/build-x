一个bencode解码器

参考资料:
- https://www.cnblogs.com/technology/p/BEncoding.html
- https://xmonader.github.io/nimdays/day02_bencode.html

解析格式
- 字符串, `length:string`, 比如 `3:yes`
- 整数格式, 在字符`i`,`e`之间，例如: `i59e`
- 列表格式, 在字符`l`,`e`之间, 例如:`li1ei2ee`
- 字典格式: 在字符`d`, `e`之间,例如: `d4:name2:hi3:numi3ee`