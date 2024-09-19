MODDIR=${0%/*}
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
. "$MODULE_CUSTOM_CONFIG_PATH"/config/service_shell.sh

chmod -R 0777 "$MODDIR"
chmod -R 0777 "$MODULE_CUSTOM_CONFIG_PATH"

set_miui_embedding_window
