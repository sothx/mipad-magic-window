# shellcheck disable=SC2148,SC1091
MODDIR="/data/adb/modules/Hyper_MagicWindow"
# 系统应用横屏优化
is_disabled_os2_system_app_optimize=$(grep_prop is_disabled_os2_system_app_optimize "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
sothx_project_treble_support_magic_window_fix=$(getprop ro.config.sothx_project_treble_support_magic_window_fix)
mi_os_version_name=$(grep_prop ro.mi.os.version.code /mi_ext/etc/build.prop)

if { [ -z "$is_disabled_os2_system_app_optimize" ] || [ "$is_disabled_os2_system_app_optimize" = "null" ] || [ "$is_disabled_os2_system_app_optimize" = "false" ]; } \
   && [ "$sothx_project_treble_support_magic_window_fix" != "true" ] \
   && [ "$mi_os_version_name" = "2" ]; then
  # 超级小爱
  cmd miui_embedding_window set-appMode com.miui.voiceassist 3
  # 安全服务
  cmd miui_embedding_window set-appMode com.miui.securitycenter 3
  # 小米浏览器
  cmd miui_embedding_window set-appMode com.android.browser 3
fi


if [[ -f "$MODDIR"/common/source/auto_enable_mi_screen_shots_write_clipboard/auto_enable_mi_screen_shots_write_clipboard.sh ]]; then
  . "$MODDIR"/common/source/auto_enable_mi_screen_shots_write_clipboard/auto_enable_mi_screen_shots_write_clipboard.sh
fi