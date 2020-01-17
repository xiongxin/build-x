const warn = std.debug.warn;
const std  = @import("std");
const os   = std.os;
const assert = std.debug.assert;
const mem  = std.mem;
const ArrayList = std.ArrayList;
const fmt = std.fmt;
const unicode = std.unicode;


pub fn main() void {
  warn("a.cp={}.\n", .{ unicode.utf8CodepointSequenceLength('a') });
  warn("a.cp={}.\n", .{ unicode.utf8CodepointSequenceLength('在') });

  var a: u3 = 7;

  a <<= 1;
  a <<= 1;
  a <<= 1;
  a <<= 1;
  a <<= 1;

  warn("a.cp={}.\n", .{ a });
}