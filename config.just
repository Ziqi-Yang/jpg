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

# Display configuration information (default print all customizable configurations; '-a' to print all JPG variables; variable name to print its value)
config a0="":
    #!/usr/bin/env sh
    set -eu
    case '{{a0}}' in
      "-a")  # print all JPG variables
        printenv | grep "^JPG_" | sort
        ;;
      "")  # print all the customizable variables
        # JPG_CONFIG_DIR is currently not customizable
        printenv | grep -P "^JPG_(?!S_|RS_|CONFIG_DIR).*" | sort
        ;;
      JPG_*)  # print value for specific JPG variable
        printenv '{{a0}}'
        ;;
      *)
        printf "'{{a0}}' is not a JPG variable!\n" >&2
        exit 1
        ;;
    esac
    



