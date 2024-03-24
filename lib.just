# If you want to change the following settings, either edit the ~/.jpg.config file
# or export these corresponding environment variables

# `fd` firest interprets '{{' as '{'
# Static Slot
JPG_S_USER_NAME := "@{{{{jpg.user.name}}}}"
JPG_S_USER_EMAIL := "@{{{{jpg.user.email}}}}"

# Value for static slot
JPG_V_USER_NAME := env("JPG_V_USER", `git config user.name`)
JPG_V_USER_EMAIL := env("JPG_V_EMAIL", `git config user.email`)

# Runtime Slot - Value assigned at Runtime ==================================
JPG_RS_PATH_ROOT_DIR := "@{{{{jpg.path.root_dir}}}}" # project root directory
JPG_RS_PATH_FILE_NAME := "@{{{{jpg.path.filename}}}}"
JPG_RS_PATH_FILE_NAME_ABS := "@{{{{jpg.path.filename#abs}}}}"
JPG_RS_PATH_BASE_FILE_NAME := "@{{{{jpg.path.basefilename}}}}" # current filename basename, e.g. README.typ
JPG_RS_PATH_BASE_FILE_NAME_NO_EXT := "@{{{{jpg.path.basefilename_noext}}}}" # current filename basename without extension (e.g. README)
JPG_RS_PATH_PARENT_DIR := "@{{{{jpg.path.parent_dir}}}}"
JPG_RS_PATH_PARENT_DIR_ABS := "@{{{{jpg.path.parent_dir#abs}}}}"

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
    fd -a -t f -x sh -c "
      set -eu
      
      JPG_RS_PATH_FILE_NAME_REL=\$(realpath -s --relative-base=${jpg__path__root_dir} '{}')
      JPG_RS_PATH_PARENT_DIR_REL=\$(realpath -s --relative-base=${jpg__path__root_dir} '{//}')

      # TODO change to `sd` when multiple find-replace feature is done
      # https://github.com/chmln/sd/issues/133
      sed -i \
        -e 's&{{JPG_S_USER_NAME}}&{{JPG_V_USER_NAME}}&g' \
        -e 's&{{JPG_S_USER_EMAIL}}&{{JPG_V_USER_EMAIL}}&g' \
        -e 's&{{JPG_RS_PATH_ROOT_DIR}}&${jpg__path__root_dir}&g' \
        -e \"s&{{JPG_RS_PATH_FILE_NAME}}&\${JPG_RS_PATH_FILE_NAME_REL}&g\" \
        -e 's&{{JPG_RS_PATH_FILE_NAME_ABS}}&{}&g' \
        -e 's&{{JPG_RS_PATH_BASE_FILE_NAME}}&{/}&g' \
        -e 's&{{JPG_RS_PATH_BASE_FILE_NAME_NO_EXT}}&{/.}&g' \
        -e \"s&{{JPG_RS_PATH_PARENT_DIR}}&\${JPG_RS_PATH_PARENT_DIR_REL}&g\" \
        -e 's&{{JPG_RS_PATH_PARENT_DIR_ABS}}&{//}&g' \
        '{}'
    "

    
