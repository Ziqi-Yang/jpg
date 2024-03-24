jpg_user := "zarkli"

# If you want to change the following settings, either edit the ~/.jpg.config file
# or export these corresponding environment variables

# Since fd interpret '{{' as '{', we'd better use '[[' for templating
# Static Slot
JPG_S_USER_NAME :="@[[jpg.user.name]]"
JPG_S_USER_EMAIL := "@[[jpg.user.email]]"

# Value for static slot
JPG_V_USER_NAME := env("JPG_V_USER", `git config user.name`)
JPG_V_USER_EMAIL := env("JPG_V_EMAIL", `git config user.email`)

# Runtime Slot - Value assigned at Runtime ==================================
JPG_RS_PATH_ROOT_DIR := "@[[jpg.path.root_dir]]" # project root directory
JPG_RS_PATH_FILE_NAME := "@[[jpg.path.filename]]"
JPG_RS_PATH_FILE_NAME_ABS := "@[[jpg.path.filename#abs]]"
JPG_RS_PATH_BASE_FILE_NAME := "@[[jpg.path.basefilename]]" # current filename basename, i.e. README.typ
JPG_RS_PATH_BASE_FILE_NAME_NO_EXT := "@[[jpg.path.basefilename_noext]]" # current filename basename without extension (i.e. README)
JPG_RS_PATH_PARENT_DIR := "@[[jpg.path.parent_dir]]"
JPG_RS_PATH_PARENT_DIR_ABS := "@[[jpg.path.parent_dir#abs]]"


# @[[jpg.user.name]]
# @[[jpg.user.email]]
# @[[jpg.path.filename]]
# @[[jpg.path.filename#abs]]
# @[[jpg.path.root_dir]]
# @[[jpg.path.basefilename]]
# @[[jpg.path.basefilename_noext]]
# @[[jpg.path.parent_dir]]
# @[[jpg.path.parent_dir#abs]]

# make a DIR directory and run `git init` at DIR
[private]
jpg-create-git-proj dir: (jpg-create-dir dir) (jpg-git-init dir)

# create DIR
[private]
jpg-create-dir dir:
    @mkdir -p {{dir}}

# run `git init` at DIR
[private]
jpg-git-init dir:
    @git -C {{dir}} init

[private]
@lib_config:
    echo "BUILTIN REPLACEMENT: ===================================="

# copy template
[private]
jpg-copy-template template-name:
    # TODO

# replace basic 
[private]
jpg-replace-basic dir:
    #!/usr/bin/env sh
    set -eu
    cd '{{dir}}'      
    jpg__path__root_dir=$(pwd)
    # replace static slots
    fd -a -t f -x sh -c "
      sd -F '{{JPG_S_USER_NAME}}' '{{JPG_V_USER_NAME}}' '{}'
      sd -F '{{JPG_S_USER_EMAIL}}' '{{JPG_V_USER_EMAIL}}' '{}'
      
      JPG_RS_PATH_FILE_NAME_REL=\$(realpath -s --relative-base=${jpg__path__root_dir} '{}')
      JPG_RS_PATH_PARENT_DIR_REL=\$(realpath -s --relative-base=${jpg__path__root_dir} '{//}')
      sd -F '{{JPG_RS_PATH_ROOT_DIR}}' '${jpg__path__root_dir}' '{}'
      sd -F '{{JPG_RS_PATH_FILE_NAME}}' \${JPG_RS_PATH_FILE_NAME_REL} '{}'
      sd -F '{{JPG_RS_PATH_FILE_NAME_ABS}}' '{}' '{}'
      sd -F '{{JPG_RS_PATH_BASE_FILE_NAME}}' '{/}' '{}'
      sd -F '{{JPG_RS_PATH_BASE_FILE_NAME_NO_EXT}}' '{/.}' '{}'
      sd -F '{{JPG_RS_PATH_PARENT_DIR}}' \${JPG_RS_PATH_PARENT_DIR_REL} '{}'
      sd -F '{{JPG_RS_PATH_PARENT_DIR_ABS}}' '{//}' '{}'
    "
    
