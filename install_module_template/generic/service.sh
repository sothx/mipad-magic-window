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
}

wait_login
. "$MODDIR"/util_functions.sh

chmod -R 0777 "$MODDIR"
chmod -R 0777 "$MODULE_CUSTOM_CONFIG_PATH"

# 读取部分需要重载的配置

if [ -f "$MODULE_CUSTOM_CONFIG_PATH"/config/service_shell.sh && "$API" -ge 31 ]; then

  . "$MODULE_CUSTOM_CONFIG_PATH"/config/service_shell.sh

  if type set_reload_rule &>/dev/null; then
    set_reload_rule
  fi

fi
