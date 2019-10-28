import sequtils, tables, strutils, strformat, random, os, parseopt

type
  Board = ref object of RootObj
    list: seq[string]

proc newBoard(): Board =
  result.list = @["0", "1", "2", "3", "4", "5", "6", "7", "8"]



# 下一步玩家放置
let NEXT_PLAYER = { "X" : "O", "O" : "X" }.toTable
# 列举所有赢的情况
let WINS = @[ 
  @[0,1,2], 
  @[3,4,5], 
  @[6,7,8], 
  @[0,3,6], 
  @[1,4,7], 
  @[2,5,8], 
  @[0,4,8], 
  @[2,4,6] 
]

randomize()

