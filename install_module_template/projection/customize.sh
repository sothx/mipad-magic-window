# shellcheck disable=SC2148
# shellcheck disable=SC2034

SKIPUNZIP=0
. "$MODPATH"/util_functions.sh
api_level_arch_detect
magisk_path=/data/adb/modules/
module_id=$(grep_prop id "$MODPATH/module.prop")
module_versionCode=$(expr "$(grep_prop versionCode "$MODPATH/module.prop")" + 0)
device_code="$(getprop ro.product.device)"
device_soc_name="$(getprop ro.vendor.qti.soc_name)"
device_soc_model="$(getprop ro.vendor.qti.soc_model)"
device_characteristics="$(getprop ro.build.characteristics)"
has_been_installed_module_versionCode=$(expr "$(grep_prop versionCode "$magisk_path$module_id/module.prop")" + 0)
MODULE_CUSTOM_CONFIG_PATH="/data/adb/"$module_id

# 重置缓存
# rm -rf /data/system/package_cache
# rm -rf /data/resource-cache

# 赋予文件夹权限
/bin/chmod -R 777 "$MODPATH"

set_perm_recursive "$MODPATH"/common/utils 0 0 0755 0777 u:object_r:system_file:s0

# 基础函数
add_props() {
  local line="$1"
  printf "\n$line" >>"$MODPATH"/system.prop
}

key_check() {
  while true; do
    key_check=$(/system/bin/getevent -qlc 1)
    key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
    key_status=$(echo "$key_check" | awk '{ print $4 }')
    if [[ "$key_event" == *"KEY_"* && "$key_status" == "DOWN" ]]; then
      keycheck="$key_event"
      break
    fi
  done
  while true; do
    key_check=$(/system/bin/getevent -qlc 1)
    key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
    key_status=$(echo "$key_check" | awk '{ print $4 }')
    if [[ "$key_event" == *"KEY_"* && "$key_status" == "UP" ]]; then
      break
    fi
  done
}

if [[ "$KSU" == "true" ]]; then
  ui_print "- KernelSU 用户空间当前的版本号: $KSU_VER_CODE"
  ui_print "- KernelSU 内核空间当前的版本号: $KSU_KERNEL_VER_CODE"
  if [ "$KSU_VER_CODE" -lt 11551 ]; then
    ui_print "*********************************************"
    ui_print "- 请更新 KernelSU 到 v0.8.0+ ！"
    abort "*********************************************"
  fi
elif [[ "$APATCH" == "true" ]]; then
  ui_print "- APatch 当前的版本号: $APATCH_VER_CODE"
  ui_print "- APatch 当前的版本名: $APATCH_VER"
  ui_print "- KernelPatch 用户空间当前的版本号: $KERNELPATCH_VERSION"
  ui_print "- KernelPatch 内核空间当前的版本号: $KERNEL_VERSION"
  if [ "$APATCH_VER_CODE" -lt 10568 ]; then
    ui_print "*********************************************"
    ui_print "- 请更新 APatch 到 10568+ ！"
    abort "*********************************************"
  fi
else
  ui_print "- Magisk 版本: $MAGISK_VER_CODE"
  if [ "$MAGISK_VER_CODE" -lt 26000 ]; then
    ui_print "*********************************************"
    ui_print "- 模块当前仅支持 Magisk 26.0+ 请更新 Magisk！"
    ui_print "- 您可以选择继续安装，但可能导致部分模块功能无法正常使用，是否继续？"
    ui_print "  音量+ ：已了解，继续安装"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "*********************************************"
      ui_print "- 你选择无视Magisk低版本警告，可能导致部分模块功能无法正常使用！！！"
      ui_print "*********************************************"
    else
      ui_print "*********************************************"
      ui_print "- 请更新 Magisk 到 26.0+ ！"
      abort "*********************************************"
    fi
  fi
fi

# 初始化模块配置目录
if [[ ! -d "$MODULE_CUSTOM_CONFIG_PATH" ]]; then
  /bin/mkdir -p "$MODULE_CUSTOM_CONFIG_PATH"
  if [[ ! -f "$MODULE_CUSTOM_CONFIG_PATH/config.prop" ]]; then
    /bin/touch "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    /bin/chmod 777 "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
  fi
fi

if [ -f "$MODPATH"/verify_functions.sh ]; then
  . "$MODPATH"/verify_functions.sh
  if type verify_android_api_has_pass &>/dev/null; then
    verify_android_api_has_pass $API
  fi
  # 专版模块判断逻辑
  if type verify_special_rule_pass &>/dev/null; then
    verify_special_rule_pass
  fi
fi

if [[ ! -d "$MODPATH/common/temp" ]]; then
  /bin/mkdir -p "$MODPATH/common/temp"
fi

ui_print "- 好诶w，《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"
