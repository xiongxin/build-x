namespace Hack\GettingStarted\First;

<<__EntryPoint>>
function main(): noreturn
{
    echo "string";

    \printf("Table of Squares\n" .
            "-------------------\n");
    for ($i=-5; $i < 5; ++$i) { 
        \printf("%2d %2d \n", $i, $i * $i);
    }

    \printf("----------------\n");
    exit(0);
}