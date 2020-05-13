# A CLI program

cli 程序参数解析

```
./program_name [arguments] [flags] [options]
```

使用clap示例

```
name: myapp
version: "1.0"
author: Kevin K. <kbknapp@gmail.com>
about: Does awesome things
args:
    - config:
        short: c
        long: config
        value_name: FILE
        help: Sets a custom config file
        takes_value: true
    - INPUT:
        help: Sets the input file to use
        required: true
        index: 1
    - verbose:
        short: v
        multiple: true
        help: Sets the level of verbosity
subcommands:
    - test:
        about: controls testing features
        version: "1.3"
        author: Someone E. <someone_else@other.com>
        args:
            - debug:
                short: d
                help: print debug information
```

该程序支持的参数
config , INPUT(索引位置是1), verbose
程序解析结果
```
myapp 1.0
Kevin K. <kbknapp@gmail.com>
Does awesome things

USAGE:
    meow [OPTIONS] <INPUT> [SUBCOMMAND]

ARGS:
    <INPUT>    Sets the input file to use

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

OPTIONS:
    -c, --config <FILE>    Sets a custom config file
    -v <verbose>...        Sets the level of verbosity

SUBCOMMANDS:
    help    Prints this message or the help of the given subcommand(s)
    test    controls testing features
```