DIY_CONFIG_EMBEDDED_RULES_LIST="/data/adb/MIUI_MagicWindow+/Conf/embedded_rules_list.xml"
DIY_CONFIG_FIXED_ORIENTATION_LIST="/data/adb/MIUI_MagicWindow+/Conf/fixed_orientation_list.xml"


# 对云控文件解除写保护
chattr -i /data/system/cloudFeature_embedded_rules_list.xml
chattr -i /data/system/cloudFeature_fixed_orientation_list.xml

# 支持自定义配置
cp -f $MODDIR/common/product/etc/source/embedded_rules_list.xml $MODDIR/common/product/etc/embedded_rules_list.xml
if [ -f $DIY_CONFIG_EMBEDDED_RULES_LIST ]; then
    cp -f $MODDIR/common/product/etc/source/embedded_rules_list.xml $MODDIR/common/product/etc/embedded_rules_list.xml

    packages=$(awk '/<package /{print}' "$DIY_CONFIG_EMBEDDED_RULES_LIST")
    
    echo "$packages" | while IFS= read -r package; do
        sed -i "/<\/package_config>/ i $package" "$MODDIR/common/product/etc/embedded_rules_list.xml"
    done
fi
