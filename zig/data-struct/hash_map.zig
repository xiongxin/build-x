const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const math = std.math;
const mem = std.mem;
const meta = std.meta;
const autoHash = std.hash.autoHash;
const Wyhash = std.hash.Wyhash;
const Allocator = mem.Allocator;
const builtin = @import("builtin");

const want_modification_safety = builtin.mode != builtin.Mode.ReleaseFast;
const debug_u32 = if (want_modification_safety) u32 else void;




















pub fn getHashPtrAddrFn(comptime K: type) (fn (K) u32) {
  return struct {
    fn hash(key: K) u32 {
      return getAutoHashFn(usize)(@ptrToInt(key));
    }
  }.hash;
}

pub fn getAutoHashFn(comptime K: type) (fn (K) u32) {
  return struct {
    fn hash(key: K) u32 {
      var hasher = Wyhash.init(0);
      autoHash(&hasher, key);
      return @truncate(u32, hasher.final());
    }
  }.hash;
}

pub fn getAutoEqlFn(comptime K: type) (fn (K, K) bool) {
  return struct {
    fn eql(a: K, b: K) bool {
      return meta.eql(a, b);
    }
  }.eql;
}