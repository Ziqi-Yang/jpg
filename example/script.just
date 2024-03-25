# Currently we needs to set `no-cd` attribute to all the recipes,
#   See https://github.com/casey/just/issues/1978

# example
[no-cd]
python name: (jpg-copy-template name "python") && (jpg-replace-builtin name)
    #!/usr/bin/env sh
    # use 'set -eux' to print the steps
    set -eu
    cd '{{name}}'
    PYTHON_VERSION=$(python3 --version)
    fd -t f -x sh -c "
    sed -i \
      -e \"s&::PYTHON_VERSION::&${PYTHON_VERSION}&g\" \
      '{}'
      "
