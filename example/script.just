# example
python name: (jpg-copy-template name "python") && (jpg-replace-builtin name)
    #!/usr/bin/env sh
    # use 'set -eux' to print the steps
    set -eu
    PYTHON_VERSION=$(python3 --version)
    fd -t f -x sh -c "
    sed -i \
      -e \"s&Python 3.11.8&${PYTHON_VERSION}&g\" \
      '{}'
      "
