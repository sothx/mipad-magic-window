# 这个脚本会在删除模块的时候执行
# 请不要硬编码 /magisk/modname/... ; 请使用 $MODDIR/...
# 这将使你的脚本更加兼容，即使Magisk在未来改变了它的挂载点
MODDIR=${0%/*}

# For Android 11
# 对云控文件解除写保护
chattr -R -i /data/adb/modules/MIUI_MagicWindow+
# 直接删除A11配置文件，重启后系统会自动重新生成
rm /data/system/users/0/magic_window_setting_config.xml
rm /data/system/magicWindowFeature_magic_window_application_list.xml
