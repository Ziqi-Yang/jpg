= Just a Project Generator

A project generator using #link("https://github.com/casey/just?tab=readme-ov-file#just-scripts")[just]

== Installation

== FAQ

=== Why JPG uses `::variable_name::` as its builtin template style, instead of something like `{{variable_name}}`?

First pls note that you can change the builtin template style by setting variables `JPG_TEMP_BEGIN_SYM` and `JPG_TEMP_END_SYM`.

==== Why not `{{variable_name}}`

+ collision with `just`'s templating style (i.e. `{{just_variable}}`). Also, currently `just` (1.25.2) will also interpret all `{{`
characters as variable start. So if JPG uses `{{variable_name}}` style, then we needs to write stuffs like `{{{{variable_name}}}}`.
    
+ `jpg-replace-builtin` function uses `fd -x` (or `fd --exec`), and `fd -x` will interpret `{{` as `{` (it's its own style of escaping `{` character).
If JPG uses `{{variable_name}}` style, then combining with the first caveat, we need to write stuffs like `{{{{{{{{variable_name}}}}`

+ Avoid collision with popular template languages like `jinja`.

==== Why not `[[variable_name]]`

`jpg-replace-builtin` uses `sed` (and you may also want to use it), and `sed` can only handle regexp replacement, such that we need to escape `[`.

==== Example Script File explaining the choose of different templating styles

For template:
```
Python 3.11.8
{{PYTHON_VERSION}}
{{PYTHON_VERSION}}
```

We write this script:

```just
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
