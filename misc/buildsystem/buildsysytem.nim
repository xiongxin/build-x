import strformat, strutils, tables, sequtils, algorithm

type
  Task = object
    requires*: seq[string] # 任务依赖
    actions*: string # 任务动作
    name*: string  # 任务名称
  Bake = ref object
    tasksgraph* : Table[string, seq[string]] # 任务名称和他的依赖
    tasks* : Table[string, Task] # 任务名称和任务对象
  NodeColor = enum
    ncWhite, ncGray, ncBlack

proc initBake(): Bake =
  result = new Bake

proc `$`(this: Task): string =
  result = fmt("Task {this.name} Requirements: {this.requires}, actions {this.actions}")

proc addTask*(this: Bake, taskname: string, deps: seq[string], actions: string) =
  var t = Task(name: taskname, requires: deps, actions: actions)
  this.tasksgraph[taskname] = deps
  this.tasks[taskname] = t

proc runTaskHelper(this: Bake, taskname: string, deps: var seq[string], seen: var seq[string])

# Before running a task we should check if it has a cycle first.
# Keep track of dependencies and the seen tasks so far
# so we don't run seen tasks again. 
# for instance if we have target install-wget and target install-curl
# and both require target apt-get update, so we want to run apt-get update
# only once
proc runTask*(this: Bake, taskname: string) =
  var deps = newSeq[string]()
  var seen = newSeq[string]()

  this.runTaskHelper(taskname, deps, seen)
  echo deps
  for tsk in deps:
    let t = this.tasks.getOrDefault(tsk)
    echo(t.actions)

proc runTaskHelper(this: Bake, taskname: string, deps: var seq[string], seen: var seq[string]) =
  if taskname in seen:
    echo "[+] Solved ",taskname," before no need to repeat action"
  var tsk = this.tasks.getOrDefault(taskname)

  seen.add(taskname)
  if len(tsk.requires) > 0:
    for c in this.tasksgraph[tsk.name]:
      this.runTaskHelper(c, deps, seen)
  deps.add(taskname)


# WHITE: Vertex is not processed yet. Initially all vertices are WHITE
# GRAY: Vertex is being processed (DFS for this vertex has started, but not finished
# which means that all descendants (ind DFS tree) of this vertex are not prcessed yet
# or this vertex is in function call stack)
# BLACK: Vertex and all its descendants are prcessed.
# While doing DFS, if we encounter an dege from current vertex to a GRAY vertex, 
# then this edge is back edge and hence there is a cycle
###

proc hasCycleDFS(graph: Table[string, seq[string]],
  node: string,
  colors: var Table[string, NodeColor],
  hasCycle: var bool,
  parentMap: var Table[string, string]) =
  
  if hasCycle:
    return
  colors[node] = ncGray # 当前处理中的依赖

  for dep in graph[node]:
    parentMap[dep] = node
    if colors[dep] == ncGray:
      hasCycle = true
      parentMap["__CYCLESTART__"] = dep
    if colors[dep] == ncWhite:
      hasCycleDFS(graph, dep, colors, hasCycle, parentMap)
  colors[node] = ncBlack

proc graphHashCycle(graph: Table[string, seq[string]]) : (bool, Table[string, string]) =
  var colors = initTable[string, NodeColor]()
  for node, deps in graph:
    colors[node] = ncWhite # 所有的任务都是WHITE
  var parentMap = initTable[string, string]()
  var hashCycle = false
  for node, deps in graph:
    parentMap[node] = "null"
    if colors[node] == ncWhite:
      hasCycleDFS(graph, node, colors, hashCycle, parentMap)
    if hashCycle:
      return (true, parentMap)
  return (false, parentMap) 

when isMainModule:

  var b = initBake()
  b.add_task("publish", @["build-release"], "print publish")
  b.add_task("build-release", @["curl-installed", "nim-installed"], "print exec command to build release mode")
  b.add_task("nim-installed", @["curl-installed"], "print curl LINK | bash")
  b.add_task("curl-installed", @["apt-installed"], "apt-get install curl")
  b.add_task("apt-installed", @["nim-installed"], "code to install apt...")
  let cycle, parentMap = graphHashCycle(b.tasksgraph)
  echo cycle
  #if cycle != true:
  #b.run_task("publish")