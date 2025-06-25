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

# 生成重载规则脚本
/bin/cp -rf "$MODPATH/common/source/update_rule/"* "$MODULE_CUSTOM_CONFIG_PATH/config/"

if [[ ! -d "$MODPATH/common/temp" ]]; then
  /bin/mkdir -p "$MODPATH/common/temp"
fi

# 获取ROOT管理器信息并写入

echo "$KSU,$KSU_VER,$KSU_VER_CODE,$KSU_KERNEL_VER_CODE,$APATCH,$APATCH_VER_CODE,$APATCH_VER,$MAGISK_VER,$MAGISK_VER_CODE" > "$MODPATH/common/temp/root_manager_info.txt"

# 文件夹赋权
/bin/chmod -R 777 "$MODULE_CUSTOM_CONFIG_PATH/config/"

# 禁用应用预加载
sys_prestart_proc=$(grep_prop persist.sys.prestart.proc "$magisk_path$module_id"/system.prop)
if [ -f "$magisk_path$module_id/system.prop" ] &&
  [ "$sys_prestart_proc" = 'false' ]; then
  ui_print "*********************************************"
  ui_print "- 已禁用应用预加载"
  ui_print "- （Tips: 可以前往Web UI 模块设置中修改配置~）"
  add_lines "persist.sys.prestart.proc=false" "$MODPATH"/system.prop
  ui_print "*********************************************"
fi

# 禁用深度睡眠
sys_deep_sleep_proc=$(grep_prop persist.sys.deep_sleep.enable "$magisk_path$module_id"/system.prop)
if [ -f "$magisk_path$module_id/system.prop" ] &&
  [ "$sys_deep_sleep_proc" = 'false' ]; then
  ui_print "*********************************************"
  ui_print "- 已禁用深度睡眠"
  ui_print "- （Tips: 可以前往Web UI 模块设置中修改配置~）"
  add_lines "persist.sys.deep_sleep.enable=false" "$MODPATH"/system.prop
  ui_print "*********************************************"
fi

# 默认闲置刷新率
idle_default_fps=$(grep_prop ro.vendor.display.idle_default_fps "$magisk_path$module_id"/system.prop)
if [ -f "$magisk_path$module_id/system.prop" ] && [ "$idle_default_fps" != "null" ] && [ -n "$idle_default_fps" ]; then
  ui_print "*********************************************"
  ui_print "- 已配置默认闲置刷新率"
  ui_print "- （Tips: 可以前往Web UI 系统体验增强中修改配置~）"
  add_lines "ro.vendor.display.idle_default_fps=""$idle_default_fps" "$MODPATH"/system.prop
  ui_print "*********************************************"
fi

# KSU Web UI
is_need_install_ksu_web_ui=1
if [[ "$KSU" == "true" || "$APATCH" == "true" ]]; then
  is_need_install_ksu_web_ui=0
fi
HAS_BEEN_INSTALLED_KsuWebUI_APK=$(pm list packages | grep io.github.a13e300.ksuwebui)
if [[ $HAS_BEEN_INSTALLED_KsuWebUI_APK == *"package:io.github.a13e300.ksuwebui"* ]]; then
  is_need_install_ksu_web_ui=0
fi
if [[ $is_need_install_ksu_web_ui == 1 ]]; then
  ui_print "*********************************************"
  ui_print "- 是否安装KsuWebUI？"
  ui_print "- [重要提醒]: 安装并赋予Root权限可以可视化查看并管理模块功能"
  ui_print "  音量+ ：是"
  ui_print "  音量- ：否"
  ui_print "*********************************************"
  key_check
  if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
    update_system_prop is_need_install_ksu_web_ui 0 "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    ui_print "- 正在为你安装KSU Web UI，请稍等~"
    unzip -jo "$ZIPFILE" 'common/apks/KsuWebUI.apk' -d /data/local/tmp/ &>/dev/null
    pm install -r /data/local/tmp/KsuWebUI.apk &>/dev/null
    rm -rf /data/local/tmp/KsuWebUI.apk
    HAS_BEEN_INSTALLED_KsuWebUI_APK=$(pm list packages | grep io.github.a13e300.ksuwebui)
    if [[ $HAS_BEEN_INSTALLED_KsuWebUI_APK == *"package:io.github.a13e300.ksuwebui"* ]]; then
      ui_print "- 好诶，KSUWebUI安装完成！"
    else
      abort "- KSUWebUI安装失败，请尝试重新安装！"
      abort "- 也可前往模块网盘下载单独的 KsuWebUI apk 进行手动安装！"
    fi
  else
    update_system_prop is_need_install_ksu_web_ui 0 "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    ui_print "*********************************************"
    ui_print "- 你选择不安装KsuWebUI"
    ui_print "*********************************************"
  fi
fi

ui_print "- 好诶w，《HyperOS 完美横屏应用计划》安装/更新完成，重启系统后生效！"
