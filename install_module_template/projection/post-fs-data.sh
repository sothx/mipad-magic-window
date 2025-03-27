# shellcheck disable=SC2148

MODDIR=${0%/*}
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+"
. "$MODDIR"/util_functions.sh
api_level_arch_detect

if [[ ! -d "$MODDIR/common/temp" ]]; then
  /bin/mkdir -p "$MODDIR/common/temp"
fi
# 获取ROOT管理器信息并写入

echo "$KSU,$KSU_VER,$KSU_VER_CODE,$KSU_KERNEL_VER_CODE,$APATCH,$APATCH_VER_CODE,$APATCH_VER,$MAGISK_VER,$MAGISK_VER_CODE" >"$MODPATH/common/temp/root_manager_info.txt"

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
# 拷贝平行窗口配置文件
cp -f "$MODDIR"/common/source/embedded_rules_list_projection.xml "$MODDIR"/common/embedded_rules_list_projection.xml
# 拷贝信箱模配置文件
cp -f "$MODDIR"/common/source/fixed_orientation_list_projection.xml "$MODDIR"/common/fixed_orientation_list_projection.xml
# 拷贝通用规则配置文件
cp -f "$MODDIR"/common/source/generic_rules_list_projection.xml "$MODDIR"/common/generic_rules_list_projection.xml
# 平行窗口
set_perm /data/system/cloudFeature_embedded_rules_list_projection.xml 1000 1000 0666 u:object_r:system_data_file:s0    # 设置平行窗口文件权限
cp -f "$MODDIR"/common/embedded_rules_list_projection.xml /data/system/cloudFeature_embedded_rules_list_projection.xml # 替换平行窗口配置列表
set_perm /data/system/cloudFeature_embedded_rules_list_projection.xml 1000 1000 0444 u:object_r:system_data_file:s0    # 禁止平行窗口配置文件被云控
# 信箱模式
set_perm /data/system/cloudFeature_fixed_orientation_list_projection.xml 1000 1000 0666 u:object_r:system_data_file:s0       # 设置信箱模式文件权限
cp -f "$MODDIR"/common/fixed_orientation_list_projection.xml /data/system/cloudFeature_fixed_orientation_list_projection.xml # 替换信箱模式配置列表
set_perm /data/system/cloudFeature_fixed_orientation_list_projection.xml 1000 1000 0444 u:object_r:system_data_file:s0       # 禁止信箱模式配置文件被云控
# 通用规则
set_perm /data/system/cloudFeature_generic_rules_list_projection.xml 1000 1000 0666 u:object_r:system_data_file:s0   # 设置应用布局优化文件权限
cp -f "$MODDIR"/common/generic_rules_list_projection.xml /data/system/cloudFeature_generic_rules_list_projection.xml # 替换应用布局优化配置列表
set_perm /data/system/cloudFeature_generic_rules_list_projection.xml 1000 1000 0444 u:object_r:system_data_file:s0   # 禁止应用布局优化配置文件被云控
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
