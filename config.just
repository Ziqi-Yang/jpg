# currently we don't allow user to change config folder path, reason -> trace
# 'JPG_USER_ROOT_CONFIG_FILE_PATH' variable in `justfile`
JPG_CONFIG_DIR := join(config_directory(), "jpg")

JPG_TEMPLATES_DIR := env("JPG_TEMPLATES_DIR", join(JPG_CONFIG_DIR, "template"))

# Template ===================================
JPG_TEMP_BEGIN_SYM := "::"
JPG_TEMP_END_SYM := "::"

# Value for static slot
JPG_V_USER_NAME := env("JPG_V_USER", `git config user.name || echo ""`)
JPG_V_USER_EMAIL := env("JPG_V_EMAIL", `git config user.email || echo ""`)

# Display configuration information
config *customizable:
    #!/usr/bin/env sh
    set -eu
    if [ -n '{{customizable}}' ]; then
      # JPG_CONFIG_DIR is currently not customizable
      printenv | grep -P "^JPG_(?!S_|RS_|CONFIG_DIR).*" | sort
    else
      printenv | grep "^JPG_" | sort
    fi

