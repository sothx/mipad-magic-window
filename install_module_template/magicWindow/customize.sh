# This is customize the module installation process if you need
SKIPUNZIP=0

# 移除模块文件写保护
ui_print "- 正在移除《HyperOS For Pad/Fold 完美横屏应用计划》模块文件的写保护……"
# 对云控文件解除写保护
chattr -R -i /data/adb/modules/MIUI_MagicWindow+
chattr -i /data/system/users/0/magic_window_setting_config.xml
chattr -i /data/system/magicWindowFeature_magic_window_application_list.xml
# 兼容原作者
chattr -i /data/system/cloudFeature_embedded_rules_list.xml
chattr -i /product/etc/embedded_rules_list.xml
chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
chattr -i /product/etc/fixed_orientation_list.xml
chattr -i /data/system/users/0/embedded_setting_config.xml
ui_print "- 已经移除《HyperOS For Pad/Fold 完美横屏应用计划》模块文件的写保护！"
ui_print "- 《HyperOS For Pad/Fold 完美横屏应用计划》安装/更新完成，重启系统后生效！"