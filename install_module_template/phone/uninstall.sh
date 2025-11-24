# shellcheck disable=SC2148
MODDIR=${0%/*}
MODULE_CUSTOM_CONFIG_PATH="/data/adb/Hyper_MagicWindow/"

. "$MODDIR"/util_functions.sh
api_level_arch_detect

rm -rf /data/adb/Hyper_MagicWindow/

# For Android 15+
# 对云控文件解除写保护
chattr -i /data/system/cloudFeature_embedded_rules_list_projection.xml
chattr -i /data/system/cloudFeature_fixed_orientation_list_projection.xml
chattr -i /data/system/cloudFeature_generic_rules_list_projection.xml
rm -rf /data/system/cloudFeature_embedded_rules_list_projection.xml    # 删除平行窗口(流转)模块配置
rm -rf /data/system/cloudFeature_fixed_orientation_list_projection.xml # 删除信箱模式(流转)模块配置
rm -rf /data/system/cloudFeature_generic_rules_list_projection.xml           # 删除通用规则(流转)模块配置
rm -rf /data/system/users/0/projection_embedded_setting_config.xml # 重置平行窗口默认配置文件

# 删除模块
rm -rf "$MODDIR"
