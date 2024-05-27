# shellcheck disable=SC2148
# shellcheck disable=SC2034
SKIPUNZIP=0
. "$MODPATH"/util_functions.sh
CUSTOM_CONFIG_MODULE_PROP_PATH="/data/adb/MIUI_MagicWindow+/config/"
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
  printf "$line" >>"$MODPATH"/system.prop
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


device_code="$(getprop ro.product.device)"
device_soc_name="$(getprop ro.vendor.qti.soc_name)"
device_soc_model="$(getprop ro.vendor.qti.soc_model)"

# 骁龙8+Gen1机型判断
if [[ "$device_soc_model" == "SM8475" && "$device_soc_name" == "cape" && "$API" -ge 34 ]]; then
  ui_print "*********************************************"
  ui_print "- 检测到你的设备处理器属于骁龙8+Gen1"
  ui_print "- 目前骁龙8+Gen1机型的小米平板存在系统IO调度异常的问题，容易导致系统卡顿或者无响应，模块将自动为你配置合适的IO调度规则"
  # 开启智能IO调度
  ui_print "- 已开启智能IO调度(Android 14+ 生效)"
  add_props "\n# 开启智能IO调度\n"
  add_props "persist.sys.stability.smartfocusio=on"
  ui_print "*********************************************"
fi


# 移除权限管理服务的修复配置
if [[  -f "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop ]];then
  rm -rf "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
fi


# 修复权限管理服务
# need_fix_auth_manager_pad_list="pipa liuqin yudi yunluo xun"
# is_need_fix_auth_manager=0
# for i in $need_fix_auth_manager_pad_list; do
#   if [[ "$device_code" == "$i" ]]; then
#     is_need_fix_auth_manager=1
#     break
#   fi
# done
# fixAuthManager=$(grep_prop fixAuthManager "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop)
# if [[ "$is_need_fix_auth_manager" == 1 && "$API" -eq 34  ]]; then
#   # 未配置，提醒修复
#   if [[ "$fixAuthManager" == "" ]]; then
#     # 判断自定义module.prop是否存在，不存在则生成
#     if [[ ! -f "$CUSTOM_CONFIG_MODULE_PROP_PATH" ]]; then
#         /bin/mkdir -p $CUSTOM_CONFIG_MODULE_PROP_PATH
#         /bin/touch "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
#         /bin/chmod 777 "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
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
#       printf "fixAuthManager=on\n" >> "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
#       fix_auth_manager $MODPATH
#       ui_print "*********************************************"
#       ui_print "- 已修复权限管理服务，后续不会再提醒修复权限管理服务"
#       ui_print "- 如需取消修复，请前往/data/adb/MIUI_MagicWindow+/config/module.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#       ui_print "*********************************************"
#     else
#       printf "fixAuthManager=off\n" >> "$CUSTOM_CONFIG_MODULE_PROP_PATH"module.prop
#       ui_print "*********************************************"
#       ui_print "- 你选择不修复权限管理服务，后续不会再提醒修复权限管理服务"
#       ui_print "- 如需再次提醒，请前往/data/adb/MIUI_MagicWindow+/config/module.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#       ui_print "*********************************************"
#     fi
#   fi
#   # 已选择修复权限管理服务，自动修复
#   if [[ "$fixAuthManager" == "on" ]]; then
#     fix_auth_manager $MODPATH
#     ui_print "*********************************************"
#     ui_print "- 自动修复权限管理服务"
#     ui_print "- 如需取消修复，请前往/data/adb/MIUI_MagicWindow+/config/module.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#     ui_print "*********************************************"
#   fi
#   # 已选择不修复权限管理服务，仅提醒
#   if [[ "$fixAuthManager" == "off" ]]; then
#     ui_print "*********************************************"
#     ui_print "- 不修复权限管理服务"
#     ui_print "- 如需再次提醒，请前往/data/adb/MIUI_MagicWindow+/config/module.prop文件下，将fixAuthManager整行删除并重新安装模块会再次提醒。"
#     ui_print "*********************************************"
#   fi
# fi

ui_print "- 好诶w，《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"
