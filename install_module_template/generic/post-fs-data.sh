# shellcheck disable=SC2148,SC1091,SC2235

MODDIR=${0%/*}
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+"
. "$MODDIR"/util_functions.sh
api_level_arch_detect


if [[ ! -d "$MODDIR/common/temp" ]]; then
  /bin/mkdir -p "$MODDIR/common/temp"
fi
# 获取ROOT管理器信息并写入

echo "$KSU,$KSU_VER,$KSU_VER_CODE,$KSU_KERNEL_VER_CODE,$APATCH,$APATCH_VER_CODE,$APATCH_VER,$MAGISK_VER,$MAGISK_VER_CODE" > "$MODPATH/common/temp/root_manager_info.txt"

is_patch_mode=$(grep_prop is_patch_mode "$MODULE_CUSTOM_CONFIG_PATH/config.prop")

# 补丁模式配置文件
# Android 12 +
PATCH_MODE_CONFIG_EMBEDDED_RULES_LIST="/data/adb/MIUI_MagicWindow+/patch_rule/embedded_rules_list.xml"
PATCH_MODE_CONFIG_FIXED_ORIENTATION_LIST="/data/adb/MIUI_MagicWindow+/patch_rule/fixed_orientation_list.xml"

# 自定义配置文件
# Android 12 +
CUSTOM_CONFIG_EMBEDDED_RULES_LIST="/data/adb/MIUI_MagicWindow+/config/embedded_rules_list.xml"
CUSTOM_CONFIG_FIXED_ORIENTATION_LIST="/data/adb/MIUI_MagicWindow+/config/fixed_orientation_list.xml"
CUSTOM_CONFIG_AUTOUI_LIST="/data/adb/MIUI_MagicWindow+/config/autoui_list.xml"
CUSTOM_CONFIG_GENERIC_RULES_LIST="/data/adb/MIUI_MagicWindow+/config/generic_rules_list.xml"
# Android 11
CUSTOM_CONFIG_MAGIC_WINDOW_APPLICATION_LIST="/data/adb/MIUI_MagicWindow+/config/magicWindowFeature_magic_window_application_list.xml"
CUSTOM_CONFIG_MAGIC_WINDOW_SETTING_CONFIG="/data/adb/MIUI_MagicWindow+/config/magic_window_setting_config.xml"

if [[ "$API" -eq 30 ]]; then
  # 对云控文件解除写保护
  chattr -i /data/system/users/0/magic_window_setting_config.xml
  chattr -i /data/system/magicWindowFeature_magic_window_application_list.xml
  # 支持横屏模式自定义配置文件
  if [[ -f "$CUSTOM_CONFIG_MAGIC_WINDOW_APPLICATION_LIST" ]]; then
    cp -f "$MODDIR"/common/source/magicWindowFeature_magic_window_application_list.xml "$MODDIR"/common/magicWindowFeature_magic_window_application_list.xml
    sed -i '/<\/package_config>/d' "$MODDIR"/common/magicWindowFeature_magic_window_application_list.xml
    cat "$CUSTOM_CONFIG_MAGIC_WINDOW_APPLICATION_LIST" >>"$MODDIR"/common/magicWindowFeature_magic_window_application_list.xml
    printf "\n</package_config>\n" >>"$MODDIR"/common/magicWindowFeature_magic_window_application_list.xml
  else
    cp -f "$MODDIR"/common/source/magicWindowFeature_magic_window_application_list.xml "$MODDIR"/common/magicWindowFeature_magic_window_application_list.xml
  fi
  # 支持横屏模式自定义应用列表文件
  if [[ -f "$CUSTOM_CONFIG_MAGIC_WINDOW_SETTING_CONFIG" ]]; then
    cp -f "$MODDIR"/common/source/magic_window_setting_config.xml "$MODDIR"/common/magic_window_setting_config.xml
    sed -i '/<\/setting_config>/d' "$MODDIR"/common/magic_window_setting_config.xml
    cat "$CUSTOM_CONFIG_MAGIC_WINDOW_SETTING_CONFIG" >>"$MODDIR"/common/magic_window_setting_config.xml
    printf "\n</setting_config>\n" >>"$MODDIR"/common/magic_window_setting_config.xml
  else
    cp -f "$MODDIR"/common/source/magic_window_setting_config.xml "$MODDIR"/common/magic_window_setting_config.xml
  fi
  # 替换云控文件
  set_perm /data/system/users/0/magic_window_setting_config.xml 1000 1000 0666 u:object_r:system_data_file:s0
  cp -f "$MODDIR"/common/magic_window_setting_config.xml /data/system/users/0/magic_window_setting_config.xml
  set_perm /data/system/users/0/magic_window_setting_config.xml 1000 1000 0444 u:object_r:system_data_file:s0
  set_perm /data/system/magicWindowFeature_magic_window_application_list.xml 1000 1000 0666 u:object_r:system_data_file:s0
  cp -f "$MODDIR"/common/magicWindowFeature_magic_window_application_list.xml /data/system/magicWindowFeature_magic_window_application_list.xml
  set_perm /data/system/magicWindowFeature_magic_window_application_list.xml 1000 1000 0444 u:object_r:system_data_file:s0
  # 对云控文件写保护
  chattr +i /data/system/users/0/magic_window_setting_config.xml
  chattr +i /data/system/magicWindowFeature_magic_window_application_list.xml
elif [[ "$API" -ge 31 ]]; then
  # 对云控文件解除写保护
  # 检查 /data/system/cloudFeature_embedded_rules_list.xml 是否存在
  if [ -f /data/system/cloudFeature_embedded_rules_list.xml ]; then
    chattr -i /data/system/cloudFeature_embedded_rules_list.xml
  fi
  # 检查 /data/system/cloudFeature_fixed_orientation_list.xml 是否存在
  if [ -f /data/system/cloudFeature_fixed_orientation_list.xml ]; then
    chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
  fi
  # 检查 /data/system/cloudFeature_autoui_list.xml 是否存在
  if [ -f /data/system/cloudFeature_autoui_list.xml ]; then
    chattr -i /data/system/cloudFeature_autoui_list.xml
  fi
  # 支持平行窗口自定义配置文件
  if [[ -f "$CUSTOM_CONFIG_EMBEDDED_RULES_LIST" ]] && ([ -z "$is_patch_mode" ] || [ "$is_patch_mode" = "false" ]); then
    cp -f "$MODDIR"/common/source/embedded_rules_list.xml "$MODDIR"/common/embedded_rules_list.xml
    sed -i '/<\/package_config>/d' "$MODDIR"/common/embedded_rules_list.xml
    cat "$CUSTOM_CONFIG_EMBEDDED_RULES_LIST" >>"$MODDIR"/common/embedded_rules_list.xml
    printf "\n</package_config>\n" >>"$MODDIR"/common/embedded_rules_list.xml
  elif [[ -f "$PATCH_MODE_CONFIG_EMBEDDED_RULES_LIST" ]] && [ "$is_patch_mode" = "true" ]; then
    cp -f "$PATCH_MODE_CONFIG_EMBEDDED_RULES_LIST" "$MODDIR"/common/embedded_rules_list.xml
    sed -i '/<\/package_config>/d' "$MODDIR"/common/embedded_rules_list.xml
    cat "$CUSTOM_CONFIG_EMBEDDED_RULES_LIST" >>"$MODDIR"/common/embedded_rules_list.xml
    printf "\n</package_config>\n" >>"$MODDIR"/common/embedded_rules_list.xml
  else
    cp -f "$MODDIR"/common/source/embedded_rules_list.xml "$MODDIR"/common/embedded_rules_list.xml
  fi
  # 支持信箱模式自定义配置文件
  if [[ -f "$CUSTOM_CONFIG_FIXED_ORIENTATION_LIST" ]] && ([ -z "$is_patch_mode" ] || [ "$is_patch_mode" = "false" ]); then
    cp -f "$MODDIR"/common/source/fixed_orientation_list.xml "$MODDIR"/common/fixed_orientation_list.xml
    sed -i '/<\/package_config>/d' "$MODDIR"/common/fixed_orientation_list.xml
    cat "$CUSTOM_CONFIG_FIXED_ORIENTATION_LIST" >>"$MODDIR"/common/fixed_orientation_list.xml
    printf "\n</package_config>\n" >>"$MODDIR"/common/fixed_orientation_list.xml
  elif [[ -f "$PATCH_MODE_CONFIG_FIXED_ORIENTATION_LIST" ]] && [ "$is_patch_mode" = "true" ]; then
    cp -f "$PATCH_MODE_CONFIG_FIXED_ORIENTATION_LIST" "$MODDIR"/common/fixed_orientation_list.xml
    sed -i '/<\/package_config>/d' "$MODDIR"/common/fixed_orientation_list.xml
    cat "$CUSTOM_CONFIG_FIXED_ORIENTATION_LIST" >>"$MODDIR"/common/fixed_orientation_list.xml
    printf "\n</package_config>\n" >>"$MODDIR"/common/fixed_orientation_list.xml
  else
    cp -f "$MODDIR"/common/source/fixed_orientation_list.xml "$MODDIR"/common/fixed_orientation_list.xml
  fi
  # 支持应用布局优化自定义配置文件
  if [[ -f "$CUSTOM_CONFIG_AUTOUI_LIST" ]]; then
    cp -f "$MODDIR"/common/source/autoui_list.xml "$MODDIR"/common/autoui_list.xml
    sed -i '/<\/packageRules>/d' "$MODDIR"/common/autoui_list.xml
    cat "$CUSTOM_CONFIG_AUTOUI_LIST" >>"$MODDIR"/common/autoui_list.xml
    printf "\n</packageRules>\n" >>"$MODDIR"/common/autoui_list.xml
  else
    cp -f "$MODDIR"/common/source/autoui_list.xml "$MODDIR"/common/autoui_list.xml
  fi
  # 平行窗口
  set_perm /data/system/cloudFeature_embedded_rules_list.xml 1000 1000 0666 u:object_r:system_data_file:s0 # 设置平行窗口文件权限
  cp -f "$MODDIR"/common/embedded_rules_list.xml /data/system/cloudFeature_embedded_rules_list.xml         # 替换平行窗口配置列表
  set_perm /data/system/cloudFeature_embedded_rules_list.xml 1000 1000 0444 u:object_r:system_data_file:s0 # 禁止平行窗口配置文件被云控
  # 信箱模式
  set_perm /data/system/cloudFeature_fixed_orientation_list.xml 1000 1000 0666 u:object_r:system_data_file:s0 # 设置信箱模式文件权限
  cp -f "$MODDIR"/common/fixed_orientation_list.xml /data/system/cloudFeature_fixed_orientation_list.xml      # 替换信箱模式配置列表
  set_perm /data/system/cloudFeature_fixed_orientation_list.xml 1000 1000 0444 u:object_r:system_data_file:s0 # 禁止信箱模式配置文件被云控
  # 应用布局优化
  set_perm /data/system/cloudFeature_autoui_list.xml 1000 1000 0666 u:object_r:system_data_file:s0 # 设置应用布局优化文件权限
  cp -f "$MODDIR"/common/autoui_list.xml /data/system/cloudFeature_autoui_list.xml                 # 替换应用布局优化配置列表
  set_perm /data/system/cloudFeature_autoui_list.xml 1000 1000 0444 u:object_r:system_data_file:s0 # 禁止应用布局优化配置文件被云控
  # 对云控文件写保护
  # 检查 /data/system/cloudFeature_embedded_rules_list.xml 是否存在
  if [ -f /data/system/cloudFeature_embedded_rules_list.xml ]; then
    chattr +i /data/system/cloudFeature_embedded_rules_list.xml
  fi
  # 检查 /data/system/cloudFeature_fixed_orientation_list.xml 是否存在
  if [ -f /data/system/cloudFeature_fixed_orientation_list.xml ]; then
    chattr +i /data/system/cloudFeature_fixed_orientation_list.xml
  fi
  # 检查 /data/system/cloudFeature_autoui_list.xml 是否存在
  if [ -f /data/system/cloudFeature_autoui_list.xml ]; then
    chattr +i /data/system/cloudFeature_autoui_list.xml
  fi

fi
