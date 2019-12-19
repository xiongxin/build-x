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
