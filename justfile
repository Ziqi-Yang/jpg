import 'jpg'

set ignore-comments

JPG_USER_SCRIPT_FILE_PATH := join(JPG_CONFIG_DIR, "script.just")
JPG_USER_CONFIG_FILE_PATH := join(JPG_CONFIG_DIR, "config")

# similar to `make install` 
PREFIX := env("PREFIX", "/")
BIN_DIR := join(PREFIX, "usr/bin")
INSTALL_DIR := join(PREFIX, "usr/lib/jpg")
INSTALL_EXAMPLE_DIR := join(INSTALL_DIR, "example")

BASH_COMPLETION_DIR := env("BASH_COMPLETION_DIR", join(PREFIX, "usr/share/bash-completion/completions"))
ZSH_COMPLETION_DIR := env("ZSH_COMPLETION_DIR", join(PREFIX, "usr/share/zsh/site-functions"))
FISH_COMPLETION_DIR := env("FISH_COMPLETION_DIR", join(PREFIX, "usr/share/fish/vendor_completions.d"))

[private]
@__help:
    just -l

[private]
@check-deps:
    echo
    echo [*] Check Dependency
    echo All the dependencies are optional. But some helper commands of jpg use these \
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

install_completion:
    @echo
    @echo "[*] Install shell completion files"
    install -Dm644 'completions/jpg.zsh' '{{join(ZSH_COMPLETION_DIR, "_jpg")}}'
    install -Dm644 'completions/jpg.bash' '{{join(BASH_COMPLETION_DIR, "jpg")}}'
    install -Dm644 'completions/jpg.fish' '{{join(FISH_COMPLETION_DIR, "jpg.fish")}}'

uninstall_completion:
    @echo
    @echo "[*] Uninstall shell completion files"
    rm -f '{{join(ZSH_COMPLETION_DIR, "_jpg")}}'
    rm -f '{{join(BASH_COMPLETION_DIR, "jpg")}}'
    rm -f '{{join(FISH_COMPLETION_DIR, "jpg.fish")}}'


# TODO provide local install an uninstall

# Install JPG
install: && install_completion check-deps
    @echo '[*] Installing JPG'
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
uninstall: && uninstall_completion
    @echo '[*] Uninstalling JPG'
    @read -p "You will uninstall the JPG program at directory '{{INSTALL_DIR}}' [ENTER/Ctrl+C]"
    rm -rf '{{INSTALL_DIR}}'
    rm -f '{{join(BIN_DIR, "jpg")}}'

# Run test
test: && (jpg-replace-builtin "test")
    rm -rf ./test
    cp -r ./test_template ./test
    

