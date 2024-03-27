# Helper Functions provided for user

# NOTE Currently we needs to put `no-cd` attribute for all the recipes:
#  See https://github.com/casey/just/issues/1978

# make a DIR directory and run `git init` at DIR
[private, no-cd]
jpg-create-git-proj dir: (jpg-create-dir dir) (jpg-git-init dir)

# create DIR
[private, no-cd]
jpg-create-dir dir:
    @mkdir -p {{dir}}

# run `git init` at DIR
[private, no-cd]
jpg-git-init dir:
    @git -C {{dir}} init

[private, no-cd]
@exit-when-path-exist path:
    if [ -d '{{path}}' ]; then printf "Path '{{path}}' already exists!\n"; exit 1; fi

# Create project NAME (copy template TEMPLATE-NAME and do builtin variables replacement)
[no-cd]
create name template-name: (exit-when-path-exist name) \
    && (jpg-copy-template name template-name) (jpg-replace-builtin name)

# copy template TEMPLATE_NAME from 'JPG_TEMPLATES_DIR' to DIR directory
[private, no-cd]
jpg-copy-template dir template-name:
    cp -r '{{join(JPG_TEMPLATES_DIR, template-name)}}' '{{dir}}'

# copy contents of template TEMPLATE_NAME from 'JPG_TEMPLATES_DIR' to DIR directory
[private, no-cd]
jpg-copy-template-contents dir template-name:
    cp -rT '{{join(JPG_TEMPLATES_DIR, template-name)}}' '{{dir}}'

# replace JPG's builtin variables for all files indie DIR
[private, no-cd]
jpg-replace-builtin dir:
    #!/usr/bin/env sh
    set -eu
    echo "[*] replacing builtin template variables"
    
    cd '{{dir}}'      
    jpg__path__root_dir=$(pwd)
    jpg__proj__name=$(basename "$jpg__path__root_dir")
    
    # TODO change to 'sd' when multiple find-replace feature is done
    # https://github.com/chmln/sd/issues/133
    fd -a -t f -x sh -c "
      set -eu
      
      JPG_RS_PATH_FILE_NAME_REL=\$(realpath -s --relative-base=${jpg__path__root_dir} '{}')
      JPG_RS_PATH_PARENT_DIR_REL=\$(realpath -s --relative-base=${jpg__path__root_dir} '{//}')

      sed -i \
        -e 's&{{JPG_S_AUTHOR_NAME}}&{{JPG_V_AUTHOR_NAME}}&g' \
        -e 's&{{JPG_S_AUTHOR_EMAIL}}&{{JPG_V_AUTHOR_EMAIL}}&g' \
        -e 's&{{JPG_RS_PROJ_NAME}}&${jpg__proj__name}&g' \
        -e 's&{{JPG_RS_PATH_ROOT_DIR}}&${jpg__path__root_dir}&g' \
        -e \"s&{{JPG_RS_PATH_FILE_NAME}}&\${JPG_RS_PATH_FILE_NAME_REL}&g\" \
        -e 's&{{JPG_RS_PATH_FILE_NAME_ABS}}&{}&g' \
        -e 's&{{JPG_RS_PATH_BASE_FILE_NAME}}&{/}&g' \
        -e 's&{{JPG_RS_PATH_BASE_FILE_NAME_NO_EXT}}&{/.}&g' \
        -e \"s&{{JPG_RS_PATH_PARENT_DIR}}&\${JPG_RS_PATH_PARENT_DIR_REL}&g\" \
        -e 's&{{JPG_RS_PATH_PARENT_DIR_ABS}}&{//}&g' \
        '{}'
    "

    
