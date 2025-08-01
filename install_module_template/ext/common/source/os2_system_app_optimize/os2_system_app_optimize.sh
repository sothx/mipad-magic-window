# shellcheck disable=SC2148
# 系统应用横屏优化
is_disabled_os2_system_app_optimize=$(grep_prop is_disabled_os2_system_app_optimize "$MODULE_CUSTOM_CONFIG_PATH/config.prop")
sothx_project_treble_support_magic_window_fix=$(getprop ro.config.sothx_project_treble_support_magic_window_fix)

if { [ -z "$is_disabled_os2_system_app_optimize" ] || [ "$is_disabled_os2_system_app_optimize" == "null" ] || [ "$is_disabled_os2_system_app_optimize" == "false" ]; } \
   && [ "$sothx_project_treble_support_magic_window_fix" != "true" ]; then
  # 超级小爱
  cmd miui_embedding_window set-appMode com.miui.voiceassist 3
  # 安全服务
  cmd miui_embedding_window set-appMode com.miui.securitycenter 3
  # 小米浏览器
  cmd miui_embedding_window set-appMode com.android.browser 3
fi
