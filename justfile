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

# we needs to separate it with the `install` command since the permission of file is changed
# to the root user when using sudo

create-example-user-configuration:
    #!/usr/bin/env sh
    set -eu
    echo "[*] Create Example User Configuration"
    if [ ! -d '{{JPG_TEMPLATES_DIR}}' ]; then
      mkdir -p {{JPG_TEMPLATES_DIR}}
      cp -r ./example/template '{{JPG_CONFIG_DIR}}'
    fi
    
    # touch intermediate file, which imports the actual user configurations
    cat > ~/.jpg.root.just<< EOF
    #This file shouldn't be manually modified!
    import? '{{JPG_USER_SCRIPT_FILE_PATH}}'
    EOF

    if [ ! -f '{{JPG_USER_SCRIPT_FILE_PATH}}' ]; then
    cat > '{{JPG_USER_SCRIPT_FILE_PATH}}'<< EOF
    # your configuration file path (format is the same as '.env' file format)
    set dotenv-path := '{{JPG_USER_CONFIG_FILE_PATH}}'
    
    EOF
    cat ./example/script.just >> '{{JPG_USER_SCRIPT_FILE_PATH}}'
    fi

    # touch user configuration file
    touch '{{JPG_USER_CONFIG_FILE_PATH}}'


[private]
intall_completion:

# similar to `make install` 
PREFIX := env("PREFIX", "/usr")
BIN_DIR := join(PREFIX, "bin")
INSTALL_DIR := join(PREFIX, "lib/jpg")
INSTALL_EXAMPLE_DIR := join(INSTALL_DIR, "example")

# TODO provide local install an uninstall

# `sudo --preserve-env just install` so that home directory can be correctly set
# Install JPG
install: && check-deps
    install -d '{{INSTALL_DIR}}'
    install -d '{{INSTALL_EXAMPLE_DIR}}'
    install -Dm755 ./jpg '{{INSTALL_DIR}}'
    install -Dm644 ./*.just '{{INSTALL_DIR}}'
    install -Dm644 ./LICENSE '{{INSTALL_DIR}}'
    cp -r ./example/* '{{INSTALL_EXAMPLE_DIR}}'
    # see issue: https://github.com/casey/just/issues/1977
    # ln -sf '{{join(INSTALL_DIR, "jpg")}}' '{{join(BIN_DIR, "jpg")}}'
    install -Dm755 ./jpg.sh '{{join(BIN_DIR, "jpg")}}'

# uninstall JPG
uninstall:
    read -p "You will uninstall the JPG program at directory '{{INSTALL_DIR}}' [ENTER]"
    rm -rf '{{INSTALL_DIR}}'
    rm '{{join(BIN_DIR, "jpg")}}'

# Run test
test: && (jpg-replace-builtin "test")
    rm -rf ./test
    cp -r ./test_template ./test
    

