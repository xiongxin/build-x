import strformat, strutils, macros


template check*(exp:untyped, failureMsg:string="failed", indent:uint=0): void =
  let indentationStr = repeat(' ', indent) 
  let expStr: string = astToStr(exp)
  var msg: string
  if not exp:
    if msg.len() == 0:
      msg = indentationStr & expStr & " .. " & failureMsg
  else:
    msg = indentationStr & expStr & " .. passed"
      
  echo(msg)


macro suite*(name: string, exprs: untyped): void =
  result = newStmtList()
  let equline = newCall("repeat", newStrLitNode("="), newIntLitNode(50))
  let writeEquline = newCall("echo", equline)
  add(result, writeEquline, newCall("echo", name))
  add(result, writeEquline)

  for i in 0 .. pred(exprs.len):
    var exp = exprs[i]
    let expKind = exp.kind
    case expKind:
    of nnkCall:
      case exp[0].kind
      of nnkIdent:
        let identName = $exp[0]
        if identName == "check":
          exp.add(newStrLitNode(""))
          exp.add(newIntLitNode(1))
          add(result, exp)
      else:
        add(result, exp)
    else:
      discard

when isMainModule:
  check(3==1+2)
  check(6+5*2 == 17, "相等测试")
  suite "abc":
    check(3 == 1 + 2)
    check(3 == 1 + 3)
  dumpTree:
    suite "abc":
      check(3 == 1 + 2)