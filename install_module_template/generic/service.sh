# shellcheck disable=SC2148,SC1091,SC2086,SC2034,SC2154,SC2004
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
is_amktiao_pen_update_auto_task=$(grep_prop is_amktiao_pen_update_auto_task "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_amktiao_pen_enable" = 'true' ]; then
  echo 1 > /sys/touchpanel/pen_enable
fi

if [ "$is_amktiao_pen_update" = 'true' ]; then
  echo 1 > /sys/touchpanel/pen_update
fi

if [[ "$is_amktiao_pen_update_auto_task" = 'true' && "$is_amktiao_pen_update" = 'true' ]]; then
  wake_status=$(dumpsys power | grep -oP "mWakefulness=\K\w+")
  if [ "$wake_status" = "Awake" ]; then
    input keyevent KEYCODE_POWER && sleep 1 && input keyevent KEYCODE_POWER
  fi
fi

# 通知图标最大数量
is_enable_show_notification_icon_num=$(grep_prop is_enable_show_notification_icon_num "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
show_notification_icon_num=$(grep_prop show_notification_icon_num "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_enable_status_bar_show_notification_icon" = 'true' ]; then
  settings put system status_bar_show_notification_icon $show_notification_icon_num
fi

# 刷新率与分辨率开机自启动
display_mode_record_auto_enable_id=$(grep_prop display_mode_record_auto_enable_id "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
if [ "$display_mode_record_auto_enable_id" != "null" ] && [ -n "$display_mode_record_auto_enable_id" ]; then
  adjusted_id=$(($display_mode_record_auto_enable_id - 1))
  service call SurfaceFlinger 1035 i32 "$adjusted_id"
fi

# 磁盘IO调度策略自启动
auto_setting_io_scheduler=$(grep_prop auto_setting_io_scheduler "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
if [ "$auto_setting_io_scheduler" != "null" ] && [ -n "$auto_setting_io_scheduler" ]; then
  echo "$auto_setting_io_scheduler" > /sys/block/sda/queue/scheduler
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

# FBO 每日闲时维护
is_auto_regularly_fbo=$(grep_prop is_auto_regularly_fbo "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ "$is_auto_regularly_fbo" != "null" ] && [ -n "$is_auto_regularly_fbo" ]; then
  fbo_regularly_dir_path="$MODDIR/common/source/fbo_regularly/fbo_regularly.d"
  source "$MODDIR"/common/source/fbo_regularly/fbo_regularly_action.sh
  # 执行 kill_fbo_regularly_dir_crond 以避免重复进程
  kill_fbo_regularly_dir_crond

  # 获取 crond 命令路径并执行
  crond_cmd=$(get_crond)
  $crond_cmd -c "$fbo_regularly_dir_path"
fi