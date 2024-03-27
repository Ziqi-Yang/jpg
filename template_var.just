# `fd` first interprets '{{' as '{'
# Static Slot
JPG_S_USER_NAME := JPG_TEMP_BEGIN_SYM + "jpg.user.name" + JPG_TEMP_END_SYM
JPG_S_USER_EMAIL := JPG_TEMP_BEGIN_SYM + "jpg.user.email" + JPG_TEMP_END_SYM


# Runtime Slot - Value assigned at Runtime ==================================
JPG_RS_PROJ_NAME := JPG_TEMP_BEGIN_SYM + "jpg.proj.name" + JPG_TEMP_END_SYM # basically the name of the project directory

JPG_RS_PATH_ROOT_DIR := JPG_TEMP_BEGIN_SYM + "jpg.path.root_dir" + JPG_TEMP_END_SYM # absolute project directory
JPG_RS_PATH_FILE_NAME := JPG_TEMP_BEGIN_SYM + "jpg.path.filename" + JPG_TEMP_END_SYM
JPG_RS_PATH_FILE_NAME_ABS := JPG_TEMP_BEGIN_SYM + "jpg.path.filename#abs" + JPG_TEMP_END_SYM
# current filename basename, e.g. README.typ
JPG_RS_PATH_BASE_FILE_NAME := JPG_TEMP_BEGIN_SYM + "jpg.path.basefilename" + JPG_TEMP_END_SYM
# current filename basename without extension (e.g. README)
JPG_RS_PATH_BASE_FILE_NAME_NO_EXT := JPG_TEMP_BEGIN_SYM + "jpg.path.basefilename_noext" + JPG_TEMP_END_SYM
JPG_RS_PATH_PARENT_DIR := JPG_TEMP_BEGIN_SYM + "jpg.path.parent_dir" + JPG_TEMP_END_SYM
JPG_RS_PATH_PARENT_DIR_ABS := JPG_TEMP_BEGIN_SYM + "jpg.path.parent_dir#abs" + JPG_TEMP_END_SYM
