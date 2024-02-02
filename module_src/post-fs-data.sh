#!/system/bin/sh
# 请不要硬编码 /magisk/modname/... ; 请使用 $MODDIR/...
# 这将使你的脚本更加兼容，即使Magisk在未来改变了它的挂载点
MODDIR=${0%/*}

chcon u:object_r:system_file:s0 $MODDIR/common/product/etc/embedded_rules_list.xml

#chattr -i /data/system/cloudFeature_embedded_rules_list.xml
#chattr -i /product/etc/embedded_rules_list.xml
#chattr -i /data/system/users/0/embedded_setting_config.xml

# For Android 11
cp $MODDIR/common/system/users/0/magic_window_setting_config.xml /data/system/users/0/magic_window_setting_config.xml
cp $MODDIR/common/system/magicWindowFeature_magic_window_application_list.xml /data/system/magicWindowFeature_magic_window_application_list.xml

# For Android 12/Android13 By:醋腌老编
chmod 666 /product/etc/embedded_rules_list.xml
chown root:root /product/etc/embedded_rules_list.xml
chmod 666 /data/system/cloudFeature_embedded_rules_list.xml
chown root:root /data/system/cloudFeature_embedded_rules_list.xml

mv $MODDIR/common/product/etc/embedded_rules_list.xml /product/etc/embedded_rules_list.xml
cp -l $MODDIR/product/etc/embedded_rules_list.xml $MODDIR/common/product/etc/embedded_rules_list.xml
rm /data/system/cloudFeature_embedded_rules_list.xml 
mv $MODDIR/common/product/etc/embedded_rules_list.xml /data/system/cloudFeature_embedded_rules_list.xml
cp -l $MODDIR/product/etc/embedded_rules_list.xml $MODDIR/common/product/etc/embedded_rules_list.xml

# For Android 12
rm /data/system/users/0/embedded_setting_config.xml
cp -l $MODDIR/common/system/users/0/embedded_setting_config.xml /data/system/users/0/embedded_setting_config.xml

# Disable Cloud Feature
chmod 440 /product/etc/embedded_rules_list.xml
chown system /product/etc/embedded_rules_list.xml
chmod 440 /data/system/cloudFeature_embedded_rules_list.xml
chown system /data/system/cloudFeature_embedded_rules_list.xml
chmod 440 /data/system/users/0/embedded_setting_config.xml
chown system /data/system/users/0/embedded_setting_config.xml

# chattr +i /data/system/cloudFeature_embedded_rules_list.xml
# chattr +i /product/etc/embedded_rules_list.xml
# chattr +i /data/system/users/0/embedded_setting_config.xml
# 这个脚本将以 post-fs-data 模式执行
# 更多信息请访问 Magisk 主题
