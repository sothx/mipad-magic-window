# shellcheck disable=SC2148
MODDIR=${0%/*}
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+/"

. "$MODDIR"/util_functions.sh
api_level_arch_detect

rm -rf /data/adb/MIUI_MagicWindow+/

if [[ "$API" -eq 30 ]]; then
  # For Android 11
  # 对云控文件解除写保护
  chattr -i /data/system/users/0/magic_window_setting_config.xml
  chattr -i /data/system/magicWindowFeature_magic_window_application_list.xml
  # 直接删除 Android 11 配置文件，重启后系统会自动重新生成
  rm -rf /data/system/users/0/magic_window_setting_config.xml
  rm -rf /data/system/magicWindowFeature_magic_window_application_list.xml
elif [[ "$API" -ge 31 ]]; then
  # For Android 12+
  # 对云控文件解除写保护
  chattr -i /data/system/cloudFeature_embedded_rules_list.xml
  chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
  chattr -i /data/system/cloudFeature_autoui_list.xml
  # 流转配置文件
  chattr -i /data/system/cloudFeature_embedded_rules_list_projection.xml
  chattr -i /data/system/cloudFeature_fixed_orientation_list_projection.xml
  chattr -i /data/system/cloudFeature_generic_rules_list_projection.xml
  rm -rf /data/system/cloudFeature_embedded_rules_list.xml    # 删除平行窗口模块配置
  rm -rf /data/system/cloudFeature_fixed_orientation_list.xml # 删除信箱模式模块配置
  rm -rf /data/system/cloudFeature_autoui_list.xml            # 删除应用布局优化模块配置
  rm -rf /data/system/users/0/embedded_setting_config.xml     # 重置平行窗口默认配置文件
  rm -rf /data/system/users/0/autoui_setting_config.xml       # 重置应用布局优化默认配置文件
  rm -rf /data/system/cloudFeature_embedded_rules_list_projection.xml # 删除平行窗口(流转)模块配置
  rm -rf /data/system/cloudFeature_fixed_orientation_list_projection.xml # 删除信箱模式(流转)模块配置
  rm -rf /data/system/cloudFeature_generic_rules_list_projection.xml     # 删除通用规则(流转)模块配置
  rm -rf /data/system/users/0/projection_embedded_setting_config.xml # 重置平行窗口默认配置文件
fi

# 删除模块
rm -rf "$MODDIR"
