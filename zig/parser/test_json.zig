const std  = @import("std");
const warn = std.debug.warn;
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const TokenStream = @import("json.zig").TokenStream;
const fmt = std.fmt;
const maxInt = std.math.maxInt;
const testing = std.testing;

pub fn main() !void {
  const input =
    \\{"abc":{"abc":{"abc":{"abc":{"abc":{"abc":{"abc":122}}}}}}}
  ;
  var ts = TokenStream.init(input);
  warn("t = {} \n", .{try ts.next()});
  var token = try ts.next();
  warn("ts.i = {}\n", .{ ts.i });
  switch (token.?) {
    .String => |v| warn("v = {}, str = {}.\n", .{ v, v.slice(input, ts.i - 1) }),
    else => {}
  }

  token = try ts.next();
  switch (token.?) {
    .Number => |v| warn("v = {}, number = {}.\n", .{ v, v.slice(input, ts.i - 1) }),
    else => {}
  }
  warn("t = {} \n", .{try ts.next()});
}