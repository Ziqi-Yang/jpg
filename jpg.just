#!/usr/bin/env -S just --working-directory . --dotenv-path ${HOME}/.jpg.config --justfile
#TODO MacOS shebang test: https://github.com/casey/just?tab=readme-ov-file#just-scripts

set allow-duplicate-recipes
set dotenv-load
# see https://github.com/casey/just/issues/1976
# currently using shebang hack (${HOME})
# set dotenv-path "~/.jpg.config"

import 'lib.just'

JPG_CONFIG_DIR := join(config_directory(), "jpg") # TODO temporary no use
JPG_TEMPLATES_DIR := env("JPG_TEMPLATES_DIR", join(JPG_CONFIG_DIR, "template"))

# Currently we could only use this indirect way to import user defined justfiles
# https://github.com/casey/just/issues/1975
import? "~/.jpg.root.just"

@_:
    {{justfile()}} -l

# Display configuration information
@config: && lib_config
    echo Configuration Path: ~/.jpg.config
    # echo Config Directory: {{JPG_CONFIG_DIR}}
    echo Template Directory: {{JPG_TEMPLATES_DIR}}

    

