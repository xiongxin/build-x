import strformat, strutils, tables, sequtils, algorithm

type
  Task = object
    requires*: seq[string]
    actions*: string
    name*: string
  Bake = ref object
    tasksgraph* : Table[string, seq[string]]
    tasks* : Table[string, Task]

proc `$`(this: Task): string =
  result = fmt("Task {this.name} Requirements: {this.requires}, actions {this.actions}")

proc addTask*(this: Bake, taskname: string, deps: seq[string], actions: string) =
  var t = Task(name: taskname, requires: deps, actions: actions)
  this.tasksgraph[taskname] = deps
  this.tasks[taskname] = t

proc runTaskHelper(this: Bake, taskname: string, deps: var seq[string], seen: var seq[string]) =
  if taskname in seen:
    echo "[+] Solved {taskname} before no need to repeat action"
  var tsk = this.tasks.getOrDefault(taskname)

  seen.add(taskname)
  if len(tsk.requires) > 0:
    for c in this.tasksgraph[tsk.name]:
      this.runTaskHelper(c, deps, seen)
  deps.add(taskname)

proc runTask*(this: Bake, taskname: string) =
  var deps = newSeq[string]()
  var seen = newSeq[string]()

  this.runTaskHelper(taskname, deps, seen)

  for tsk in deps:
    let t = this.tasks.getOrDefault(tsk)
    echo(t.actions)