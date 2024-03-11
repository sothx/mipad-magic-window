# This is customize the module installation process if you need
SKIPUNZIP=0

# 移除模块文件写保护
chattr -R -i /data/system/cloudFeature_embedded_rules_list.xml
chattr -R -i /data/system/cloudFeature_fixed_orientation_list.xml