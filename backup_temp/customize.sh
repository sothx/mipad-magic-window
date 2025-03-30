# shellcheck disable=SC2148
# shellcheck disable=SC2034

SKIPUNZIP=0
. "$MODPATH"/util_functions.sh
magisk_path=/data/adb/modules/
module_id=$(grep_prop id "$MODPATH/module.prop")
module_versionCode=$(expr "$(grep_prop versionCode "$MODPATH/module.prop")" + 0)
has_been_installed_module_versionCode=$(expr "$(grep_prop versionCode "$magisk_path$module_id/module.prop")" + 0)
MODULE_CUSTOM_CONFIG_PATH="/data/adb/"$module_id

api_level_arch_detect

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

# 基础函数
add_props() {
  local line="$1"
  printf "$line" >>"$MODPATH/system.prop"
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

device_code="$(getprop ro.product.device)"
device_soc_name="$(getprop ro.vendor.qti.soc_name)"
device_soc_model="$(getprop ro.vendor.qti.soc_model)"
device_characteristics="$(getprop ro.build.characteristics)"

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
    add_props "\n# 开启智能I/O调度\n"
    add_props "persist.sys.stability.smartfocusio=on"
    ui_print "*********************************************"
  elif [[ $is_need_smartfocusio == 'off' ]]; then
    ui_print "*********************************************"
    ui_print "- 已启用系统默认I/O调度(Android 14+ 生效)"
    update_system_prop smartfocusio off "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
    add_props "\n# 开启系统默认I/O调度\n"
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
        add_props "\n# 开启智能I/O调度\n"
        add_props "persist.sys.stability.smartfocusio=on"
        ui_print "*********************************************"
      else
        ui_print "*********************************************"
        ui_print "- 已启用系统默认I/O调度(Android 14+ 生效)"
        update_system_prop smartfocusio off "$MODULE_CUSTOM_CONFIG_PATH/config.prop"
        add_props "\n# 开启系统默认I/O调度\n"
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
common_overlay_apk_path="$MODPATH/common/overlay/MiPadSettingsSothxOverlay.apk"
module_overlay_apk_path="$MODPATH/system/product/overlay/MiPadSettingsSothxOverlay.apk"
has_been_installed_module_overlay_apk_path="$magisk_path$module_id/system/product/overlay/MiPadSettingsSothxOverlay.apk"

if [[ "$API" -ge 34 && "$device_characteristics" == 'tablet' ]]; then
  # 判断首次安装
  if [[ ! -d "$magisk_path$module_id" ]]; then
    is_need_settings_overlay=1
  fi
  # 判断老版本模块
  if [[ $has_been_installed_module_versionCode -le 119013 ]]; then
    is_need_settings_overlay=1
  fi
  # 判断是否已启用overlay
  if [[ -f "$has_been_installed_module_overlay_apk_path" && $has_been_installed_module_versionCode -ge 119014 ]]; then
    is_need_settings_overlay=0
    if [[ ! -d "$MODPATH/system/product/overlay/" ]]; then
      mkdir -p "$MODPATH/system/product/overlay/"
    fi
    cp -f "$common_overlay_apk_path" "$module_overlay_apk_path"
    ui_print "*********************************************"
    ui_print "- 已自动嵌入模块优化说明到[设置-平板专区]"
    ui_print "- [重要提醒]:可能与部分隐藏Root、修改系统界面的模块不兼容导致系统界面异常，如不兼容可卸载模块重新安装取消嵌入"
    ui_print "*********************************************"
  fi
  # 展示提示
  if [[ $is_need_settings_overlay == "1" ]]; then
    ui_print "*********************************************"
    ui_print "- 是否嵌入模块优化说明到[设置-平板专区]？"
    ui_print "- [重要提醒]:是否嵌入模块优化说明不会影响模块的实际使用，请自由选择"
    ui_print "- [重要提醒]:可能与部分隐藏Root、修改系统界面的模块不兼容导致系统界面异常，如不兼容可卸载模块重新安装取消嵌入"
    ui_print "  音量+ ：是"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      if [[ ! -d "$MODPATH/system/product/overlay/" ]]; then
        mkdir -p "$MODPATH/system/product/overlay/"
      fi
      cp -f "$common_overlay_apk_path" "$module_overlay_apk_path"
      ui_print "*********************************************"
      ui_print "- 已嵌入模块优化说明到[设置-平板专区]"
      ui_print "- [重要提醒]:可能与部分隐藏Root、修改系统界面的模块不兼容导致系统界面异常，如不兼容可卸载模块重新安装取消嵌入"
      ui_print "*********************************************"
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
fi

# # 修复权限管理服务
# need_fix_auth_manager_pad_list="pipa liuqin yudi yunluo xun"
# is_need_fix_auth_manager=0
# for i in $need_fix_auth_manager_pad_list; do
#   if [[ "$device_code" == "$i" ]]; then
#     is_need_fix_auth_manager=1
#     break
#   fi
# done
# fixAuthManager=$(grep_prop fixAuthManager "$CUSTOM_CONFIG_MODULE_PROP_PATH/config.prop")
# if [[ "$is_need_fix_auth_manager" == 1 && "$API" -eq 34  ]]; then
#   # 未配置，提醒修复
#   if [[ "$fixAuthManager" == "" ]]; then
#     # 判断自定义config.prop是否存在，不存在则生成
#     if [[ ! -f "$CUSTOM_CONFIG_MODULE_PROP_PATH" ]]; then
#         /bin/mkdir -p "$CUSTOM_CONFIG_MODULE_PROP_PATH"
#         /bin/touch "$CUSTOM_CONFIG_MODULE_PROP_PATH/config.prop"
#         /bin/chmod 777 "$CUSTOM_CONFIG_MODULE_PROP_PATH/config.prop"
#     fi
#     ui_print "*********************************************"
#     ui_print "- 是否修复权限管理服务"
#     ui_print "- 可以解决部分机型出现权限请求弹窗会导致横竖屏错乱的问题"
#     ui_print "- (Tips:请自备救砖模块，修复后可能存在卡米风险，仅官方ROM需要修复，移植包机型请选择\"否\")"
#     ui_print "  音量+ ：是"
#     ui_print "  音量- ：否"
#     ui_print "*********************************************"
#     key_check
#     if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
#       printf "fixAuthManager=on\n" >> "$CUSTOM_CONFIG_MODULE_PROP_PATH/config.prop"
#       fix_auth_manager "$MODPATH"
#       ui_print "*********************************************"
#       ui_print "- 已修复权限管理服务，后续不会再提醒修复权限管理服务"
#       ui_print "- 如需取消修复，请前往/data/adb/MIUI_MagicWindow+/config/config.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#       ui_print "*********************************************"
#     else
#       printf "fixAuthManager=off\n" >> "$CUSTOM_CONFIG_MODULE_PROP_PATH/config.prop"
#       ui_print "*********************************************"
#       ui_print "- 你选择不修复权限管理服务，后续不会再提醒修复权限管理服务"
#       ui_print "- 如需再次提醒，请前往/data/adb/MIUI_MagicWindow+/config/config.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#       ui_print "*********************************************"
#     fi
#   fi
#   # 已选择修复权限管理服务，自动修复
#   if [[ "$fixAuthManager" == "on" ]]; then
#     fix_auth_manager "$MODPATH"
#     ui_print "*********************************************"
#     ui_print "- 自动修复权限管理服务"
#     ui_print "- 如需取消修复，请前往/data/adb/MIUI_MagicWindow+/config/config.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#     ui_print "*********************************************"
#   fi
#   # 已选择不修复权限管理服务，仅提醒
#   if [[ "$fixAuthManager" == "off" ]]; then
#     ui_print "*********************************************"
#     ui_print "- 不修复权限管理服务"
#     ui_print "- 如需再次提醒，请前往/data/adb/MIUI_MagicWindow+/config/config.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#     ui_print "*********************************************"
#   fi
# fi

ui_print "- 好诶w，《HyperOS 完美横屏应用计划》安装/更新完成，重启系统后生效！"
