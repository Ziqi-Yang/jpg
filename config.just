# If you want to change the following settings, either edit the ~/.jpg.config file
# or export these corresponding environment variables

# currently we don't allow user to change config folder path, reason -> trace
# 'JPG_USER_ROOT_CONFIG_FILE_PATH' variable in `justfile`
JPG_CONFIG_DIR := join(config_directory(), "jpg")
JPG_TEMPLATES_DIR := env("JPG_TEMPLATES_DIR", join(JPG_CONFIG_DIR, "template"))

# Template ===================================
# Value for static slot
JPG_V_USER_NAME := env("JPG_V_USER", `git config user.name`)
JPG_V_USER_EMAIL := env("JPG_V_EMAIL", `git config user.email`)

# Display configuration information
@config:
    echo "Note that since builtin template variable replacement uses 'fd', double braces are used. '{{{{' will be translated into '{'."
    echo "=========================================="
    printenv | grep "JPG_" | sort

