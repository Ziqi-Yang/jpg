import 'jpg'

JPG_USER_SCRIPT_FILE_PATH := join(JPG_CONFIG_DIR, "script.just")
JPG_USER_CONFIG_FILE_PATH := join(JPG_CONFIG_DIR, "config")

[private]
@__help:
    just -l

[private]
@check-deps:
    echo All the dependencies are optional. But some helper command of jpg use these \
      dependencies.
    echo --------------------------------------
    -type fd
    echo --------------------------------------
    echo fd - https://github.com/sharkdp/fd

[private]
make_directories:
    #!/usr/bin/env sh
    set -eu
    echo "[*] Make Directories & Files"
    mkdir -p {{JPG_TEMPLATES_DIR}}
    
    # touch intermediate file, which imports the actual user configurations
    cat > ~/.jpg.root.just<< EOF
    #This file shouldn't be manually modified!
    import? '{{JPG_USER_SCRIPT_FILE_PATH}}'
    EOF

    if [ ! -f '{{JPG_USER_SCRIPT_FILE_PATH}}' ]; then
    cat > '{{JPG_USER_SCRIPT_FILE_PATH}}'<< EOF
    # your configuration file path (format is the same as `.env` file format)
    set dotenv-path := '{{JPG_USER_CONFIG_FILE_PATH}}'
    EOF
    fi

    # touch user configuration file
    touch '{{JPG_USER_CONFIG_FILE_PATH}}'


[private]
intall_completion:

# Install jpg
install: make_directories && check-deps
    #TODO

# Run test
test: && (jpg-replace-builtin "test")
    rm -rf ./test
    cp -r ./test_template ./test
    

