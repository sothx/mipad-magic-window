# 系统应用横屏优化
is_disabled_os2_system_app_optimize=$(grep_prop is_disabled_os2_system_app_optimize "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

if [ -z "$is_disabled_os2_system_app_optimize" ] || [ "$is_disabled_os2_system_app_optimize" == "null" ] || [ "$is_disabled_os2_system_app_optimize" == "false" ]; then
  # # 超级小爱
  # cmd miui_embedding_window set-appMode com.miui.voiceassist 3
  # # 安全服务
  # cmd miui_embedding_window set-appMode com.miui.securitycenter 3
  # # 小米浏览器
  # cmd miui_embedding_window set-appMode com.android.browser 3
fi