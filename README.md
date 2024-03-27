# Just a Project Generator

**Alpha State**

A project generator using [just](https://github.com/casey/just)

To use this tool, you may need the knowledge of
[just](https://github.com/casey/just) and shell script (However, `just`
let you run script using many other languages).

## Features

1.  fully customizable

2.  simple and there is no extra grammar you need to learn (if you use
    `just` and write shell script)

3.  shell completion support

4.  use languages and tools you know and you like (e.g.
    [cargo-generate](https://github.com/cargo-generate/cargo-generate)
    for rust project)

## Limitations

1.  Runtime variables (like current filename, current parent directory
    name) are not shareable. You need to regain and process the variable
    values though command `fd -t f -x sh -c "echo '{}'"` or something
    else. However, if you do want to do this stuff, remember the
    replacement of text has order, so you can write functions like
    `::foo(::jpg.author.name::)::`. However, it's quite limited.

2.  Don't support control flow and functions in templates. You are
    encouraged to process variables in your justfile. If you want to
    have those advanced stuffs, it's recommended to use other tools like
    [jinja2-cli](https://github.com/mattrobenolt/jinja2-cli) to
    pre-process template first in your justfile recipe. In this case,
    you can think JPG is just a command runner.

## Installation

``` bash
git clone https://github.com/Ziqi-Yang/jpg
cd jpg
sudo just install
just create-example-user-configuration
```

You can execute command `sudo just uninstall` to fully uninstall JPG.

## Quick Run

After running `just create-example-user-configuration` at the
*Installation* step, you have example configuration at the `jpg` folder
at the user-specific configuration directory (for Linux, normally it's
`~/.config`). Take a look at the files inside it and run the following
command to see the effect.

``` bash
cd /tmp
# using python template (example template) to create a project named `test`
jpg python test
```

## Override Options

You can see the full list of JPG variables using command
`jpg config -a`. Other options for `jpg config` can be viewed by command
`jpg` or `jpg help`

You can customize it in a file called `config` (if you use example
configuration) at your JPG user configuration directory. This file
follows the style of `.env` file. Here is an example:

    JPG_V_USER_NAME="Meow King"

## Create your project templates

Create your template inside `JPG_TEMPLATES_DIR` directory(by default,
it's the `template` directory under your JPG user configuration
directory).

Also take a look at the example `script.just` file at your JPG user
configuration directory. You can utilize builtin functions defined
defined in [lib.just](./lib.just) file.

## Utility Tools

-   [fd](https://github.com/sharkdp/fd): A simple, fast and
    user-friendly alternative to 'find'.

-   [sd](https://github.com/chmln/sd): Intuitive find & replace CLI (sed
    alternative).

-   [ripgrep](https://github.com/BurntSushi/ripgrep): ripgrep
    recursively searches directories for a regex pattern while
    respecting your gitignore.

-   [jinja2-cli](https://github.com/mattrobenolt/jinja2-cli): CLI for
    Jinja2.

-   [fzf](https://github.com/junegunn/fzf): 🌸 A command-line fuzzy
    finder.

### Easy to use TUI libraries

If you write your justfile recipe in languages like `python`, `golang`,
etc. You may want to use these TUI libraries:

1.  [rich](https://github.com/Textualize/rich) `python`

2.  [bubbletea](https://github.com/charmbracelet/bubbletea) `golang`

## FAQ

### How can share my template with others?

1.  Upload your template to an online open source project hosting
    service. (it's better to name it using `jpg-` prefix).

2.  Share your corresponding justfile recipe.\
    Example recipe:

    ``` just
    python name: && (jpg-replace-builtin name)
         git clone https://github.com/Ziqi-Yang/jpg.git name
     
    ```

    Or you can share your justfile (only with the related parts). Others
    can import it.

### I don't want to store my secret in `~/.config/jpg/config` file. Where should I store my secret?

Suppose you have make a git repo for synchronize your templates. Since
`config` file is also used to change the values of JPG variables, it's
not recommended to store your secrets. There are possibly two
approaches:

1.  create another justfile to store your secrets into variables, import
    the justfile in your `script.just` and put the filename into your
    `.gitignore`.

2.  Store it in another environment file. In your related justfile
    recipes, write this:\

    ``` just
    a:
         #!/usr/bin/env sh
         source <path>/.env
       
    ```

### Why JPG uses `::variable_name::` as its builtin template style, instead of something like `{{variable_name}}`?

First pls note that you can change the builtin template style by setting
variables `JPG_TEMP_BEGIN_SYM` and `JPG_TEMP_END_SYM`.

#### Why not `{{variable_name}}`

1.  collision with `just`'s templating style (i.e. `{{just_variable}}`).
    Also, currently `just` (1.25.2) will also interpret all `{{`

characters as variable start. So if JPG uses `{{variable_name}}` style,
then we needs to write stuffs like `{{{{variable_name}}}}`.

1.  `jpg-replace-builtin` function uses `fd -x` (or `fd --exec`), and
    `fd -x` will interpret `{{` as `{` (it's its own style of escaping
    `{` character).

If JPG uses `{{variable_name}}` style, then combining with the first
caveat, we need to write stuffs like `{{{{{{{{variable_name}}}}`

1.  Avoid collision with popular template languages like `jinja`.

#### Why not `[[variable_name]]`

`jpg-replace-builtin` uses `sed` (and you may also want to use it), and
`sed` can only handle regexp replacement, such that we need to escape
`[`.

#### Example Script File explaining the choose of different templating styles

For template:

    Python 3.11.8
    {{PYTHON_VERSION}}
    {{PYTHON_VERSION}}

We write this script:

``` just
V_PYTHON_VERSION := "{{{{PYTHON_VERSION}}}}"
# create a python project (example)
python1 name: (jpg-copy-template name "python") && (jpg-replace-builtin name)
    #!/usr/bin/env sh
    # use 'set -eux' to print the steps
    set -eu
    
    PYTHON_VERSION=$(python3 --version)
    
    # 1. 'just' will replace variables inside double brackets. And it will
    # also replace any 2x'{' in script to '{' (but not '}}'). use '{{{{' to escape.
    # example: see `V_PYTHON_VERSION` variable
    
    # 2. then fd will replace things like '{}' (see '--exec' help), and treat
    #   2x'{' as '{', 2x'}' as '}' (escape).

    # 3. since we are in sh shell script, variables with syntax like ${} will be
    #   replaced with the variables we defined previous in this justfile block
    
    # 4. to use variables inside the inner sh block, we need to escape
    # dollar character like '\${HOME}'. Note only variables in double quote will
    # be interpreted by sh.
    
    fd -t f -x sh -c "
      sed -i \
        -e \"s&Python 3.11.8&${PYTHON_VERSION}&g\" \
        -e \"s&{{V_PYTHON_VERSION}}&${PYTHON_VERSION}&g\" \
        -e \"s&{{{{{{{{PYTHON_VERSION}}}}&${PYTHON_VERSION}&g\" \
        '{}'
    "
```
