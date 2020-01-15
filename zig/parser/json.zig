const std = @import("std");
const debug = std.debug;
const assert = debug.assert;
const testing = std.testing;
const mem = std.mem;
const maxInt = std.math.maxInt;

const StringEscapes = union(enum) {
  None,

  Some: struct {
    size_diff: isize,
  },
};

/// A single token slice into the parent string.
///
/// Use `token.slice()` on the input at current
/// poisition to get the current slice.
pub const Token = union(enum) {
  ObjectBegin,
  ObjectEnd,
  ArrayBegin,
  ArrayEnd,
  String: struct {
    /// How many bytes the token is.
    count: usize,

    /// Whether string contains an escape sequence and cannot be zero-copied
    escapes: StringEscapes,

    pub fn decodeLength(self: @This()) usize {
      return self.count +% switch(self.escapes) {
        .None => 0,
        .Some => |s| @bitCast(usize, s.size_diff),
      };
    }

    /// Slice into the underlying input string.
    pub fn slice(self: @This(), input: []const u8, i: usize) []const u8 {
      return input[i - self.count .. i];
    }
  },
  Number: struct {
    /// How many bytes the token is.
    count: usize,

    /// Whether number is simple and can be represented by an integer
    is_integer: bool,

    /// Slice into the underlying input string.
    pub fn slice(self: @This(), input: []const u8, i: usize) []const u8 {
      return input[i - self.count .. i];
    }
  },
  True,
  False,
  Null,
};


