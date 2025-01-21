[private, no-cd]
jpg-git-init dir:
  git -C '{{dir}}' init

[private, no-cd]
jpg-jj-init dir:
  cd '{{dir}}' && jj git init --colocate

[private, no-cd]
jpg-git-jj-init dir: (jpg-git-init dir) (jpg-jj-init dir)

[private, no-cd]
jpg-mkdir name:
  mkdir {{name}}
  
[private, no-cd]
exit-if-exists path:
  if [ -d '{{path}}' ]; then printf "Path '{{path}}' already exists!\n"; exit 1; fi

[private, no-cd, doc("mkdir, git init")]
jpg-git-new name: (jpg-mkdir name) (jpg-git-init name)

[private, no-cd, doc("mkdir, git init, jj git init --colocate")]
jpg-jj-new name: (jpg-git-new name) (jpg-jj-init name)
  

[private, no-cd, doc("copy template TEMPLATE_NAME from 'JPG_TEMPLATES_DIR' to DIR directory")]
jpg-copy-template dir template-name:
  cp -r '{{join(JPG_V_TEMPLATE_DIR, template-name)}}' '{{dir}}'

[private, no-cd, doc("copy contents of template TEMPLATE_NAME from 'JPG_TEMPLATES_DIR' into DIR directory")]
jpg-copy-template-contents dir template-name:
  cp -rT '{{join(JPG_V_TEMPLATE_DIR, template-name)}}' '{{dir}}'


# set environment variables and call `just jpg-render-jinja2 dir` in another recipe to use
# this function
# dependencies:
# fd: https://github.com/sharkdp/fd
# jinjanator: https://github.com/kpfleming/jinjanator
[private, no-cd, doc("render jinja2 templates inside DIR")]
jpg-render-jinja2 dir:
  #!/usr/bin/env sh
  set -eu
  
  cd "{{dir}}"
  export PROJ_ROOT_PATH=$(pwd)
  export PROJ_NAME=$(basename "$PROJ_ROOT_PATH")
  
  export USER_NAME="{{JPG_V_USER_NAME}}"
  export USER_EMAIL="{{JPG_V_USER_EMAIL}}"
  export JPG_CONFIG_DIR="{{JPG_V_CONFIG_DIR}}"
  export JPG_TEMPLATE_DIR="{{JPG_V_TEMPLATE_DIR}}"
  
  fd -a -t f -x sh -c "
  set -eu
  
  export FILENAME_ABS='{}'
  export FILENAME_ABS_NO_EXT='{.}'
  export FILENAME='{/}'
  export FILENAME_NO_EXT='{/.}'
  export PARENT_DIR_ABS='{//}'

  echo -n '{{BOLD + BLUE}}Processing file {}{{NORMAL}}'
  
  jinjanate --quiet -e='' '{}' -o '{}'
  
  echo '{{BOLD + BLUE}} -- done {{NORMAL}}'
  "



