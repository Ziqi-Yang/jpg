# Just a Project Generator

**Alpha State**

A project generator using [just](https://github.com/casey/just)

To use this tool, you may need the knowledge of
[just](https://github.com/casey/just) and shell script (However, `just`
let you run script using many other languages).

## Features

1.  fully customizable

2.  ridiculously simple

3.  shell completion support

4.  use languages and tools you like

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

You can see the full list of JPG variables using command `jpg config`. A
list of customizable variables can be viewed using command
`jpg config 1`. You can customize it in a file called `config` (if you
use example configuration) at your JPG user configuration directory.
This file follows the style of `.env` file. Here is an example:

    JPG_V_USER_NAME="Meow King"

## Create your project templates

Create your template inside `JPG_TEMPLATES_DIR` directory(by default,
it's the `template` directory under your JPG user configuration
directory).

Also take a look at the example `script.just` file at your JPG user
configuration directory. You can utilize builtin functions defined
defined in [lib.just](./lib.just) file.

## Utility Tools

-   [fd](https://github.com/sharkdp/fd)

-   [sd](https://github.com/chmln/sd)

-   [ripgrep](https://github.com/BurntSushi/ripgrep)

## FAQ

### How can I create template and share it with others?

1.  Upload your template to an online open source project hosting
    service.

2.  Share your corresponding `just` recipe.\
    Example recipe:

    ``` just
    python name: && (jpg-replace-builtin name)
         git clone https://github.com/Ziqi-Yang/jpg.git name
     
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
