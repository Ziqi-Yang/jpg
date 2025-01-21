= Just a Project Generator

A simple and powerful project generator using #link("https://github.com/casey/just")[just]

To use this tool, you may need the knowledge of #link("https://github.com/casey/just")[just]
and shell script (However, `just` let you run script using many other languages).

Basically, `jpg` provides you with useful `just` recipes, which can be used in
your own command to generate projects.

== Features

+ fully customizable
+ simple and there is no extra rules you need to learn
+ use languages and tools you know and you like (e.g. #link("https://github.com/cargo-generate/cargo-generate")[cargo-generate] for rust project)


== Installation

we install `jpg` at #link("https://github.com/casey/just?tab=readme-ov-file#global-and-user-justfiles")[global `just` directory].

```sh
mkdir -p ~/.config/just
cd ~/.config/just
git clone https://codeberg.org/meow_king/jpg.git jpg
```

Create and edit `~/.config/just/justfile`. Example file:

```justfile
set allow-duplicate-variables

import "./jpg/mod.just"
import "~/.config/jpg/mod.just"

default:
  just -g --list
```

Create your user files and template files at `~/.config/jpg/`.

You can take https://codeberg.org/meow_king/my-jpg-templates as reference.

== Usage

```
just -g <command>
```

you can use `just -g --list` to show list of available commands.

=== Override jpg variables

For example, if you want to override `JPG_V_USER_NAME`, you can add this to your
`~/.config/just/justfile`.

```just
JPG_V_USER_NAME := "Name"
```

=== Define your own template

Be sure to read all libraries files of `jpg` to know the recipes you can use
and what dependencies they need.

For example:

```just
[doc("create new Emacs project")]
new-emacs name: (exit-if-exists name) (jpg-copy-template name "emacs") (jpg-git-jj-init name)
  #!/usr/bin/env sh
  set -eu
  cd '{{name}}'
  mv -n ./xxx.el '{{name}}.el'
  
  read -p "description: " description
  export description
  
  just -g jpg-render-jinja2 .
  
  wget https://raw.githubusercontent.com/alphapapa/makem.sh/master/makem.sh
  chmod +x ./makem.sh
```




