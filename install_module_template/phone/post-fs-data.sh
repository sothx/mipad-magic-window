# shellcheck disable=SC2148,SC1091,SC2235,SC2034

MODDIR=${0%/*}
MODULE_CUSTOM_CONFIG_PATH="/data/adb/Hyper_MagicWindow"
. "$MODDIR"/util_functions.sh
api_level_arch_detect

if [[ ! -d "$MODDIR/common/temp" ]]; then
  /bin/mkdir -p "$MODDIR/common/temp"
fi
# 获取ROOT管理器信息并写入

echo "$KSU,$KSU_VER,$KSU_VER_CODE,$KSU_KERNEL_VER_CODE,$APATCH,$APATCH_VER_CODE,$APATCH_VER,$MAGISK_VER,$MAGISK_VER_CODE" >"$MODPATH/common/temp/root_manager_info.txt"

# 自定义配置文件
# Android 15 +
CUSTOM_CONFIG_EMBEDDED_RULES_LIST_PROJECTION="/data/adb/Hyper_MagicWindow/config/embedded_rules_list_projection.xml"
CUSTOM_CONFIG_FIXED_ORIENTATION_LIST_PROJECTION="/data/adb/Hyper_MagicWindow/config/fixed_orientation_list_projection.xml"
CUSTOM_CONFIG_GENERIC_RULES_LIST_PROJECTION="/data/adb/Hyper_MagicWindow/config/generic_rules_list_projection.xml"

# 对云控文件解除写保护
# 检查 /data/system/cloudFeature_embedded_rules_list_projection.xml 是否存在
if [ -f /data/system/cloudFeature_embedded_rules_list_projection.xml ]; then
  chattr -i /data/system/cloudFeature_embedded_rules_list_projection.xml
fi
# 检查 /data/system/cloudFeature_fixed_orientation_list_projection.xml 是否存在
if [ -f /data/system/cloudFeature_fixed_orientation_list_projection.xml ]; then
  chattr -i /data/system/cloudFeature_fixed_orientation_list_projection.xml
fi
# 检查 /data/system/cloudFeature_generic_rules_list_projection.xml 是否存在
if [ -f /data/system/cloudFeature_generic_rules_list_projection.xml ]; then
  chattr -i /data/system/cloudFeature_generic_rules_list_projection.xml
fi
# 支持平行窗口(流转)自定义配置文件
if [[ -f "$CUSTOM_CONFIG_EMBEDDED_RULES_LIST_PROJECTION" ]]; then
  cp -f "$MODDIR"/common/source/embedded_rules_list_projection.xml "$MODDIR"/common/embedded_rules_list_projection.xml
  sed -i '/<\/package_config>/d' "$MODDIR"/common/embedded_rules_list_projection.xml
  cat "$CUSTOM_CONFIG_EMBEDDED_RULES_LIST_PROJECTION" >>"$MODDIR"/common/embedded_rules_list_projection.xml
  printf "\n</package_config>\n" >>"$MODDIR"/common/embedded_rules_list_projection.xml
else
  cp -f "$MODDIR"/common/source/embedded_rules_list_projection.xml "$MODDIR"/common/embedded_rules_list_projection.xml
fi
# 支持信箱模式(流转)自定义配置文件
if [[ -f "$CUSTOM_CONFIG_FIXED_ORIENTATION_LIST_PROJECTION" ]]; then
  cp -f "$MODDIR"/common/source/fixed_orientation_list_projection.xml "$MODDIR"/common/fixed_orientation_list_projection.xml
  sed -i '/<\/package_config>/d' "$MODDIR"/common/fixed_orientation_list_projection.xml
  cat "$CUSTOM_CONFIG_FIXED_ORIENTATION_LIST_PROJECTION" >>"$MODDIR"/common/fixed_orientation_list_projection.xml
  printf "\n</package_config>\n" >>"$MODDIR"/common/fixed_orientation_list.xml
else
  cp -f "$MODDIR"/common/source/fixed_orientation_list_projection.xml "$MODDIR"/common/fixed_orientation_list_projection.xml
fi
# 支持通用配置(流转)自定义配置文件
if [[ -f "$CUSTOM_CONFIG_GENERIC_RULES_LIST_PROJECTION" ]]; then
  cp -f "$MODDIR"/common/source/generic_rules_list_projection.xml "$MODDIR"/common/generic_rules_list_projection.xml
  sed -i '/<\/package_config>/d' "$MODDIR"/common/generic_rules_list_projection.xml
  cat "$CUSTOM_CONFIG_GENERIC_RULES_LIST_PROJECTION" >>"$MODDIR"/common/generic_rules_list_projection.xml
  printf "\n</package_config>\n" >>"$MODDIR"/common/generic_rules_list_projection.xml
else
  cp -f "$MODDIR"/common/source/generic_rules_list_projection.xml "$MODDIR"/common/generic_rules_list_projection.xml
fi
# 平行窗口(流转)
set_perm /data/system/cloudFeature_embedded_rules_list_projection.xml 1000 1000 0666 u:object_r:system_data_file:s0    # 设置平行窗口文件权限
cp -f "$MODDIR"/common/embedded_rules_list_projection.xml /data/system/cloudFeature_embedded_rules_list_projection.xml # 替换平行窗口配置列表
set_perm /data/system/cloudFeature_embedded_rules_list_projection.xml 1000 1000 0444 u:object_r:system_data_file:s0    # 禁止平行窗口配置文件被云控
# 信箱模式(流转)
set_perm /data/system/cloudFeature_fixed_orientation_list_projection.xml 1000 1000 0666 u:object_r:system_data_file:s0       # 设置信箱模式文件权限
cp -f "$MODDIR"/common/fixed_orientation_list_projection.xml /data/system/cloudFeature_fixed_orientation_list_projection.xml # 替换信箱模式配置列表
set_perm /data/system/cloudFeature_fixed_orientation_list_projection.xml 1000 1000 0444 u:object_r:system_data_file:s0       # 禁止信箱模式配置文件被云控
# 通用规则(流转)
set_perm /data/system/cloudFeature_generic_rules_list_projection.xml 1000 1000 0666 u:object_r:system_data_file:s0   
cp -f "$MODDIR"/common/generic_rules_list_projection.xml /data/system/cloudFeature_generic_rules_list_projection.xml 
set_perm /data/system/cloudFeature_generic_rules_list_projection.xml 1000 1000 0444 u:object_r:system_data_file:s0  
# 对云控文件写保护
# 检查 /data/system/cloudFeature_embedded_rules_list_projection.xml 是否存在
if [ -f /data/system/cloudFeature_embedded_rules_list_projection.xml ]; then
  chattr +i /data/system/cloudFeature_embedded_rules_list_projection.xml
fi
# 检查 /data/system/cloudFeature_fixed_orientation_list_projection.xml 是否存在
if [ -f /data/system/cloudFeature_fixed_orientation_list_projection.xml ]; then
  chattr +i /data/system/cloudFeature_fixed_orientation_list_projection.xml
fi
# 检查 /data/system/cloudFeature_generic_rules_list_projection.xml 是否存在
if [ -f /data/system/cloudFeature_generic_rules_list_projection.xml ]; then
  chattr +i /data/system/cloudFeature_generic_rules_list_projection.xml
fi
