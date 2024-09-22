# shellcheck disable=SC2148
# shellcheck disable=SC2034

SKIPUNZIP=0
. "$MODPATH"/util_functions.sh
if [ -f "$MODPATH"/verify_funcrtion.sh ];then
. "$MODPATH"/verify_funcrtion.sh
fi
magisk_path=/data/adb/modules/
module_id=$(grep_prop id "$MODPATH/module.prop")
module_versionCode=$(expr "$(grep_prop versionCode "$MODPATH/module.prop")" + 0)
has_been_installed_module_versionCode=$(expr "$(grep_prop versionCode "$magisk_path$module_id/module.prop")" + 0)
MODULE_CUSTOM_CONFIG_PATH="/data/adb/"$module_id

api_level_arch_detect

if type verify_android_api_has_pass &>/dev/null; then
  verify_android_api_has_pass $API
fi

if [[ "$KSU" == "true" ]]; then
  ui_print "- KernelSU 用户空间当前的版本号: $KSU_VER_CODE"
  ui_print "- KernelSU 内核空间当前的版本号: $KSU_KERNEL_VER_CODE"
else
  ui_print "- Magisk 版本: $MAGISK_VER_CODE"
  if [ "$MAGISK_VER_CODE" -lt 26000 ]; then
    ui_print "*********************************************"
    ui_print "! 请安装 Magisk 26.0+"
    abort "*********************************************"
  fi
fi

# 重置缓存
rm -rf /data/system/package_cache
rm -rf /data/resource-cache

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
# 生成重载规则脚本
/bin/cp -rf "$MODPATH/common/source/update_rule/"* "$MODULE_CUSTOM_CONFIG_PATH/config/"
# 生成定向重载规则脚本
if [[ ! -f "$MODULE_CUSTOM_CONFIG_PATH/config/service_shell.sh" ]];then
/bin/cp -rf "$MODPATH/common/source/service_shell/"* "$MODULE_CUSTOM_CONFIG_PATH/config/"
fi

# 判断MIUI14专版
if type verify_miui_based_on_tiramisu_pass &>/dev/null; then
  verify_miui_based_on_tiramisu_pass
fi

# 文件夹赋权
/bin/chmod -R 777 "$MODULE_CUSTOM_CONFIG_PATH/config/"

device_code="$(getprop ro.product.device)"
device_soc_name="$(getprop ro.vendor.qti.soc_name)"
device_soc_model="$(getprop ro.vendor.qti.soc_model)"
device_characteristics="$(getprop ro.build.characteristics)"

# 导入MIUI Embedded Activity Window 服务
if [[ -d "$MODPATH/common/source/miui_embedding_window_service/$API/" ]];then
  # 目录不存在则创建目录
  if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
  /bin/mkdir -p "$MODPATH/system/system_ext/framework"
  fi
  # 复制文件并写入权限
  /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/$API/"* "$MODPATH/system/system_ext/framework/"
  /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
fi

## 导入MIUI Auoto UI 服务
if [[ -d "$MODPATH/common/source/miui_autoui_service/$API/" ]];then
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

has_been_enabled_game_mode=$(grep_prop ro.config.miui_appcompat_enable "$magisk_path$module_id/system.prop")
is_need_show_game_mode_select=0
# 游戏显示布局
if [[ "$API" -ge 33 ]]; then
  # 判断首次安装
  if [[ ! -d "$magisk_path$module_id" ]]; then
    is_need_show_game_mode_select=1
  fi
  # 判断老版本模块
  if [[ $has_been_installed_module_versionCode -le 119041 ]]; then
    is_need_show_game_mode_select=1
  fi
  # 判断已开启游戏显示布局
  if [[ $has_been_enabled_game_mode == 'true' && $is_need_show_game_mode_select == "0" ]]; then
    ui_print "*********************************************"
    ui_print "- 已开启游戏显示布局(仅游戏加速内的游戏生效)，是否支持以实际机型底层适配为准"
    ui_print "- （Tips: 开启后王者荣耀、CF手游默认会以更宽的视野进行显示）"
    ui_print "- 详细使用方式请阅读模块文档~"
    ui_print "- [游戏显示布局使用文档]: https://hyper-magic-window.sothx.com/game-mode.html"
    add_props "# 开启游戏显示布局"
    add_props "ro.config.miui_compat_enable=true"
    add_props "ro.config.miui_appcompat_enable=true"
    ui_print "*********************************************"
  fi
  # 展示游戏显示布局选择器
  if [[ $is_need_show_game_mode_select == '1' ]]; then
    ui_print "*********************************************"
    ui_print "- 是否开启游戏显示布局(仅游戏加速内的游戏生效)"
    ui_print "- （Tips: 开启后王者荣耀、CF手游默认会以更宽的视野进行显示）"
    ui_print "- [游戏显示布局使用文档]: https://hyper-magic-window.sothx.com/game-mode.html"
    ui_print "  音量+ ：是"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "*********************************************"
      ui_print "- 已开启游戏显示布局(仅游戏加速内的游戏生效)，是否支持以实际机型底层适配为准"
      ui_print "- （Tips: 开启后王者荣耀、CF手游默认会以更宽的视野进行显示）"
      ui_print "- 详细使用方式请阅读模块文档~"
      ui_print "- [游戏显示布局使用文档]: https://hyper-magic-window.sothx.com/game-mode.html"
      add_props "# 开启游戏显示布局"
      add_props "ro.config.miui_compat_enable=true"
      add_props "ro.config.miui_appcompat_enable=true"
      ui_print "*********************************************"
    else
      ui_print "*********************************************"
      ui_print "- 你选择不开启游戏显示布局"
      ui_print "*********************************************"
    fi
  fi

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

ui_print "- 好诶w，《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"
