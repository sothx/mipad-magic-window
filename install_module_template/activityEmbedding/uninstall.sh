# 这个脚本会在删除模块的时候执行
# 请不要硬编码 /magisk/modname/... ; 请使用 $MODDIR/...
# 这将使你的脚本更加兼容，即使Magisk在未来改变了它的挂载点
MODDIR=${0%/*}

# Enable Cloud Feature By:@Andrower
chattr -R -i /data/adb/modules/MIUI_MagicWindow+
chattr -R -i /data/system/cloudFeature_embedded_rules_list.xml
chattr -R -i /product/etc/embedded_rules_list.xml
chattr -R -i /data/system/users/0/embedded_setting_config.xml
# Enable Cloud Feature FixedOrientation By:@做梦书
chattr -R -i /data/system/cloudFeature_fixed_orientation_list.xml
chattr -R -i /product/etc/fixed_orientation_list.xml

chcon u:object_r:system_file:s0 $MODDIR/common/product/etc/embedded_rules_list.xml
# Enable FixedOrientation Auth By:@做梦书
chcon u:object_r:system_file:s0 $MODDIR/common/product/etc/fixed_orientation_list.xml

# Remove Files
# rm /data/system/users/0/magic_window_setting_config.xml
# rm /data/system/magicWindowFeature_magic_window_application_list.xml

# Move Back Files
rm /product/etc/embedded_rules_list.xml
cp $MODDIR/common/product/etc/embedded_rules_list_bak /product/etc/embedded_rules_list.xml
rm /data/system/cloudFeature_embedded_rules_list.xml
cp $MODDIR/common/product/etc/embedded_rules_list_bak /data/system/cloudFeature_embedded_rules_list.xml
rm /data/system/users/0/embedded_setting_config.xml
# Move Back Files FixedOrientation By:@做梦书
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