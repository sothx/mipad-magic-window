MODDIR=${0%/*}
. "$MODDIR"/util_functions.sh
api_level_arch_detect
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+"
wait_login() {
  while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
  done

  while [ ! -d "/sdcard/Android" ]; do
    sleep 1
  done

}

wait_login
. "$MODDIR"/util_functions.sh

# 准备环境
mkdir -p $MODDIR/common/temp

# 系统应用横屏优化
. "$MODDIR"/common/source/os2_system_app_optimize/os2_system_app_optimize.sh

# 水龙移植包相关方法
is_amktiao_pen_enable=$(grep_prop is_amktiao_pen_enable "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
is_amktiao_pen_update=$(grep_prop is_amktiao_pen_update "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_amktiao_pen_enable" = 'true' ]; then
  echo 1 > /sys/touchpanel/pen_enable
fi

if [ "$is_amktiao_pen_update" = 'true' ]; then
  echo 1 > /sys/touchpanel/pen_update
fi

# 通知图标最大数量
is_enable_show_notification_icon_num=$(grep_prop is_enable_show_notification_icon_num "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
show_notification_icon_num=$(grep_prop show_notification_icon_num "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_enable_status_bar_show_notification_icon" = 'true' ]; then
  settings put system status_bar_show_notification_icon $show_notification_icon_num
fi

# 工作台模式
is_add_miui_desktop_mode_enabled=$(grep_prop ro.config.miui_desktop_mode_enabled "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_module_miui_desktop_mode_enabled" = 'true' ]; then
  ro.config.miui_desktop_mode_enabled=true
fi

# 隐藏手势提示线
is_hide_gesture_line=$(grep_prop is_hide_gesture_line "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_hide_gesture_line" = 'true' ]; then
  settings put global hide_gesture_line 1
fi