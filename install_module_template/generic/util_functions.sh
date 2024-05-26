# shellcheck disable=SC2148
api_level_arch_detect() {
  API=$(getprop ro.build.version.sdk)
  ABI=$(getprop ro.product.cpu.abi)
  if [ "$ABI" = "x86" ]; then
    ARCH=x86
    ABI32=x86
    IS64BIT=false
  elif [ "$ABI" = "arm64-v8a" ]; then
    ARCH=arm64
    ABI32=armeabi-v7a
    IS64BIT=true
  elif [ "$ABI" = "x86_64" ]; then
    ARCH=x64
    ABI32=x86
    IS64BIT=true
  else
    ARCH=arm
    ABI=armeabi-v7a
    ABI32=armeabi-v7a
    IS64BIT=false
  fi
}

set_perm() {
  chown $2:$3 $1 || return 1
  chmod $4 $1 || return 1
  local CON=$5
  [ -z $CON ] && CON=u:object_r:system_file:s0
  chcon $CON $1 || return 1
}

set_perm_recursive() {
  find $1 -type d 2>/dev/null | while read dir; do
    set_perm $dir $2 $3 $4 $6
  done
  find $1 -type f -o -type l 2>/dev/null | while read file; do
    set_perm $file $2 $3 $5 $6
  done
}

cancel_fix_auth_manager() {
  # 不修复权限管理服务
  CURRENT_MODULE_PROP_PATH="/data/adb/modules/MIUI_MagicWindow+/config/"
  if [[ ! -f "$CUSTOM_CONFIG_MODULE_PROP_PATH" ]]; then
    /bin/mkdir -p $CUSTOM_CONFIG_MODULE_PROP_PATH
    /bin/touch "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
    /bin/chmod 777 "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
  fi
  fixAuthManager=$(grep_prop fixAuthManager "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop)
  printf "fixAuthManager=false\n" >> "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
}

confirm_fix_auth_manager() {
  # 修复权限管理服务
  CURRENT_MODULE_PROP_PATH="/data/adb/modules/MIUI_MagicWindow+/config/"
  if [[ ! -f "$CUSTOM_CONFIG_MODULE_PROP_PATH" ]]; then
    /bin/mkdir -p $CUSTOM_CONFIG_MODULE_PROP_PATH
    /bin/touch "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
    /bin/chmod 777 "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
  fi
  fixAuthManager=$(grep_prop fixAuthManager "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop)
  if [[ $fixAuthManager === 'true' ]]; then
    cp -rf "$1"/common/FixAuthManager/** "$1"/
  else
    printf "fixAuthManager=true\n" >> "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
    cp -rf "$1"/common/FixAuthManager/** "$1"/
  fi
}
