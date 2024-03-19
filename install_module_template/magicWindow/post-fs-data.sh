#!/system/bin/sh
# 请不要硬编码 /magisk/modname/... ; 请使用 $MODDIR/...
# 这将使你的脚本更加兼容，即使Magisk在未来改变了它的挂载点
MODDIR=${0%/*}
# 对云控文件解除写保护
chattr -i /data/system/users/0/magic_window_setting_config.xml
chattr -i /data/system/magicWindowFeature_magic_window_application_list.xml
# For Android 11
cp -f $MODDIR/common/system/users/0/magic_window_setting_config.xml /data/system/users/0/magic_window_setting_config.xml
cp -f $MODDIR/common/system/magicWindowFeature_magic_window_application_list.xml /data/system/magicWindowFeature_magic_window_application_list.xml
## 对云控文件写保护
chattr +i /data/system/users/0/magic_window_setting_config.xml
chattr +i /data/system/magicWindowFeature_magic_window_application_list.xml
# 这个脚本将以 post-fs-data 模式执行
# 更多信息请访问 Magisk 主题