pub const StreamingParser = struct {
  state: State, // 当前步骤
  count: usize, // 当前token的byte数量
  after_string_state: State, //解析字符串之后的State
  after_value_state: State, //解析value之后的State
  complete: bool, // 是否已经完成解析
  string_escapes: StringEscapes, // 传递给下一个生产的当前的token标志
  string_last_was_high_surrogate: bool, // 
  string_unicode_codepoint: u21,
  sequence_first_byte: u8 = undefined, 
  number_is_interger: bool, // .Number State是否有效
  stack: u256, // 嵌套的object和map字面量 bit栈，最大嵌套255层
  stack_used: u8, // 已经使用的栈

  const object_bit = 0;
  const array_bit = 1;
  const max_stack_size = maxInt(u8);

  pub fn init()StreamingParser {
    var p: StreamingParser = undefined;
    p.reset();
    return p;
  }

  pub fn reset(p: *StreamingParser) void {
    p.state = .TopLevelBegin;
    p.count = 0;
    // Set before ever read in main transition function
    p.after_string_state = undefined;
    p.after_value_state  = .ValueEnd; // handle end of values normally
    p.stack = 0;
    p.stack_used = 0;
    p.complete = false;
    p.string_escapes = undefined;
    p.string_last_was_high_surrogate = undefined;
    p.string_unicode_codepoint = undefined;
    p.number_is_interger = undefined;
  }

  pub const State = enum {
    ObjectSeparator = 0,
    ValueEnd = 1,

    TopLevelBegin,
    TopLevelEnd,

    ValueBegin,
    ValueBeginNoClosing,

    String,
    StringUtf8Byte2Of2,
    StringUtf8Byte2Of3,
    StringUtf8Byte3Of3,
    StringUtf8Byte2Of4,
    StringUtf8Byte3Of4,
    StringUtf8Byte4Of4,
    StringEscapeCharacter,
    StringEscapeHexUnicode4,
    StringEscapeHexUnicode3,
    StringEscapeHexUnicode2,
    StringEscapeHexUnicode1,

    Number,
    NumberMaybeDotOrExponent,
    NumberMaybeDigitOrDotOrExponent,
    NumberFractionalRequired,
    NumberFractional,
    NumberMaybeExponent,
    NumberExponent,
    NumberExponentDigitsRequired,
    NumberExponentDigits,

    TrueLiteral1,
    TrueLiteral2,
    TrueLiteral3,

    FalseLiteral1,
    FalseLiteral2,
    FalseLiteral3,
    FalseLiteral4,

    NullLiteral1,
    NullLiteral2,
    NullLiteral3,

    // Only call this function to generate array/object final state.
    pub fn fromInt(x: var) State {
      debug.assert(x == 0 or x == 1);
      const T = @TagType(State);
      return @intToEnum(State, @intCast(T, x));
    } 
  };

  pub const Error = error{
    InvalidTopLevel,
    TooManyNestedItems,
    TooManyClosingItems,
    InvalidValueBegin,
    InvalidValueEnd,
    UnbalancedBrackets,
    UnbalancedBraces,
    UnexpectedClosingBracket,
    UnexpectedClosingBrace,
    InvalidNumber,
    InvalidSeparator,
    InvalidLiteral,
    InvalidEscapeCharacter,
    InvalidUnicodeHexSymbol,
    InvalidUtf8Byte,
    InvalidTopLevelTrailing,
    InvalidControlCharacter,
  };

  /// Give another byte to the parser and obtain any new tokens.
  /// This may(rarely) return two tokens.
  /// token2 is always null if token1 is null.
  ///
  /// There is currently no error recovery on a bad stream.
  pub fn feed(p: *StreamingParser, c: u8, token1: *?Token, token2: *?Token) Error!void {
    token1.* = null;
    token2.* = null;
    p.count += 1;

    // unlikely
    if (try p.transition(c, token1)) {
      _ = try p.transition(c, token2);
    }
  }

  // Perform a single transition on the state machine and return any possible token.
  fn transition(p: *StreamingParser, c: u8, token: *?Token) Error!bool {
    switch (p.state) {
      .TopLevelBegin => switch (c) {
        '{' => {
          p.stack <<=  1; //
          p.stack |= object_bit;
          p.stack_used += 1;
          
          p.state = .ValueBegin;
          p.after_string_state = .ObjectSeparator;
          
          token.* = Token.ObjectBegin;
        },
        else => {
          return error.InvalidTopLevel;
        }
      },
      .ValueBegin => switch (c) {
        // Note: Theses are shared in ValueEnd as well, think we can reorder states to
        // be a bit clearer and avoid this duplication.
        '}' => {
          // unlikely
          if (p.stack & 1 != object_bit) {
            return error.UnexpectedClosingBracket;
          }
          if (p.stack_used == 0) {
            return error.TooManyClosingItems;
          }

          p.state = .ValueBegin;
          p.after_string_state = State.fromInt(p.stack & 1);
          p.stack >>= 1;
          p.stack_used -= 1;

          switch (p.stack_used) {
            0 => {
              p.complete = true;
              p.state = .TopLevelEnd;
            },
            else => {
              p.state = .ValueEnd;
            },
          }

          token.* = Token.ObjectEnd;
        },
        '"' => {
          p.state = .String;
          p.string_escapes = .None;
          p.string_last_was_high_surrogate = false;
          p.count = 0; //开始计算字符串
        },
        '1' ... '9' => {
          p.number_is_interger = true;
          p.state = .NumberMaybeDigitOrDotOrExponent;
          p.count = 0;
        },
        else => {
          return error.InvalidTopLevel;
        }
      },
      .ValueEnd => switch (c) {
        '}' => {
          if (p.stack_used == 0) {
            return error.UnbalancedBraces;
          }

          p.state = .ValueEnd;
          p.after_string_state = State.fromInt(p.stack & 1);

          p.stack >>= 1;
          p.stack_used -= 1;

          if (p.stack_used == 0) {
            p.complete = true;
            p.state = .TopLevelEnd;
          }

          token.* = Token.ObjectEnd;
        },
        else => {
          return error.InvalidValueEnd;
        }
      },
      .NumberMaybeDigitOrDotOrExponent => {
        p.complete = p.after_value_state == .TopLevelEnd;

        switch (c) {
          '0' ... '9' => {

          },
          else => {
            p.state = p.after_value_state;
            token.* = .{
              .Number = .{
                .count = p.count,
                .is_integer = p.number_is_interger,
              }
            };

            return true;
          }
        }
      },
      .ObjectSeparator => switch (c) {
        ':' => {
          p.state = .ValueBegin;
          p.after_string_state = .ValueEnd;
        },
        0x09, 0x0A, 0x0D, 0x20 => {
          // whitespace
        },
        else => {
          return error.InvalidSeparator;
        },
      },
      .String => switch (c) {
        0x00 ... 0x1F => {
          return error.InvalidControlCharacter;
        },
        '"' => { // end string
          p.state = p.after_string_state;
          if (p.after_value_state == .TopLevelEnd) {
            p.state = .TopLevelEnd;
            p.complete = true;
          }

          token.* = .{
            .String = .{
              .count = p.count - 1,
              .escapes = p.string_escapes,
            },
          };

          p.string_escapes = undefined;
          p.string_last_was_high_surrogate = undefined;
        },
        0x20, 0x21, 0x23 ... 0x5B, 0x5D ... 0x7F => {
          // non-control ascii
          p.string_last_was_high_surrogate = false;
        },
        else => {
          return error.InvalidUtf8Byte;
        }
      },
      else => {
        return error.InvalidTopLevel;
      }
    }

    return false;
  }
};

/// A small wrapper over a StreamingParser for full slices.
/// Returns a stream of json Tokens
pub const TokenStream = struct {
  i: usize, // 
  slice: []const u8, // 解析字符串
  parser: StreamingParser, //解析器
  token: ?Token, // 当前的token

  pub const Error = StreamingParser.Error || error{UnexpectedEndOfJson};

  pub fn init(slice: []const u8) TokenStream {
    return TokenStream{
      .i = 0,
      .slice = slice,
      .parser = StreamingParser.init(),
      .token = null,
    };
  }

  pub fn next(self: *TokenStream) Error!?Token {
    if (self.token) |token| {
      const copy = token;
      self.token = null;
      return copy;
    }

    var t1: ?Token = undefined;
    var t2: ?Token = undefined;

    // 循环提供字符给feed函数，直到有token返回回来
    while (self.i < self.slice.len) {
      try self.parser.feed(self.slice[self.i], &t1, &t2);
      self.i += 1;

      if (t1) |token| {
        self.token = t2;
        return token;
      }
    }

    // without this a bare number fails,
    // the streaming parser doesn't know the input ended
    try self.parser.feed(' ', &t1, &t2);
    self.i += 1;

    if (t1) |token| {
      return token;
    } else if (self.parser.complete) {
      return null;
    } else {
      return error.UnexpectedEndOfJson;
    }
  }
};