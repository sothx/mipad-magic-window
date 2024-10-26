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
    abort "*********************************************"
  fi
fi

# 不允许1.25.x之前的老版本模块覆盖更新
if [[ -d "$magisk_path$module_id" && $has_been_installed_module_versionCode -le 125135 ]]; then
  ui_print "*********************************************"
  ui_print "- 新版模块重构了大量的代码逻辑，老版本无法直接在线升级"
  ui_print "- 请直接卸载模块并且重启后再尝试安装QwQ~"
  ui_print "- (可以直接卸载，无需任何额外的卸载专用模块)"
  ui_print "- 模块下载地址:"
  ui_print "- https://caiyun.139.com/m/i?135CmNoBUPann"
  ui_print "- 同时欢迎体验全新的模块Web UI(已适配Android 13-14)"
  abort "*********************************************"
fi

# 不允许1.13.x之前的老版本模块覆盖更新
if [[ -d "$magisk_path$module_id" && $has_been_installed_module_versionCode -le 11300 ]]; then
  ui_print "*********************************************"
  ui_print "- 您当前的模块版本过旧，无法安装，请自行卸载老版本模块再尝试安装！！！"
  abort "*********************************************"
fi

# 初始化模块配置目录
if [[ ! -d "$MODULE_CUSTOM_CONFIG_PATH" ]]; then
  /bin/mkdir -p "$MODULE_CUSTOM_CONFIG_PATH"
  if [[ ! -f "$MODULE_CUSTOM_CONFIG_PATH/config.prop" ]]; then
    /bin/touch "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    /bin/chmod 777 "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
  fi
fi

# 初始化自定义规则配置目录
if [[ ! -d "$MODULE_CUSTOM_CONFIG_PATH/config/" ]]; then
  /bin/mkdir -p "$MODULE_CUSTOM_CONFIG_PATH/config/"
fi
# 初始化定制模式配置目录
if [[ ! -d "$MODULE_CUSTOM_CONFIG_PATH/patch_rule/" ]]; then
  /bin/mkdir -p "$MODULE_CUSTOM_CONFIG_PATH/patch_rule/"
fi
# 生成重载规则脚本
/bin/cp -rf "$MODPATH/common/source/update_rule/"* "$MODULE_CUSTOM_CONFIG_PATH/config/"

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
# 获取ROOT管理器信息并写入

echo "$KSU,$KSU_VER,$KSU_VER_CODE,$KSU_KERNEL_VER_CODE,$APATCH,$APATCH_VER_CODE,$APATCH_VER,$MAGISK_VER,$MAGISK_VER_CODE" > "$MODPATH/common/temp/root_manager_info.txt"

# 文件夹赋权
/bin/chmod -R 777 "$MODULE_CUSTOM_CONFIG_PATH/config/"

