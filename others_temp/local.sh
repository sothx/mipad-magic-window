#!/system/bin/sh

# For Android 12+

# 移除模块文件写保护
echo "- 正在移除《HyperOS For Pad/Fold 完美横屏应用计划》模块文件的写保护……"
chattr -i /data/system/cloudFeature_embedded_rules_list.xml
chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
echo "- 已经移除《HyperOS For Pad/Fold 完美横屏应用计划》模块文件的写保护！"

# 设置SELinux安全上下文
chcon u:object_r:system_file:s0 /data/adb/modules/MIUI_MagicWindow+/common/product/etc/embedded_rules_list.xml
chcon u:object_r:system_file:s0 /data/adb/modules/MIUI_MagicWindow+/common/product/etc/fixed_orientation_list.xml
# 设置平行视界文件权限
chmod 666 /product/etc/embedded_rules_list.xml
chown root:root /product/etc/embedded_rules_list.xml
chmod 666 /data/system/cloudFeature_embedded_rules_list.xml
chown root:root /data/system/cloudFeature_embedded_rules_list.xml
# 为平行视界配置列表写入软链接
mv /data/adb/modules/MIUI_MagicWindow+/common/product/etc/embedded_rules_list.xml /product/etc/embedded_rules_list.xml
cp -l /data/adb/modules/MIUI_MagicWindow+/product/etc/embedded_rules_list.xml /data/adb/modules/MIUI_MagicWindow+/common/product/etc/embedded_rules_list.xml
rm /data/system/cloudFeature_embedded_rules_list.xml
mv /data/adb/modules/MIUI_MagicWindow+/common/product/etc/embedded_rules_list.xml /data/system/cloudFeature_embedded_rules_list.xml
cp -l /data/adb/modules/MIUI_MagicWindow+/product/etc/embedded_rules_list.xml /data/adb/modules/MIUI_MagicWindow+/common/product/etc/embedded_rules_list.xml
# 设置信箱模式文件权限
chmod 666 /product/etc/fixed_orientation_list.xml
chown root:root /product/etc/fixed_orientation_list.xml
chmod 666 /data/system/cloudFeature_fixed_orientation_list.xml
chown root:root /data/system/cloudFeature_fixed_orientation_list.xml
# 为信箱模式配置列表写入软链接
mv /data/adb/modules/MIUI_MagicWindow+/common/product/etc/fixed_orientation_list.xml /product/etc/fixed_orientation_list.xml
cp -l /data/adb/modules/MIUI_MagicWindow+/product/etc/fixed_orientation_list.xml /data/adb/modules/MIUI_MagicWindow+/common/product/etc/fixed_orientation_list.xml
rm /data/system/cloudFeature_fixed_orientation_list.xml
mv /data/adb/modules/MIUI_MagicWindow+/common/product/etc/fixed_orientation_list.xml /data/system/cloudFeature_fixed_orientation_list.xml
cp -l /data/adb/modules/MIUI_MagicWindow+/product/etc/fixed_orientation_list.xml /data/adb/modules/MIUI_MagicWindow+/common/product/etc/fixed_orientation_list.xml
# 禁止平行视界配置文件被云控
chmod 440 /product/etc/embedded_rules_list.xml
chown system /product/etc/embedded_rules_list.xml
chmod 440 /data/system/cloudFeature_embedded_rules_list.xml
chown system /data/system/cloudFeature_embedded_rules_list.xml
# 禁止信箱模式配置文件被云控
chmod 440 /product/etc/fixed_orientation_list.xml
chown system /product/etc/fixed_orientation_list.xml
chmod 440 /data/system/cloudFeature_fixed_orientation_list.xml
chown system /data/system/cloudFeature_fixed_orientation_list.xml
## 对云控文件写保护
chattr +i /data/system/cloudFeature_embedded_rules_list.xml
chattr +i /data/system/cloudFeature_fixed_orientation_list.xml
# 这个脚本将以 post-fs-data 模式执行
# 更多信息请访问 Magisk 主题

echo "- 已经完成《HyperOS For Pad/Fold 完美横屏应用计划》模块云控规则更新！"