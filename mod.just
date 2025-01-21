JPG_VERSION := "0.1.0"

JPG_V_USER_NAME := env("JPG_V_USER_NAME", `git config user.name || echo ""`)
JPG_V_USER_EMAIL := env("JPG_V_USER_EMAIL", `git config user.email || echo ""`)

JPG_V_CONFIG_DIR := env("JPG_V_CONDIG_DIR", join(config_directory(), "jpg"))
JPG_V_TEMPLATE_DIR := env("JPG_TEMPLATES_DIR", join(JPG_V_CONFIG_DIR, "template"))


import "./core.just"
import "./languages.just"
  
[group("jpg")]
@jpg-version:
  echo '{{JPG_VERSION}}'
