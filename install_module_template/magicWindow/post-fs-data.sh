#!/system/bin/sh
# 请不要硬编码 /magisk/modname/... ; 请使用 $MODDIR/...
# 这将使你的脚本更加兼容，即使Magisk在未来改变了它的挂载点
MODDIR=${0%/*}
# 获取安卓版本
ANDROID_VERSION=$(getprop ro.build.version.release)

ui_print "- 当前系统版本为Android $ANDROID_VERSION，写入Android $ANDROID_VERSION 的相关配置"
if [ ${ANDROID_VERSION} -le "11" ]; then
  # For Android 11
  cp -f $MODDIR/common/system/users/0/magic_window_setting_config.xml /data/system/users/0/magic_window_setting_config.xml
  cp -f $MODDIR/common/system/magicWindowFeature_magic_window_application_list.xml /data/system/magicWindowFeature_magic_window_application_list.xml
else
  # For Android 12+
  # 设置SELinux安全上下文
  chcon u:object_r:system_file:s0 $MODDIR/common/product/etc/embedded_rules_list.xml
  chcon u:object_r:system_file:s0 $MODDIR/common/product/etc/fixed_orientation_list.xml
  # 设置平行视界文件权限
  chmod 666 /product/etc/embedded_rules_list.xml
  chown root:root /product/etc/embedded_rules_list.xml
  chmod 666 /data/system/cloudFeature_embedded_rules_list.xml
  chown root:root /data/system/cloudFeature_embedded_rules_list.xml
  # 为平行视界配置列表写入软链接
  mv $MODDIR/common/product/etc/embedded_rules_list.xml /product/etc/embedded_rules_list.xml
  cp -l $MODDIR/product/etc/embedded_rules_list.xml $MODDIR/common/product/etc/embedded_rules_list.xml
  rm /data/system/cloudFeature_embedded_rules_list.xml
  mv $MODDIR/common/product/etc/embedded_rules_list.xml /data/system/cloudFeature_embedded_rules_list.xml
  cp -l $MODDIR/product/etc/embedded_rules_list.xml $MODDIR/common/product/etc/embedded_rules_list.xml
  # 设置信箱模式文件权限
  chmod 666 /product/etc/fixed_orientation_list.xml
  chown root:root /product/etc/fixed_orientation_list.xml
  chmod 666 /data/system/cloudFeature_fixed_orientation_list.xml
  chown root:root /data/system/cloudFeature_fixed_orientation_list.xml
  # 为信箱模式配置列表写入软链接
  mv $MODDIR/common/product/etc/fixed_orientation_list.xml /product/etc/fixed_orientation_list.xml
  cp -l $MODDIR/product/etc/fixed_orientation_list.xml $MODDIR/common/product/etc/fixed_orientation_list.xml
  rm /data/system/cloudFeature_fixed_orientation_list.xml
  mv $MODDIR/common/product/etc/fixed_orientation_list.xml /data/system/cloudFeature_fixed_orientation_list.xml
  cp -l $MODDIR/product/etc/fixed_orientation_list.xml $MODDIR/common/product/etc/fixed_orientation_list.xml
  # 禁止平行视界配置文件被云控
  chmod 440 /product/etc/embedded_rules_list.xml
  chown system /product/etc/embedded_rules_list.xml
  chmod 440 /data/system/cloudFeature_embedded_rules_list.xml
  chown system /data/system/cloudFeature_embedded_rules_list.xml
  # 禁止信箱模式配置文件被云控
  chmod 440 /product/etc/fixed_orientation_list.xml
  chown system /product/etc/fixed_orientation_list.xml
  chmod 440 /data/system/cloudFeature_fixed_orientation_list.xml
  chown system /data/system/cloudFeature_fixed_orientation_list.xml
  ## 对云控文件写保护
  chattr +i /data/system/cloudFeature_embedded_rules_list.xml
  chattr +i /data/system/cloudFeature_fixed_orientation_list.xml
fi
ui_print "- HyperOS For Pad/Fold 完美横屏应用计划预加载配置完成，感谢使用！"
# 这个脚本将以 post-fs-data 模式执行
# 更多信息请访问 Magisk 主题
