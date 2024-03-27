# Currently we needs to set `no-cd` attribute to all the recipes,
#   See https://github.com/casey/just/issues/1978

[private, no-cd]
@done:
    echo "done!"

# execution order explain: create -> python -> done
# Docs String
[no-cd]
python name: (create name "python") && done
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
