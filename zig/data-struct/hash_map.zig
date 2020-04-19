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
const want_modification_safety = builtin.mode != builtin.Mode.ReleaseFast; // 非快速模式下面
const debug_u32 = if (want_modification_safety) u32 else void; // 非快速模式下面debug

pub fn AutoHashMap(comptime K: type, comptime V: type) type {
    return HashMap(K, V, getAutoHashFn(K), getAutoEqlFn(K));
}

pub fn struct HashMap(
  comptime K: type, 
  comptime V: type, 
  comptime hash: fn (key: K) u32, 
  comptime eql: fn (a: K, b: K) bool
) type {
  return struct {
    entries: []Entry,
    size: usize,
    max_distance_from_start_index: usize,
    allocator: *Allocator,

    /// This is used to detect bugs where a hashtable is edited while an iterator is running
    modification_count: debug_u32,

    const Self = @This();

    /// A *KV is a mutable pinter into this HashMap's internal storage.
    /// Modifing the key is undefined behavior.
    /// Modifing the value is harmless.
    /// *KV pointers become invalid whenever this HashMap is modified,
    /// and then any access to the *KV is undefined behavior.
    pub const KV = struct {
      key: K,
      value: V,
    };

    const Entry = struct {
      used: bool,
      distance_from_start_index: usize,
      kv: KV,
    };

    pub const GetOrPutResult = struct {
      kv: *KV,
      found_existing: bool,
    };

    const InternalPutResult = struct {
      new_entry: *Entry,
      old_kv: ?KV,
    };

    pub const Iterator = struct {
      hm: *const Self,
      // how many items have we returned
      count: usize,
      // iterator through the entry array
      index: usize,
      // used to detect concurrent modification
      initial_modification_count: debug_u32,

      pub fn next(it: Iterator) ?*KV {
        if (want_modification_safety) {
          // concurrent modification
          assert(
            it.initial_modification_count == it.hm.modification_count
          );
        }
        if (it.count >= it.hm.size) return null;
        while (it.index < it.hm.len) : (it.index += 1) {
          const entry = &it.hm.entries[it.index];
          if (entry.used) {
            it.index += 1;
            it.count += 1;
            return &entry.kv;
          }
        }
        unreachable; // no next item
      }

      pub fn reset(it: *Iterator) void {
        it.count = 0;
        it.index = 0;
        // Resetting the modification count too
        it.initial_modification_count = it.hm.modification_count;
      }
    };

    pub fn init(allocator: *Allocator) Self {
      return Self{
        .entries = &[_]Entry{},
        .allocator = allocator,
        .size = 0,
        .max_distance_from_start_index = 0,
        .modification_count = if (want_modification_safety) 0 else {},
      };
    }

    pub fn deinit(hm: Self) void {
      hm.allocator.free(hm.entries);
    }

    pub fn clear(hm: *Self) void {
      for (hm.entries) |*entry| {
        entry.used = false;
      }
      hm.size = 0;
      hm.max_distance_from_start_index = 0;
      
    }

    pub fn count(self: Self) usize {
      return self.size;
    }

    pub fn getOrPut(self: *Self, key: K) !GetOrPutResult {
      if (self.get(key)) |kv| {
        return GetOrPutResult{
          .kv = kv,
          .found_existing = true,
        };
      }

      self.incrementModificationCount();
      try self.autoCapacity();
      const put_result = self.internalPut(key);
      assert(put_result.old_kv == null);
      return GetOrPutResult{
        .kv = &put_result.new_entry.kv,
        .found_existing = false,
      }
    }

    pub fn get(hm: *const Self, key: K) ?*KV {
      if (hm.entries.len == 0) {
        return null;
      }

      return hm.internalGet(key);
    }

    fn internalGet(hm: Self, key: K) ?*KV {
      const start_index = hm.keyToIndex(key);
      {
        var roll_over: usize = 0;
        while (roll_over <= hm.max_distance_from_start_index) : (roll_over += 1) {
          const index = hm.constrainIndex(start_index + roll_over);
          const entry = &hm.entries[index];

          if (!entry.used) return null;
          if (eql(entry.kv.key, key)) return &entry.kv;
        }
      }
      return null;
    }

    /// Returns a pointer to the new entry
    /// Asserts that there is enough space for the new item
    fn internalPut(self: *Self, orig_key: K) InternalPutResult {
      var key = orig_key;
      var value: V = undefined;
      const start_index = self.keyToIndex(key);
      var roll_over: usize = 0;
      var distance_from_start_index: usize = 0;
      var got_result_entry = false;
      var result = InternalPutResult{
        .new_entry=undefined,
        .old_kv = null,
      };

      while (roll_over < self.entries.len) : ({
        roll_over += 1;
        distance_from_start_index += 1
      }) {
        const index = self.constrainIndex(start_index + roll_over);
        const entry = &self.entries[index];

        if (entry.used and !eql(entry.kv.key, key)) { // hash碰撞了

        }
      }
    }

    pub fn keyToIndex(hm: Self, key: K) usize {
      return hm.constrainIndex(@as(usize, hash(key)));
    }

    fn constrainIndex(hm:Self, i: usize) usize {
      return i & (hm.entries.len - 1);
    }
  };
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
