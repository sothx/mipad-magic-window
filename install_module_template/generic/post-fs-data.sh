# shellcheck disable=SC2148

# a11
# /data/system/users/0/magic_window_setting_config.xml
# /data/system/magicWindowFeature_magic_window_application_list.xml
# a12+
# /data/system/cloudFeature_embedded_rules_list.xml
# /data/system/cloudFeature_fixed_orientation_list.xml

MODDIR=${0%/*}
API=$(getprop ro.build.version.sdk)

if [[ "$API" -eq 30 ]]; then
  # 对云控文件解除写保护
  chattr -i /data/system/users/0/magic_window_setting_config.xml
  chattr -i /data/system/magicWindowFeature_magic_window_application_list.xml
  # 替换云控文件
  set_perm_recursive /data/system/users/0/magic_window_setting_config.xml 1000 1000 0755 0666 u:object_r:system_data_file:s0
  cp -f "$MODDIR"/common/magic_window_setting_config.xml /data/system/users/0/magic_window_setting_config.xml
  set_perm_recursive /data/system/users/0/magic_window_setting_config.xml 1000 1000 0755 0444 u:object_r:system_data_file:s0
  set_perm_recursive /data/system/magicWindowFeature_magic_window_application_list.xml 1000 1000 0755 0666 u:object_r:system_data_file:s0
  cp -f "$MODDIR"/common/magicWindowFeature_magic_window_application_list.xml /data/system/magicWindowFeature_magic_window_application_list.xml
  set_perm_recursive /data/system/magicWindowFeature_magic_window_application_list.xml 1000 1000 0755 0444 u:object_r:system_data_file:s0
  # 对云控文件写保护
  chattr +i /data/system/users/0/magic_window_setting_config.xml
  chattr +i /data/system/magicWindowFeature_magic_window_application_list.xml
elif [[ "$API" -ge 31 ]]; then
  # 对云控文件解除写保护
  chattr -i /data/system/cloudFeature_embedded_rules_list.xml
  chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
  # 平行视界
  set_perm_recursive /data/system/cloudFeature_embedded_rules_list.xml 1000 1000 0755 0666 u:object_r:system_data_file:s0 # 设置平行视界文件权限
  cp -f "$MODDIR"/common/embedded_rules_list.xml /data/system/cloudFeature_embedded_rules_list.xml                        # 替换平行视界配置列表
  set_perm_recursive /data/system/cloudFeature_embedded_rules_list.xml 1000 1000 0755 0444 u:object_r:system_data_file:s0 # 禁止平行视界配置文件被云控
  # 信箱模式
  set_perm_recursive /data/system/cloudFeature_fixed_orientation_list.xml 1000 1000 0755 0666 u:object_r:system_data_file:s0 # 设置信箱模式文件权限
  cp -f "$MODDIR"/common/fixed_orientation_list.xml /data/system/cloudFeature_fixed_orientation_list.xml                     # 替换信箱模式配置列表
  set_perm_recursive /data/system/cloudFeature_fixed_orientation_list.xml 1000 1000 0755 0444 u:object_r:system_data_file:s0 # 禁止信箱模式配置文件被云控
  # 对云控文件写保护
  chattr +i /data/system/cloudFeature_embedded_rules_list.xml
  chattr +i /data/system/cloudFeature_fixed_orientation_list.xml
fi
