# shellcheck disable=SC2148
# shellcheck disable=SC2034
SKIPUNZIP=0
. "$MODPATH"/util_functions.sh
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
  echo "$line" >>"$MODPATH"/system.prop
}

model="$(getprop ro.product.device)"
device_soc=
soc_SM8475_pad_list="liuqin yudi zizhan"
for j in $soc_SM8475_pad_list; do
  if [[ "$model" == "$j" ]]; then
    device_soc=SM8475
    break
  fi
done

# 骁龙8+Gen1机型判断
if [[ "$device_soc" == "SM8475" && "$API" -ge 34 ]]; then
  ui_print "*********************************************"
  ui_print "- 检测到你的设备处理器属于骁龙8+Gen1"
  ui_print "- 目前骁龙8+Gen1机型的小米平板存在系统IO调度异常的问题，容易导致系统卡顿或者无响应，模块即将自动为你配置合适的IO调度规则"
  # 开启智能IO调度
  ui_print "- 已开启智能IO调度(Android 14+ 生效)"
  add_props "# 开启智能IO调度"
  add_props "persist.sys.stability.smartfocusio=on"
  ui_print "*********************************************"
fi

ui_print "- 好诶w，《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"
