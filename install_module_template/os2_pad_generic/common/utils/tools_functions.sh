# shellcheck disable=SC2148,SC2059,SC2086
grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop'
  cat $FILES 2>/dev/null | dos2unix | sed -n "$REGEX" | head -n 1
}

add_lines() {
  local content="$1"
  local file="$2"
  printf "\n$content\n" >>"$file"
}

update_system_prop() {
  local prop="$1"
  local value="$2"
  local file="$3"

  if grep -q "^$prop=" "$file"; then
    # 如果找到匹配行，使用 sed 进行替换
    sed -i "s/^$prop=.*/$prop=$value/" "$file"
  else
    # 如果没有找到匹配行，追加新行
    printf "$prop=$value\n" >>"$file"
  fi
}

remove_system_prop() {
  local prop="$1"
  local file="$2"
  sed -i "/^$prop=/d" "$file"
}

get_app_list() {
  {
    pm list packages -3 2>/dev/null || pm list packages -s 2>/dev/null || true
  } | awk -F: '{print $2}' | while read -r PACKAGE; do
    # Get APK path for the package
    APK_PATH=$(pm path "$PACKAGE" 2>/dev/null | grep "base.apk" | awk -F: '{print $2}' | tr -d '\r')
    [ -z "$APK_PATH" ] && APK_PATH=$(pm path "$PACKAGE" 2>/dev/null | grep ".apk" | awk -F: '{print $2}' | tr -d '\r')

    # 提取应用名称
    if [ -n "$APK_PATH" ]; then
      APP_NAME=$(/data/adb/modules/MIUI_MagicWindow+/common/utils/aapt dump badging "$APK_PATH" 2>/dev/null | grep "application-label:" | sed "s/application-label://g; s/'//g")
    else
      APP_NAME="Unknown App"
    fi

    # 只输出最终结果
    echo "$APP_NAME,$PACKAGE"
  done
}