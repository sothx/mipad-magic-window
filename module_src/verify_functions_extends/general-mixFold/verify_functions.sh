# shellcheck disable=SC2148
verify_android_api_has_pass() {
  local muiltdisplayType=$(getprop persist.sys.muiltdisplay_type)
  if [[ "$muiltdisplayType" != 2 ]]; then
    ui_print "*********************************************"
    ui_print "- 模块仅适配大折叠设备，请重新选择正确版本的模块QwQ！！！"
    ui_print "- 您可以选择强制安装不受支持的模块，但可能导致系统出现各种异常，是否继续？"
    ui_print "  音量+ ：哼，我偏要装(强制安装)"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "*********************************************"
      ui_print "- 你选择了强制安装不受支持的模块！！！"
      ui_print "*********************************************"
    else
      ui_print "*********************************************"
      ui_print "- 请重新选择正确版本的模块QwQ！！！"
      abort "*********************************************"
    fi
  fi
}

verify_special_rule_pass() {
  api_num=$(printf "%d" "$1")
  local sothx_project_treble_support_hyper_magic_window_cloud_config_fix=$(getprop ro.config.sothx_project_treble_support_hyper_magic_window_cloud_config_fix)
  local sothx_project_treble_hyper_magic_window_cloud_config_fix_version=$(getprop ro.config.sothx_project_treble_hyper_magic_window_cloud_config_fix_version)
  local is_need_install_fix_hyper_magic_window_cloud_config_apk=1
  HAS_BEEN_INSTALLED_FIX_HYPER_MAGIC_WINDOW_CLOUD_CONFIG_APK=$(pm list packages | grep io.github.sothx.FixHyperMagicWindowCloudConfig)
  if [[ "$api_num" -le 37 ]]; then
    is_need_install_fix_hyper_magic_window_cloud_config_apk=0
  fi
  if [[ $HAS_BEEN_INSTALLED_FIX_HYPER_MAGIC_WINDOW_CLOUD_CONFIG_APK == *"package:io.github.sothx.FixHyperMagicWindowCloudConfig"* ]]; then
    is_need_install_fix_hyper_magic_window_cloud_config_apk=0
  fi
  if [[ $sothx_project_treble_support_hyper_magic_window_cloud_config_fix == 'true' ]]; then
    if [[ $sothx_project_treble_hyper_magic_window_cloud_config_fix_version -ge 1 ]]; then
      is_need_install_fix_hyper_magic_window_cloud_config_apk=0
    fi
  fi

  if [[ $is_need_install_fix_hyper_magic_window_cloud_config_apk == 1 ]]; then
    ui_print "*********************************************"
    ui_print "- 是否安装Fix Hyper Magic Window Cloud Config？"
    ui_print "- [重要提醒]: Hyper OS 4 需要安装该LSPosed模块才能修复应用横屏布局和应用布局优化不生效的问题"
    ui_print "- [重要提醒]: 安装后请前往LSPosed启用模块并重启平板"
    ui_print "  音量+ ：是"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "- 正在为你安装Fix Hyper Magic Window Cloud Config，请稍等~"
      unzip -jo "$ZIPFILE" 'common/apks/FixHyperMagicWindowCloudConfig.apk' -d /data/local/tmp/ &>/dev/null
      pm install -r /data/local/tmp/FixHyperMagicWindowCloudConfig.apk &>/dev/null
      rm -rf /data/local/tmp/FixHyperMagicWindowCloudConfig.apk
      HAS_BEEN_INSTALLED_FIX_HYPER_MAGIC_WINDOW_CLOUD_CONFIG_APK=$(pm list packages | grep io.github.sothx.FixHyperMagicWindowCloudConfig)
      if [[ $HAS_BEEN_INSTALLED_FIX_HYPER_MAGIC_WINDOW_CLOUD_CONFIG_APK == *"package:io.github.sothx.FixHyperMagicWindowCloudConfig"* ]]; then
        ui_print "- 好诶Fix Hyper Magic Window Cloud Config安装完成！"
        ui_print "- 好诶，安装后请前往LSPosed启用模块并重启平板！"
      else
        abort "- Fix Hyper Magic Window Cloud Config安装失败，请尝试重新安装！"
        abort "- 也可前往模块网盘下载单独的 Fix Hyper Magic Window Cloud Config apk 进行手动安装！"
      fi
    else
      ui_print "*********************************************"
      ui_print "- 你选择不安装Fix Hyper Magic Window Cloud Config"
      ui_print "- Hyper OS 4 需要安装该LSPosed模块才能修复应用横屏布局和应用布局优化不生效的问题"
      ui_print "*********************************************"
    fi
  fi
}
