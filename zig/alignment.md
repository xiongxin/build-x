# Pointer

## Alignment
Each type has an alignment - a number of bytes such that.
when a value of the type is loaded from or stored to memory,
the memory address must be evenly divisible by this number.

# Struct

## Struct Naming
- If the struct is in the initialization expression of a variable, it gets named after that variable.
- If the struct is in the return expression, it gets named after the function it is returning from,
with the parameter values serialized.
- Otherwise, the struct gets a name such as (anonymous struct at file.zig:7:38)

# Enum

# Blocks

Blocks are used to limit the scope of variable declarations:
```
{
  var x: i32 = 1;
}
x += 1;
```

Blocks are expressions. When labeled, break can be used to return a value from the block.



# Switch
# If

If expressions have three uses, corresponding to the three types:
- bool
- ?T
- anyerror!T

If expressions are used instead of a ternary expression.

# defer

Defer will execute an expression at the end of the current scope.

If multiple defer statements are specified, they will be excuted in
the reverse order they were run.

## errdefer

The errdefer keyword is similar to defer, but will only execute if the
scope returns with an error.

This is especially useful in allowing a function to clean up properly
on error, and replaces goto error handling tactics as seen in c.

# unreachable
In Debug and ReleaseSafe mode, and when using zig test, `unreachable` emits
a call to painc with the message reached unreachable code.

In ReleaseFast mode, the optimizer uses the assumption that `unreachable`
code will never be hit to perform optimizations, `zig test` even in ReleaseFast
mode still emits `unreachable` as calls to panic.

## Basics
unreachable is used to assert that control flow will never happen upon particular
location:

## noreturn

noreturn is the type of:
- break
- continue
- return
- unreachable
- while(true) {}

when resolving types gogether, such as if clauses or switch prongs, the noreturn type
is compatible with every other type. Consider:

```
fn foo(condition: bool, b: u32) void {
    const a = if (condition) b else return;
    @panic("do something with a");
}
test "noreturn" {
    foo(false, 1);
}
```

Another use case for noreturn is the exit functions:


# Functions
The `export` specifier makes a function externally visible in the generated object file,
and make it use the C ABI.
`export fn sub(a: i8, b: i8) i8 { return a - b; }`

The `extern` specifier is used to declare a function that will be resolve at link time,
when linking statically, or at runtime, when link dynamically.

The stdcallcc specifier changes the calling convention of the function.
```
extern "kernel32" stdcallcc fn ExitProcess(exit_code: u32) noreturn;
extern "c" fn atan2(a: f64, b: f64) f64;
```

Functions can be used as values and are equivalent to pointers. Function values are like
pointers.

## Pass-by-value Parameters
Primitive types such as Integers and Floats passed as parameters are copied, and then the
copy is available in the function body. This is called "passing by value". Copying a primitive
type is essentially free and typically involves nothing more than setting a register.

Structs, unions, and arrays can sometimes be more efficiently passed as a reference, since
a copy could be arbitrarily expensive depending on the size. When these types are passed as
parameters, Zig may choose to copy and pass by the value, or pass by reference, whichever way
Zig decides will be faster. This is made possible, in part, by the fact that parameters are
immutable.

## Function Parameter Type Inference
Function parameters can be declared with var in place of the type. In this case the parameter
types will be inferred when the function is called. Use `@TypeOf` and `@typeInfo` to get 
information about the inferred type.

## Function Reflection

`@TypeOf()`, `@typeId`, `@typeInfo`

# Errors

## Error Set Type
An error set is like an enum. However, each error name across the entire compilation gets assigned
an unsigned integer greater than 0. You are allowed to declare the same error name more than once,
and if you do, it gets assigned the same integer value.

You can coerce an error from a subset to a superset:


### The Global Error Set

##  Error Union Type
An error set type and normal type can be combined with the ! binary operator to form an error union
type. You are likely to use an error union type more often than an error set type by itself:

### catch
if you want to provide a default value, you can use the catch binary operator:

```
fn doAThing(str: []u8) void {
    const number = parseU64(str, 10) catch 13;
    // ...
}
```
The

https://github.com/ac-pm/Inspeckage