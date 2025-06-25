# shellcheck disable=SC2148
api_level_arch_detect() {
  API=$(getprop ro.build.version.sdk)
  ABI=$(getprop ro.product.cpu.abi)
  if [ "$ABI" = "x86" ]; then
    ARCH=x86
    ABI32=x86
    IS64BIT=false
  elif [ "$ABI" = "arm64-v8a" ]; then
    ARCH=arm64
    ABI32=armeabi-v7a
    IS64BIT=true
  elif [ "$ABI" = "x86_64" ]; then
    ARCH=x64
    ABI32=x86
    IS64BIT=true
  else
    ARCH=arm
    ABI=armeabi-v7a
    ABI32=armeabi-v7a
    IS64BIT=false
  fi
}

set_perm() {
  chown $2:$3 $1 || return 1
  chmod $4 $1 || return 1
  local CON=$5
  [ -z $CON ] && CON=u:object_r:system_file:s0
  chcon $CON $1 || return 1
}

set_perm_recursive() {
  find $1 -type d 2>/dev/null | while read dir; do
    set_perm $dir $2 $3 $4 $6
  done
  find $1 -type f -o -type l 2>/dev/null | while read file; do
    set_perm $file $2 $3 $5 $6
  done
}

fix_auth_manager() {
  # 修复权限管理服务
  cp -rf "$1"/common/FixAuthManager/** "$1"/
}

grep_prop() {
  local REGEX="s/^$1=//p"
  shift
  local FILES=$@
  [ -z "$FILES" ] && FILES='/system/build.prop'
  cat $FILES 2>/dev/null | dos2unix | sed -n "$REGEX" | head -n 1
}

update_system_prop() {
  local prop="$1"
  local value="$2"
  local file="$3"

  if grep -q "^$prop=" "$file"; then
    # 找到匹配行，替换内容
    sed -i "s/^$prop=.*/$prop=$value/" "$file"
  else
    # 文件非空且末尾没有换行符，先补一个换行符
    if [ -s "$file" ] && [ "$(tail -c1 "$file")" != $'\n' ]; then
      printf "\n" >> "$file"
    fi
    # 追加新行，内容后加换行符
    printf "$prop=$value" >> "$file"
  fi
}

remove_system_prop() {
  local prop="$1"
  local file="$2"
  sed -i "/^$prop=/d" "$file"
}

get_crond() {
  if [[ -f "/data/adb/ksu/bin/busybox" ]]; then
    echo "/data/adb/ksu/bin/busybox crond"
  elif [[ -f "/data/adb/ap/bin/busybox" ]]; then
    echo "/data/adb/ap/bin/busybox crond"
  else
    echo "$(magisk --path)/.magisk/busybox/crond"
  fi
}

kill_fbo_regularly_dir_crond() {
  pid="$(pgrep -f 'fbo_regularly.d' | grep -v $$)"
  [[ -n $pid ]] && {
    for kill_pid in $pid; do
      kill -9 "$kill_pid"
    done
  }
}

add_lines() {
  local content="$1"
  local file="$2"

  if [ -s "$file" ]; then
    local last_byte
    last_byte=$(tail -c1 "$file" | od -An -tx1 | tr -d ' \n\r')
    if [ "$last_byte" != "0a" ]; then
      printf "\n" >> "$file"
    fi
  fi

  # 追加内容，不自动加换行
  printf "%s" "$content" >> "$file"
}

# remove_old_verison_modules_config_file() {
#   # 解锁老版本模块配置
#   chattr -R -i /data/adb/modules/MIUI_MagicWindow+
#   chattr -i /data/system/users/0/magic_window_setting_config.xml
#   chattr -i /data/system/magicWindowFeature_magic_window_application_list.xml
#   chattr -i /data/system/cloudFeature_embedded_rules_list.xml
#   chattr -i /data/system/cloudFeature_fixed_orientation_list.xml
#   chattr -i /data/system/cloudFeature_autoui_list.xml
#   chattr -i /data/system/users/0/embedded_setting_config.xml
#   chattr -i /data/system/users/0/autoui_setting_config.xml
#   # 直接删除 Android 11 配置文件，重启后系统会自动重新生成
#   rm -rf /data/system/users/0/magic_window_setting_config.xml
#   rm -rf /data/system/magicWindowFeature_magic_window_application_list.xml
#   # 直接删除 Android 12+ 配置文件，重启后系统会自动重新生成
#   rm -rf /data/system/cloudFeature_embedded_rules_list.xml    # 删除平行视界模块配置
#   rm -rf /data/system/cloudFeature_fixed_orientation_list.xml # 删除信箱模式模块配置
#   rm -rf /data/system/cloudFeature_autoui_list.xml            # 删除应用布局优化模块配置
#   rm -rf /data/system/users/0/embedded_setting_config.xml     # 重置平行视界默认配置文件
#   rm -rf /data/system/users/0/autoui_setting_config.xml       # 重置应用布局优化默认配置文件
# }
