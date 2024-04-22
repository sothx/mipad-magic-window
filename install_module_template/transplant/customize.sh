# shellcheck disable=SC2148
# shellcheck disable=SC2034
SKIPUNZIP=0
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

# 特殊版本模块提醒
ui_print "*********************************************"
ui_print "- 是否知悉此模块仅适合基于 Xiaomi Pad 6 Max 的 MIUI14 For Pad 移植包？（刷错会卡米）"
ui_print "- 是否了解后续如果更换其他移植包ROM，需要先卸载本模块？"
ui_print "  音量+ ：是"
ui_print "  音量- ：否"
ui_print "*********************************************"
key_check
if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
  ui_print "- 好诶，你已确认模块的安全警告，即将为你安装模块！"
  ui_print "- 《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"
else
  abort "- 《HyperOS For Pad/Fold 完美横屏应用计划》安装失败，请重新寻找合适的模块版本！"
fi
