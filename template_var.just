# `fd` first interprets '{{' as '{'
# Static Slot
JPG_S_USER_NAME := "@{{{{jpg.user.name}}}}"
JPG_S_USER_EMAIL := "@{{{{jpg.user.email}}}}"

# Runtime Slot - Value assigned at Runtime ==================================
JPG_RS_PATH_ROOT_DIR := "@{{{{jpg.path.root_dir}}}}" # project root directory
JPG_RS_PATH_FILE_NAME := "@{{{{jpg.path.filename}}}}"
JPG_RS_PATH_FILE_NAME_ABS := "@{{{{jpg.path.filename#abs}}}}"
JPG_RS_PATH_BASE_FILE_NAME := "@{{{{jpg.path.basefilename}}}}" # current filename basename, e.g. README.typ
JPG_RS_PATH_BASE_FILE_NAME_NO_EXT := "@{{{{jpg.path.basefilename_noext}}}}" # current filename basename without extension (e.g. README)
JPG_RS_PATH_PARENT_DIR := "@{{{{jpg.path.parent_dir}}}}"
JPG_RS_PATH_PARENT_DIR_ABS := "@{{{{jpg.path.parent_dir#abs}}}}"
