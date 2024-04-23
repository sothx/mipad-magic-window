# shellcheck disable=SC2148
MODDIR=${0%/*}

. "$MODDIR"/util_functions.sh
api_level_arch_detect

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
  rm -rf /data/system/cloudFeature_embedded_rules_list.xml    # 删除平行视界模块配置
  rm -rf /data/system/cloudFeature_fixed_orientation_list.xml # 删除信箱模式模块配置
  rm -rf /data/system/users/0/embedded_setting_config.xml # 重置平行视界默认配置文件
fi

# 删除模块
rm -rf "$MODDIR"
