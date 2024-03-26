# Currently we needs to set `no-cd` attribute to all the recipes,
#   See https://github.com/casey/just/issues/1978

# execution order explain: jpg-copy-template -> python -> jpg-replace-builtin
# Docs String
[no-cd]
python name: (jpg-copy-template name "python") && (jpg-replace-builtin name)
    #!/usr/bin/env sh
    # use 'set -eux' to print the steps
    set -eu
    cd '{{name}}'
    PYTHON_VERSION=$(python3 --version)
    fd -t f -x sh -c "
    # pass multiple '-e' to do multi-replacement
    sed -i \
      -e \"s&::PYTHON_VERSION::&${PYTHON_VERSION}&g\" \
      '{}'
    "
