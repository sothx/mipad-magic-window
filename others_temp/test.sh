
DIY_CONFIG_EMBEDDED_RULES_LIST="/data/adb/MIUI_MagicWindow+/config/embedded_rules_list.xml"

packages=$(awk 'BEGIN{RS="<package_config>|</package_config>"} /<package/{print}' $DIY_CONFIG_EMBEDDED_RULES_LIST)

echo "$packages"
