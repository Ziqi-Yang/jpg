#!/usr/bin/env -S just --working-directory . --dotenv-path ${HOME}/.mpm.config --justfile
#TODO MacOS shebang test: https://github.com/casey/just?tab=readme-ov-file#just-scripts

set allow-duplicate-recipes
set dotenv-load
# see https://github.com/casey/just/issues/1976
# currently using shebang hack (${HOME})
# set dotenv-path "~/.mpm.config"

import 'lib.just'

MPM_CONFIG_DIR := join(config_directory(), "mpm") # TODO temporary no use
MPM_TEMPLATES_DIR := env("MPM_TEMPLATES_DIR", join(MPM_CONFIG_DIR, "template"))

# Currently we could only use this indirect way to import user defined justfiles
# https://github.com/casey/just/issues/1975
import? "~/.mpm.root.just"

@_:
    {{justfile()}} -l

# Display configuration information
@config: && lib_config
    echo Configuration Path: ~/.mpm.config
    # echo Config Directory: {{MPM_CONFIG_DIR}}
    echo Template Directory: {{MPM_TEMPLATES_DIR}}

    

