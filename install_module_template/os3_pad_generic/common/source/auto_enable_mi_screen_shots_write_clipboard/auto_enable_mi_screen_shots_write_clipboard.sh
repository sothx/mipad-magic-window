# shellcheck disable=SC2148
# 截图自动添加至剪贴板
is_auto_enable_mi_screen_shots_write_clipboard=$(grep_prop is_auto_enable_mi_screen_shots_write_clipboard "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
mi_screen_shots_write_clipboard_enable=$(settings get secure mi_screen_shots_write_clipboard_enable)

if [ "$is_auto_enable_mi_screen_shots_write_clipboard" = "true" ] && [ "$mi_screen_shots_write_clipboard_enable" = "0" ]; then
    (
        sleep 30
        settings put secure mi_screen_shots_write_clipboard_enable 1
    ) &
fi