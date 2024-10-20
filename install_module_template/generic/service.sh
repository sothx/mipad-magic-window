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

start_line=1
start_line_add=1
while [ -n "$start_line_add" ]; do
  start="$(tail -n +"$start_line" $overlay_list | grep -n -m 1 "mPackageName")"
  if [ -z "$start" ]; then
    break
  fi
  start_line_add=$(echo "$start" | cut -d":" -f1)
  start_line=$((start_line + start_line_add - 1))
  mPackageName=$(sed -n "${start_line}p" "$overlay_list" | cut -d" " -f4)
  end="$(tail -n +"$start_line" $overlay_list | grep -n -m 1 "mIsFabricated" | cut -d: -f1)"
  end_line_add=$(echo "$end" | cut -d":" -f1)
  end_line=$((start_line + end_line_add - 1))
  mIsFabricated=$(sed -n "${end_line}p" "$overlay_list" | cut -d" " -f4)
  if [ "$mIsFabricated" = "false" ]; then
    sed -i "/$mPackageName/d" $package_list
  fi
  start_line=$end_line
done
sed -i 's/package://g' $package_list
rm -rf "$overlay_list"

while IFS= read -r line; do
  pkg=${line##*=}
  pkg_loc=${line%=*}
  pkg_name=$($aapt2_util dump badging "$pkg_loc" 2>>/data/local/tmp/error.output |
    awk -F\' '
    {
      if ($0 ~ /application-label-zh-CN:/) label_zh_CN=$2;
      else if ($0 ~ /application-label-zh:/) label_zh=$2;
      else if ($0 ~ /application-label:/) label_default=$2;
    }
    END {
      if (label_zh_CN != "") print label_zh_CN;
      else if (label_zh != "") print label_zh;
      else if (label_default != "") print label_default;
      else print "'$pkg'";
    }
  ')
  json_output=$(echo "$json_output" | $jq_util --arg package_name "$pkg" --arg app_name "$pkg_name" \
    '. += [{"package_name": $package_name, "app_name": $app_name}]')
done <$package_list

rm -rf $package_list
echo "$json_output" >$json_path
