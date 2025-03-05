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

# 鼠标光标样式
is_auto_start_miui_cursor_style_type=$(grep_prop is_auto_start_miui_cursor_style_type "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$miui_cursor_style_type" != "null" ] && [ -n "$miui_cursor_style_type" ]; then
  settings put system miui_cursor_style "$is_auto_start_miui_cursor_style_type"
fi

# 强制启用FBO
is_auto_enable_fbo=$(grep_prop is_auto_enable_fbo "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_auto_enable_fbo" != "null" ] && [ -n "$is_auto_enable_fbo" ]; then
  setprop persist.sys.stability.miui_fbo_enable true
fi