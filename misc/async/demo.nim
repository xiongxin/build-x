


type
    IfStmt = ref object
        condition: bool
        thenBranch: string
        elseBranch: string

let i1 = IfStmt(condition: false, thenBranch: "then", elseBranch: "else")

if i1.condition:
    echo i1.thenBranch
elif i1.thenBranch != "":
        echo i1.elseBranch
echo "some"


type
    My = ref object

proc `[]`(this: My, key: string, i: int): string =
    result = key & $i

var my = new My
echo my["a", 1]