# 一些记录吧

Name	C Equivalent	Description
i8	int8_t	signed 8-bit integer
u8	uint8_t	unsigned 8-bit integer
i16	int16_t	signed 16-bit integer
u16	uint16_t	unsigned 16-bit integer
i32	int32_t	signed 32-bit integer
u32	uint32_t	unsigned 32-bit integer
i64	int64_t	signed 64-bit integer
u64	uint64_t	unsigned 64-bit integer
i128	__int128	signed 128-bit integer
u128	unsigned __int128	unsigned 128-bit integer
isize	intptr_t	signed pointer sized integer
usize	uintptr_t	unsigned pointer sized integer
c_short	short	for ABI compatibility with C
c_ushort	unsigned short	for ABI compatibility with C
c_int	int	for ABI compatibility with C
c_uint	unsigned int	for ABI compatibility with C
c_long	long	for ABI compatibility with C
c_ulong	unsigned long	for ABI compatibility with C
c_longlong	long long	for ABI compatibility with C
c_ulonglong	unsigned long long	for ABI compatibility with C
c_longdouble	long double	for ABI compatibility with C
c_void	void	for ABI compatibility with C
f16	_Float16	16-bit floating point (10-bit mantissa) IEEE-754-2008 binary16
f32	float	32-bit floating point (23-bit mantissa) IEEE-754-2008 binary32
f64	double	64-bit floating point (52-bit mantissa) IEEE-754-2008 binary64
f128	_Float128	128-bit floating point (112-bit mantissa) IEEE-754-2008 binary128
bool	bool	true or false
void	(none)	0 bit type
noreturn	(none)	the type of break, continue, return, unreachable, and while (true) {}
type	(none)	the type of types
anyerror	(none)	an error code
comptime_int	(none)	Only allowed for comptime-known values. The type of integer literals.
comptime_float	(none)	Only allowed for comptime-known values. The type of float literals.


## String字面量和Character字面量

字符串字面亮是一个指针指向一个无终止符的UTF-8编码的字节数组。字符串字面量编码长度和无终止符，他们可以`coerced`为
`Slice`和`Null-Terinated Pointer`.字面量的解引用转换成数组.

字符字面是`comptime_int`,和字符串字面量相似，所有的`Escape Sequences`在字符串字面和字符字面量都是有效的.

`type:*const [13:0]u8` 虽然是非终止符的，但是有个哨兵`0`终止.

## 变量

变量时一个内存存储单元

变量禁止和外部作用域同名

尽量使用`const`变量

### 全局变量

全局变量可以考虑在顶部声明，它们时顺序独立，并且时延迟分析的。全局变量是隐式`comptime`。如果一个全局变量`const`声明，那么他的值必须时`comptime-known`，否则就是`runtime-konow`。


全局变量可以声明在`struct`,`union`,`enum`中：

```zig
const std = @import("std");
const assert = std.debug.assert;

test "namespaced global variable" {
    assert(foo() == 1235);
    assert(foo() == 1236);
}

fn foo() i32 {
    const S = struct {
        var x: i32 = 1234;
    };
    S.x += 1;
    return S.x;
}
```

运行结果：

```
$ zig test namespaced_global.zig
1/1 test "namespaced global variable"...OK
All 1 tests passed.
```

The extern keyword can be used to link against a variable that is exported from another object. The export keyword or @export builtin function can be used to make a variable available to other objects at link time. In both cases, the type of the variable must be C ABI compatible.

### 线程本地变量

一个变量可以指定为 thread-local 变量使用｀threadlocal`关键字：

### 本地变量

本地变量存在`Functions`,`comptime`代码块和`@cImport`代码块中。

```zig
const std = @import("std");
const assert = std.debug.assert;

test "comptime vars" {
  var x: i32 = 1;
  comptime var y: i32 = 1;

  x += 1;
  y += 1;

  assert(x == 2);
  assert(y == 2);

  if (y != 2) {
    // 这个编译错误不会触发，因为y时一个编译时变量
    // 所以 y != 2也是一个编译时的值， 在语法分析的时候就会作为程序静态执行
    @compileError("wrong y value");
  }
}
```

运行结果：

```
$ zig test comptime_vars.zig
1/1 test "comptime vars"...OK
All 1 tests passed.
```

## 操作符

`Peer Type Resolution`：对等类型解析，使用二元运算符时，zig会使用对等类型解析，把两个操作类型调整成都能cast的类型。

操作可选类型
- `a orelse b`
- `a.?` = `a orelse unreachable`
- `a == null`

操作Error Unions类型
- `a catch b`        如果a时`error`则返回b
- `a catch |err| b`  err仅在b的作用域中有效
- `a || b` 错误合并

数组操作符
- `a ++ b` a和b必须都是编译时可知
- `a ** b` 重复a数组b次

指针
- `a.*` 指针解引用
- `&a`  获取指针地址

## 数组

### 匿名数组字面量

和`Enum字面量`和`匿名结构体字面量`相似,可以在使用字面量时忽略类型参数。

如果在返回的位置没有类型标示匿名数组参数，将会转成`struct`通过数字字段名称访问。

### 哨兵终止数组

语法 `[N:x]T` 描述了一个数组有一个哨兵值x在数组索引的长度位置上面。

