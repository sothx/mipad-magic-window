# 这个脚本会在删除模块的时候执行
MODDIR=${0%/*}

# 对模块解除写保护
chattr -R -i /data/adb/modules/MIUI_MagicWindow+

# For Android 11
# 兼容部分移植包的修改
chattr -i /data/system/users/0/magic_window_setting_config.xml
chattr -i /data/system/magicWindowFeature_magic_window_application_list.xml
# 直接删除A11配置文件，重启后系统会自动重新生成
rm /data/system/users/0/magic_window_setting_config.xml
rm /data/system/magicWindowFeature_magic_window_application_list.xml

# For Android 12+
# 对云控文件解除写保护
chattr -i /data/system/cloudFeature_embedded_rules_list.xml
chattr -i /product/etc/embedded_rules_list.xml
chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
chattr -i /product/etc/fixed_orientation_list.xml
## 兼容原作者
chattr -i /data/system/users/0/embedded_setting_config.xml

# 设置SELinux安全上下文
chcon u:object_r:system_file:s0 $MODDIR/common/product/etc/embedded_rules_list.xml
chcon u:object_r:system_file:s0 $MODDIR/common/product/etc/fixed_orientation_list.xml

# 移动平行视界相关备份文件
rm /product/etc/embedded_rules_list.xml
cp $MODDIR/common/product/etc/embedded_rules_list_bak /product/etc/embedded_rules_list.xml
rm /data/system/cloudFeature_embedded_rules_list.xml
cp $MODDIR/common/product/etc/embedded_rules_list_bak /data/system/cloudFeature_embedded_rules_list.xml
# 重置平行视界默认配置文件
rm /data/system/users/0/embedded_setting_config.xml
# 移动信箱模式相关备份文件
rm /product/etc/fixed_orientation_list.xml
cp $MODDIR/common/product/etc/fixed_orientation_list_bak /product/etc/fixed_orientation_list.xml
rm /data/system/cloudFeature_fixed_orientation_list.xml
cp $MODDIR/common/product/etc/fixed_orientation_list_bak /data/system/cloudFeature_fixed_orientation_list.xml

