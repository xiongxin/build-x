import sequtils, tables, strutils, strformat, random, os, parseopt

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

type
  Board = ref object of RootObj
    list: seq[string]
  Game = ref object of RootObj
    currentPlayer*: string
    board*: Board
    aiPlayer: string
    difficulty*: int
  Move = tuple[score: int, idx: int]


proc newBoard(): Board =
  result = Board()
  result.list = @["0", "1", "2", "3", "4", "5", "6", "7", "8"]
  return result

proc newGame(aiPlayer: string, difficulty: int = 9): Game =
  result = new Game

  result.board = newBoard()
  result.currentPlayer = "X"
  result.aiPlayer = aiPlayer
  result.difficulty = difficulty

proc changePlayer(this: Game) =
  this.currentPlayer = NEXT_PLAYER[this.currentPlayer]

proc done(this: Board): (bool, string) =
  for w in WINS:
    if this.list[w[0]] == this.list[w[1]] and this.list[w[1]] == this.list[w[2]]:
      if this.list[w[0]] == "X":
        return (true, "X")
      elif this.list[w[0]] == "O":
        return (true, "O")
  
  if all(this.list, proc(x: string):bool = x in @["O", "X"]) == true:
    return (true, "tie")
  else:
    return (false, "going")

proc `$`(this: Board): string =
  let rows: seq[seq[string]] = @[this.list[0..2], this.list[3..5], this.list[6..8]]
  for row in rows:
    for cell in row:
      stdout.write(cell & " | ")
    echo("\n--------------")

proc emptySpots(this: Board): seq[int] =
  var emptyindices = newSeq[int]()
  for i in this.list:
    if i.isDigit():
      emptyindices.add(parseInt(i))
  
  result = emptyindices


proc getBestMove(this: Game, board: Board, player: string) : Move 

proc startGame*(this: Game) =
  while true:
    echo this.board
    if this.aiPlayer != this.currentPlayer:
      stdout.write("Enter move:")
      let move = stdin.readLine()
      this.board.list[parseInt($move)] = this.currentPlayer
    else:
      if this.currentPlayer == this.aiPlayer:
        let emptySpots = this.board.emptySpots()
        if len(emptySpots) <= this.difficulty:
          echo("AI MOVE..")
          let move = this.getBestMove(this.board, this.aiPlayer)
          this.board.list[move.idx] = this.aiPlayer
        else:
          echo("RANDOM GUESS")
          this.board.list[emptySpots.rand()] = this.aiPlayer
    this.changePlayer()
    let (done, winner) = this.board.done()
    if done:
      echo this.board
      if winner == "tie":
        echo("TIE")
      else:
        echo "WINNER IS : ", winner
      break

proc getBestMove(this: Game, board: Board, player: string) : Move =
  let (done, winner) = board.done()
  if done == true:
    if winner == this.aiPlayer:
      return (score: 10, idx: 0)
    elif winner != "tie": #human
      return (score: -10, idx: 0)
    else:
      return (score: 0, idx: 0)
  
  let emptySpots = board.emptySpots()
  var moves = newSeq[Move]()
  for idx in emptySpots:
    var newboard = newBoard()
    newboard.list = map(board.list, proc(x: string): string = x)
    newboard.list[idx] = player
    let score = this.getBestMove(newboard, NEXT_PLAYER[player]).score
    let idx = idx
    let move = (score: score, idx: idx)
    moves.add(move)

  if player == this.aiPlayer:
    return max(moves)
  else:
    return min(moves)

when isMainModule:
  var borad = newBoard()
  echo $borad
  var es = borad.emptySpots()
  echo es
  var game = newGame("O")
  game.startGame()