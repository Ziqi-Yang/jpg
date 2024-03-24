mpm_user := "zarkli"

# If you want to change the following settings, either edit the ~/.mpm.config file
# or export these corresponding environment variables

# Since fd interpret '{{' as '{', we'd better use '[[' for templating
# Static Slot
MPM_S_USER_NAME :="@[[mpm.user.name]]"
MPM_S_USER_EMAIL := "@[[mpm.user.email]]"

# Value for static slot
MPM_V_USER_NAME := env("MPM_V_USER", `git config user.name`)
MPM_V_USER_EMAIL := env("MPM_V_EMAIL", `git config user.email`)

# Runtime Slot - Value assigned at Runtime ==================================
MPM_RS_PATH_ROOT_DIR := "@[[mpm.path.root_dir]]" # project root directory
MPM_RS_PATH_FILE_NAME := "@[[mpm.path.filename]]"
MPM_RS_PATH_FILE_NAME_ABS := "@[[mpm.path.filename#abs]]"
MPM_RS_PATH_BASE_FILE_NAME := "@[[mpm.path.basefilename]]" # current filename basename, i.e. README.typ
MPM_RS_PATH_BASE_FILE_NAME_NO_EXT := "@[[mpm.path.basefilename_noext]]" # current filename basename without extension (i.e. README)
MPM_RS_PATH_PARENT_DIR := "@[[mpm.path.parent_dir]]"
MPM_RS_PATH_PARENT_DIR_ABS := "@[[mpm.path.parent_dir#abs]]"


# @[[mpm.user.name]]
# @[[mpm.user.email]]
# @[[mpm.path.filename]]
# @[[mpm.path.filename#abs]]
# @[[mpm.path.root_dir]]
# @[[mpm.path.basefilename]]
# @[[mpm.path.basefilename_noext]]
# @[[mpm.path.parent_dir]]
# @[[mpm.path.parent_dir#abs]]

# make a DIR directory and run `git init` at DIR
[private]
mpm-create-git-proj dir: (mpm-create-dir dir) (mpm-git-init dir)

# create DIR
[private]
mpm-create-dir dir:
    @mkdir -p {{dir}}

# run `git init` at DIR
[private]
mpm-git-init dir:
    @git -C {{dir}} init

[private]
@lib_config:
    echo "BUILTIN REPLACEMENT: ===================================="

# copy template
[private]
mpm-copy-template template-name:
    # TODO

# replace basic 
[private]
mpm-replace-basic dir:
    #!/usr/bin/env sh
    set -eu
    cd '{{dir}}'      
    mpm__path__root_dir=$(pwd)
    # replace static slots
    fd -a -t f -x sh -c "
      sd -F '{{MPM_S_USER_NAME}}' '{{MPM_V_USER_NAME}}' '{}'
      sd -F '{{MPM_S_USER_EMAIL}}' '{{MPM_V_USER_EMAIL}}' '{}'
      
      MPM_RS_PATH_FILE_NAME_REL=\$(realpath -s --relative-base=${mpm__path__root_dir} '{}')
      MPM_RS_PATH_PARENT_DIR_REL=\$(realpath -s --relative-base=${mpm__path__root_dir} '{//}')
      sd -F '{{MPM_RS_PATH_ROOT_DIR}}' '${mpm__path__root_dir}' '{}'
      sd -F '{{MPM_RS_PATH_FILE_NAME}}' \${MPM_RS_PATH_FILE_NAME_REL} '{}'
      sd -F '{{MPM_RS_PATH_FILE_NAME_ABS}}' '{}' '{}'
      sd -F '{{MPM_RS_PATH_BASE_FILE_NAME}}' '{/}' '{}'
      sd -F '{{MPM_RS_PATH_BASE_FILE_NAME_NO_EXT}}' '{/.}' '{}'
      sd -F '{{MPM_RS_PATH_PARENT_DIR}}' \${MPM_RS_PATH_PARENT_DIR_REL} '{}'
      sd -F '{{MPM_RS_PATH_PARENT_DIR_ABS}}' '{//}' '{}'
    "
    
