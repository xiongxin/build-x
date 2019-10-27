## template syntax

- `untyped` means the expression doesn't have to have a type yet,
imageine passing variable name that doesn't exist yet `defineVar(myVar, 5)`
so here `myVar` needs to be untyped or the complier will complain.
- `astToStr` converts the AST `exp` to a string
- `indent` amount of spaces prefixing the message

## macros

Nim provides us with a way to access the AST in a very low level
when we templates don't cut it

