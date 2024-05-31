# shellcheck disable=SC2148
# shellcheck disable=SC2034
SKIPUNZIP=0
. "$MODPATH"/util_functions.sh
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+/"
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

# 初始化模块配置目录
if [[ ! -d "$MODULE_CUSTOM_CONFIG_PATH" ]]; then
   /bin/mkdir -p $MODULE_CUSTOM_CONFIG_PATH
   if [[ ! -f "$MODULE_CUSTOM_CONFIG_PATH"config.prop ]];then
    /bin/touch "$MODULE_CUSTOM_CONFIG_PATH"config.prop
    /bin/chmod 777 "$MODULE_CUSTOM_CONFIG_PATH"config.prop
   fi
fi


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

# 生成自定义规则模板
is_need_create_custom_config_template=1
if [[ $(grep_prop create_custom_config_template "$MODULE_CUSTOM_CONFIG_PATH"config.prop) == "0" ]];then
  is_need_create_custom_config_template=0
fi
if [[ $is_need_create_custom_config_template == 1  ]];then
  ui_print "*********************************************"
  ui_print "- 是否自动生成自定义规则模板？"
  ui_print "- [自定义规则使用文档]: https://hyper-magic-window.sothx.com/custom-config.html"
  ui_print "  音量+ ：是"
  ui_print "  音量- ：否"
  ui_print "*********************************************"
  key_check
  if [[ "$keycheck" == "KEY_VOLUMEUP" ]];then
    if [[  !$(grep_prop create_custom_config_template "$MODULE_CUSTOM_CONFIG_PATH"config.prop) ]];then
       printf "create_custom_config_template=0\n" >>"$MODULE_CUSTOM_CONFIG_PATH"config.prop
    fi
    if [[ ! -f $MODULE_CUSTOM_CONFIG_PATH"config/" ]]; then
      /bin/mkdir -p "$MODULE_CUSTOM_CONFIG_PATH"config/
    fi
    /bin/cp -rf "$MODPATH"/common/template/* "$MODULE_CUSTOM_CONFIG_PATH"config/
    /bin/chmod -R 777 "$MODULE_CUSTOM_CONFIG_PATH"config/
    ui_print "*********************************************"
    ui_print "- 已自动生成自定义规则模板"
    ui_print "- 自定义规则路径位于"$MODULE_CUSTOM_CONFIG_PATH"config/"
    ui_print "- 详细使用方式请阅读模块文档~"
    ui_print "- [自定义规则使用文档]: https://hyper-magic-window.sothx.com/custom-config.html"
    ui_print "*********************************************"
  else
    if [[  !$(grep_prop create_custom_config_template "$MODULE_CUSTOM_CONFIG_PATH"config.prop) ]];then
       printf "create_custom_config_template=0\n" >>"$MODULE_CUSTOM_CONFIG_PATH"config.prop
    fi
    ui_print "*********************************************"
    ui_print "- 你选择不自动生成自定义规则模板"
    ui_print "*********************************************"
  fi
fi


ui_print "- 好诶w，《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"
