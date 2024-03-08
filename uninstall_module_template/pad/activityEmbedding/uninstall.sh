# 这个脚本会在删除模块的时候执行
MODDIR=${0%/*}

# Remove Files
rm /data/system/users/0/magic_window_setting_config.xml
rm /data/system/magicWindowFeature_magic_window_application_list.xml

# Move Back Files
rm /product/etc/embedded_rules_list.xml
cp $MODDIR/common/product/etc/embedded_rules_list_bak /product/etc/embedded_rules_list.xml
rm /data/system/cloudFeature_embedded_rules_list.xml
cp $MODDIR/common/product/etc/embedded_rules_list_bak /data/system/cloudFeature_embedded_rules_list.xml
rm /data/system/users/0/embedded_setting_config.xml

rm /product/etc/fixed_orientation_list.xml
cp $MODDIR/common/product/etc/fixed_orientation_list_bak /product/etc/fixed_orientation_list.xml
rm /data/system/cloudFeature_fixed_orientation_list.xml
cp $MODDIR/common/product/etc/fixed_orientation_list_bak /data/system/cloudFeature_fixed_orientation_list.xml

# Enable Cloud Feature
# chmod 660 /product/etc/embedded_rules_list.xml
# chown system /product/etc/embedded_rules_list.xml
# chmod 660 /data/system/cloudFeature_embedded_rules_list.xml
# chown system /data/system/cloudFeature_embedded_rules_list.xml
# chmod 660 /data/system/users/0/embedded_setting_config.xml
# chown system /data/system/users/0/embedded_setting_config.xml