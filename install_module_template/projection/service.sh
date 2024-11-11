MODDIR=${0%/*}
. "$MODDIR"/util_functions.sh
api_level_arch_detect
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+"
wait_login() {
  while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 1
  done

  while [ ! -d "/sdcard/Android" ]; do
    sleep 1
  done

  if [ -e "$MODPATH/service.sh.lock" ]; then
    echo "service.sh script is already running!"
    exit 1
  fi
  touch "$MODPATH/service.sh.lock"
  trap 'rm -rf "$MODPATH/service.sh.lock"' EXIT
}

wait_login
. "$MODDIR"/util_functions.sh

chmod -R 0777 "$MODDIR"
chmod -R 0777 "$MODULE_CUSTOM_CONFIG_PATH"

# 准备环境
package_list=$MODDIR/common/temp/package_list.txt
overlay_list=$MODDIR/common/temp/overlay_list.txt
json_path=$MODDIR/common/temp/package_info.json
aapt2_util=$MODDIR/common/utils/aapt2
jq_util=$MODDIR/common/utils/jq
mkdir -p $MODDIR/common/temp
pm list packages -a -f >>$package_list
dumpsys overlay >>$overlay_list
json_output="[]"