# 补丁模式初始化
is_patch_mode=$(grep_prop is_patch_mode "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
if [ -z "$is_patch_mode" ]; then
  update_system_prop is_patch_mode false "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
fi

# 导入MIUI Embedded Activity Window 服务
if [[ -d "$MODPATH/common/source/miui_embedding_window_service/$API/" ]]; then
  # 目录不存在则创建目录
  if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
    /bin/mkdir -p "$MODPATH/system/system_ext/framework"
  fi
  # 复制文件并写入权限
  /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/$API/"* "$MODPATH/system/system_ext/framework/"
  /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
fi

## 导入MIUI Auoto UI 服务
if [[ -d "$MODPATH/common/source/miui_autoui_service/$API/" ]]; then
  # 目录不存在则创建目录
  if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
    /bin/mkdir -p "$MODPATH/system/system_ext/framework"
  fi
  # 复制文件并写入权限
  /bin/cp -rf "$MODPATH/common/source/miui_autoui_service/$API/"* "$MODPATH/system/system_ext/framework/"
  /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
fi

# 骁龙8+Gen1机型判断
is_need_smartfocusio=1
has_been_enabled_smartfocusio=0
if [[ $(grep_prop persist.sys.stability.smartfocusio $magisk_path"mipad-programmable-completion/system.prop") ]]; then
  has_been_enabled_smartfocusio=1
fi
if [[ "$device_soc_model" == "SM8475" && "$device_soc_name" == "cape" && "$API" -ge 33 && $has_been_enabled_smartfocusio == 0 ]]; then

  if [[ $(grep_prop smartfocusio "$MODULE_CUSTOM_CONFIG_PATH/config.prop") ]]; then
    is_need_smartfocusio=$(grep_prop smartfocusio "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
  fi

  if [[ $is_need_smartfocusio == 'on' ]]; then
    ui_print "*********************************************"
    ui_print "- 已开启智能I/O调度(Android 14+ 生效)"
    update_system_prop smartfocusio on "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    add_props "# 开启智能I/O调度"
    add_props "persist.sys.stability.smartfocusio=on"
    ui_print "*********************************************"
  elif [[ $is_need_smartfocusio == 'off' ]]; then
    ui_print "*********************************************"
    ui_print "- 已启用系统默认I/O调度(Android 14+ 生效)"
    update_system_prop smartfocusio off "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    add_props "# 开启系统默认I/O调度"
    add_props "persist.sys.stability.smartfocusio=off"
    ui_print "*********************************************"
  else
    ui_print "*********************************************"
    ui_print "- 检测到你的设备处理器属于骁龙8+Gen1"
    ui_print "- 目前骁龙8+Gen1机型存在IO调度异常的问题，容易导致系统卡顿或者无响应，模块将自动为你配置合适的I/O调度规则"
    ui_print "- 是否调整系统I/O调度？"
    ui_print "  音量+ ：是"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "*********************************************"
      ui_print "- 请选择需要使用的系统I/O调度？"
      ui_print "  音量+ ：启用智能I/O调度"
      ui_print "  音量- ：启用系统默认I/O调度"
      ui_print "*********************************************"
      key_check
      if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
        ui_print "*********************************************"
        ui_print "- 已开启智能I/O调度(Android 14+ 生效)"
        update_system_prop smartfocusio on "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
        add_props "# 开启智能I/O调度"
        add_props "persist.sys.stability.smartfocusio=on"
        ui_print "*********************************************"
      else
        ui_print "*********************************************"
        ui_print "- 已启用系统默认I/O调度(Android 14+ 生效)"
        update_system_prop smartfocusio off "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
        add_props "# 开启系统默认I/O调度"
        add_props "persist.sys.stability.smartfocusio=off"
        ui_print "*********************************************"
      fi
    else
      ui_print "- 你选择不调整系统I/O调度"
    fi
  fi
fi

# 嵌入模块优化说明
is_need_settings_overlay=0
# common_overlay_apk_path="$MODPATH/common/overlay/MiPadSettingsSothxOverlay.apk"
# module_overlay_apk_path="$MODPATH/system/product/overlay/MiPadSettingsSothxOverlay.apk"
# has_been_installed_module_overlay_apk_path="$magisk_path$module_id/system/product/overlay/MiPadSettingsSothxOverlay.apk"
common_theme_overlay_path="$MODPATH/common/theme_overlay/com.android.settings"
module_theme_overlay_path="$MODPATH/system/product/media/theme/default/com.android.settings"
has_been_installed_module_theme_overlay_path="$magisk_path$module_id/system/product/media/theme/default/com.android.settings"

# if [[ "$API" -ge 34 && "$device_characteristics" == 'tablet' ]]; then
#   # 判断首次安装
#   if [[ ! -d "$magisk_path$module_id" ]]; then
#     is_need_settings_overlay=1
#   fi
#   # 判断老版本模块
#   if [[ $has_been_installed_module_versionCode -le 119036 ]]; then
#     is_need_settings_overlay=1
#   fi
#   # 判断已启用overlay
#   if [[ -f "$has_been_installed_module_theme_overlay_path" && $is_need_settings_overlay == '0' ]]; then
#     if [[ ! -d "$MODPATH/system/product/media/theme/default/" ]]; then
#       mkdir -p "$MODPATH/system/product/media/theme/default/"
#     fi
#     rm -rf "$module_overlay_apk_path"
#     cp -f "$common_theme_overlay_path" "$module_theme_overlay_path"
#     ui_print "*********************************************"
#     ui_print "- 已自动嵌入模块优化说明到[设置-平板专区](仅默认主题生效)"
#     ui_print "*********************************************"
#   fi
#   if [[ $is_need_settings_overlay == "1" ]]; then
#     # 展示提示
#     ui_print "*********************************************"
#     ui_print "- 是否嵌入模块优化说明到[设置-平板专区]?"
#     ui_print "  音量+ ：是"
#     ui_print "  音量- ：否"
#     ui_print "*********************************************"
#     key_check
#     if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
#         if [[ ! -d "$MODPATH/system/product/media/theme/default/" ]]; then
#           mkdir -p "$MODPATH/system/product/media/theme/default/"
#         fi
#         cp -f "$common_theme_overlay_path" "$module_theme_overlay_path"
#         rm -rf
#         ui_print "*********************************************"
#         ui_print "- 已嵌入模块优化说明到[设置-平板专区](仅默认主题生效)"
#         ui_print "*********************************************"
#     else
#       ui_print "*********************************************"
#       ui_print "- 你选择不嵌入模块优化说明到[设置-平板专区]"
#       ui_print "*********************************************"
#     fi
#   fi
# fi
# 赋值平行窗口相关属性
# if [[ "$API" -ge 35 && "$device_characteristics" == 'tablet' ]]; then
#   ui_print "*********************************************"
#   ui_print "- 检测到你的设备搭载的是 Hyper OS For Pad 2.0 以上的版本"
#   ui_print "- 已为[应用显示布局]提供更多的选项配置"
#   add_props "ro.config.miui_embedded_compat_enable=true"
#   ui_print "*********************************************"
# fi

has_been_miui_appcompat_enable="false"
has_been_miui_compat_enable="false"
# 如果存在配置文件则赋值
if [ -f "$magisk_path$module_id"/system.prop ]; then
  has_been_miui_appcompat_enable=$(grep_prop ro.config.miui_appcompat_enable "$magisk_path$module_id"/system.prop)
  has_been_miui_compat_enable=$(grep_prop ro.config.miui_appcompat_enable "$magisk_path$module_id"/system.prop)
fi
is_need_show_game_mode_select=0
# 游戏显示布局
if [[ "$API" -ge 33 ]]; then
  # 判断首次安装
  if [[ ! -d "$magisk_path$module_id" ]]; then
    is_need_show_game_mode_select=1
  fi
  # 判断已配置游戏显示布局
  if [ -f "$magisk_path$module_id/system.prop" ] &&
    [ "$has_been_miui_appcompat_enable" = 'true' ] &&
    [ "$has_been_miui_compat_enable" = 'true' ] &&
    [ "$is_need_show_game_mode_select" = '0' ]; then
    ui_print "*********************************************"
    ui_print "- 已开启游戏显示布局(仅游戏加速内的游戏生效)，是否支持以实际机型底层适配为准"
    ui_print "- （Tips: 开启后王者荣耀、CF手游默认会以更宽的视野进行显示）"
    ui_print "- 详细使用方式请阅读模块文档~"
    ui_print "- Android 15+需要额外安装修改版手机/平板管家才会生效~"
    ui_print "- [游戏显示布局使用文档]: https://hyper-magic-window.sothx.com/game-mode.html"
    add_props "# 开启游戏显示布局"
    add_props "ro.config.miui_compat_enable=true"
    add_props "ro.config.miui_appcompat_enable=true"
    ui_print "*********************************************"
  else
    ui_print "*********************************************"
    ui_print "- 跳过游戏显示布局设置，如需重新开启，请卸载模块后重新安装模块。"
    ui_print "*********************************************"
  fi
  # 展示游戏显示布局选择器
  # if [[ $is_need_show_game_mode_select == '1' ]]; then
  #   ui_print "*********************************************"
  #   ui_print "- 是否开启游戏显示布局(仅游戏加速内的游戏生效)"
  #   ui_print "- （Tips: 开启后王者荣耀、CF手游默认会以更宽的视野进行显示）"
  #   ui_print "- Android 15+需要额外安装修改版手机/平板管家才会生效~"
  #   ui_print "- [游戏显示布局使用文档]: https://hyper-magic-window.sothx.com/game-mode.html"
  #   ui_print "  音量+ ：是"
  #   ui_print "  音量- ：否"
  #   ui_print "*********************************************"
  #   key_check
  #   if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
  #     ui_print "*********************************************"
  #     ui_print "- 已开启游戏显示布局(仅游戏加速内的游戏生效)，是否支持以实际机型底层适配为准"
  #     ui_print "- （Tips: 开启后王者荣耀、CF手游默认会以更宽的视野进行显示）"
  #     ui_print "- 详细使用方式请阅读模块文档~"
  #     ui_print "- Android 15+需要额外安装修改版手机/平板管家才会生效~"
  #     ui_print "- [游戏显示布局使用文档]: https://hyper-magic-window.sothx.com/game-mode.html"
  #     add_props "# 开启游戏显示布局"
  #     add_props "ro.config.miui_compat_enable=true"
  #     add_props "ro.config.miui_appcompat_enable=true"
  #     ui_print "*********************************************"
  #   else
  #     ui_print "*********************************************"
  #     ui_print "- 你选择不开启游戏显示布局"
  #     ui_print "*********************************************"
  #   fi
  # fi

fi

# 生成自定义规则模板
is_need_create_custom_config_template=1
if [[ $(grep_prop create_custom_config_template "$MODULE_CUSTOM_CONFIG_PATH/config.prop") == "0" ]]; then
  is_need_create_custom_config_template=0
fi
if [[ $is_need_create_custom_config_template == 1 ]]; then
  ui_print "*********************************************"
  ui_print "- 是否自动生成自定义规则模板？"
  ui_print "- [自定义规则使用文档]: https://hyper-magic-window.sothx.com/custom-config.html"
  ui_print "  音量+ ：是"
  ui_print "  音量- ：否"
  ui_print "*********************************************"
  key_check
  if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
    update_system_prop create_custom_config_template 0 "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    if [[ ! -d "$MODULE_CUSTOM_CONFIG_PATH/config/" ]]; then
      /bin/mkdir -p "$MODULE_CUSTOM_CONFIG_PATH/config/"
    fi
    /bin/cp -rf "$MODPATH/common/template/"* "$MODULE_CUSTOM_CONFIG_PATH/config/"
    /bin/chmod -R 777 "$MODULE_CUSTOM_CONFIG_PATH/config/"
    ui_print "*********************************************"
    ui_print "- 已自动生成自定义规则模板"
    ui_print "- 自定义规则路径位于 $MODULE_CUSTOM_CONFIG_PATH/config/"
    ui_print "- 详细使用方式请阅读模块文档~"
    ui_print "- [自定义规则使用文档]: https://hyper-magic-window.sothx.com/custom-config.html"
    ui_print "*********************************************"
  else
    update_system_prop create_custom_config_template 0 "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    ui_print "*********************************************"
    ui_print "- 你选择不自动生成自定义规则模板"
    ui_print "*********************************************"
  fi
fi

# KSU Web UI
is_need_install_ksu_web_ui=1
if [[ "$KSU" == "true" || "$APATCH" == "true" ]]; then
  is_need_install_ksu_web_ui=0
fi
if [[ $(grep_prop is_need_install_ksu_web_ui "$MODULE_CUSTOM_CONFIG_PATH/config.prop") == "0" ]]; then
  is_need_install_ksu_web_ui=0
fi
if [[ $is_need_install_ksu_web_ui == 1 ]]; then
  ui_print "*********************************************"
  ui_print "- 是否安装KsuWebUI？"
  ui_print "- [重要提醒]: 安装并赋予Root权限可以可视化管理模块提供的部分功能"
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
      abort "- 坏诶，KSUWebUI安装失败，请尝试重新安装！"
    fi
  else
    update_system_prop is_need_install_ksu_web_ui 0 "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    ui_print "*********************************************"
    ui_print "- 你选择不安装KsuWebUI"
    ui_print "*********************************************"
  fi
fi

ui_print "- 好诶w，《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"
