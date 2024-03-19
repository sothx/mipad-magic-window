DIY_CONFIG_EMBEDDED_RULES_LIST="/data/adb/MIUI_MagicWindow+/config/embedded_rules_list.xml"
MODDIR="/data/adb/modules/MIUI_MagicWindow+"

# 读取xml文件内容
xml_content=$(cat $DIY_CONFIG_EMBEDDED_RULES_LIST)

# 使用sed命令提取package子项
package_lines=$(echo "$xml_content" | sed -n '/<package /p')

# 将提取的子项存储到数组中
package_array=()
while IFS= read -r line; do
  package_array+=("$line")
done <<<"$package_lines"

# # 打印数组内容
for item in "${package_array[@]}"; do
    sed -i "/<\/package_config>/ i $item" "$MODDIR/common/product/etc/embedded_rules_list.xml"
done
