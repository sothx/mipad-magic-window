# shellcheck disable=SC2148
MODDIR=${0%/*}
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+/"

. "$MODDIR"/util_functions.sh
api_level_arch_detect

rm -rf /data/adb/MIUI_MagicWindow+/

# For Android 12+
# 对云控文件解除写保护
chattr -i /data/system/cloudFeature_embedded_rules_list.xml
chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
chattr -i /data/system/cloudFeature_autoui_list.xml
chattr -i /data/system/users/0/embedded_setting_config.xml
rm -rf /data/system/cloudFeature_embedded_rules_list.xml    # 删除平行视界模块配置
rm -rf /data/system/cloudFeature_fixed_orientation_list.xml # 删除信箱模式模块配置
rm -rf /data/system/cloudFeature_autoui_list.xml            # 删除应用布局优化模块配置
rm -rf /data/system/users/0/embedded_setting_config.xml # 重置平行视界默认配置文件
rm -rf /data/system/users/0/autoui_setting_config.xml   # 重置应用布局优化默认配置文件
if [[ "$API" -ge 35 ]]; then
  rm -rf /data/system/users/0/projection_embedded_setting_config.xml # 重置Android 15+平行视界默认配置文件
fi

# 删除模块
rm -rf "$MODDIR"
