# shellcheck disable=SC2148
verify_android_api_has_pass() {
  api_num=$(printf "%d" "$1")
  if [[ "$api_num" -ne 37 ]]; then
    ui_print "*********************************************"
    ui_print "- 模块仅支持Android 17，请重新选择正确版本的模块QwQ！！！"
    ui_print "- 基于 Android 16的Hyper OS 4请安装安卓16通用版，不适用于该版本！！！"
    ui_print "- 您可以选择强制安装Android版本不受支持的模块，但可能导致系统出现各种异常，是否继续？"
    ui_print "  音量+ ：哼，我偏要装(强制安装)"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "*********************************************"
      ui_print "- 你选择了强制安装Android版本不受支持的模块！！！"
      ui_print "*********************************************"
    else
      ui_print "*********************************************"
      ui_print "- 请重新选择正确版本的模块QwQ！！！"
      abort "*********************************************"
    fi
  fi
}

verify_special_rule_pass() {
  local mi_os_version_code=$(grep_prop ro.mi.os.version.code /mi_ext/etc/build.prop)
  local sothx_project_treble_support_autoui_services_fix=$(getprop ro.config.sothx_project_treble_support_autoui_services_fix)
  local sothx_disabled_os2_install_module_tips=$(getprop ro.sothx.disabled_os2_install_module_tips)
  local is_need_install_autoui_cloudfix_apk=1
  HAS_BEEN_INSTALLED_AutoUI_CloudFix_APK=$(pm list packages | grep io.github.sothx.autouicloudfix)
  if [[ $HAS_BEEN_INSTALLED_AutoUI_CloudFix_APK == *"package:io.github.sothx.autouicloudfix"* ]]; then
    is_need_install_autoui_cloudfix_apk=0
  fi
  if [[ $sothx_project_treble_support_autoui_services_fix == 'true' ]]; then
    is_need_install_autoui_cloudfix_apk=0
  fi
  if [[ $is_need_install_autoui_cloudfix_apk == 1 ]]; then
    ui_print "*********************************************"
    ui_print "- 是否安装AutoUI Cloud Fix？"
    ui_print "- [重要提醒]: Hyper OS 4 需要安装该LSPosed模块才能修复应用布局优化不生效的问题"
    ui_print "- [重要提醒]: 安装后请前往LSPosed启用模块并重启平板"
    ui_print "  音量+ ：是"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "- 正在为你安装AutoUI Cloud Fix，请稍等~"
      unzip -jo "$ZIPFILE" 'common/apks/AutoUICloudFix.apk' -d /data/local/tmp/ &>/dev/null
      pm install -r /data/local/tmp/AutoUICloudFix.apk &>/dev/null
      rm -rf /data/local/tmp/AutoUICloudFix.apk
      HAS_BEEN_INSTALLED_AutoUI_CloudFix_APK=$(pm list packages | grep io.github.sothx.autouicloudfix)
      if [[ $HAS_BEEN_INSTALLED_AutoUI_CloudFix_APK == *"package:io.github.sothx.autouicloudfix"* ]]; then
        ui_print "- 好诶，AutoUI Cloud Fix安装完成！"
        ui_print "- 好诶，安装后请前往LSPosed启用模块并重启平板！"
      else
        abort "- AutoUI Cloud Fix安装失败，请尝试重新安装！"
        abort "- 也可前往模块网盘下载单独的 AutoUI Cloud Fix apk 进行手动安装！"
      fi
    else
      ui_print "*********************************************"
      ui_print "- 你选择不安装AutoUI Cloud Fix"
      ui_print "- Hyper OS 4 需要安装该LSPosed模块才能修复应用布局优化不生效的问题"
      ui_print "*********************************************"
    fi
  fi
  if [[ -z "$sothx_disabled_os2_install_module_tips" ]]; then
    ui_print "*********************************************"
    ui_print "- 感谢使用<完美横屏应用计划>Hyper OS 4.0版本~"
    ui_print "- 请了解以下使用须知："
    ui_print "- 1.Hyper OS 4.0的模块必须搭配Web UI使用~"
    ui_print "- 2.在[平板专区-应用横屏布局]所做的任何修改会在重启后丢失~"
    ui_print "- 3.如需修改应用横屏适配，请前往Web UI进行修改~"
    ui_print "- 4.可前往[模块设置-模块使用须知]，禁用该提醒"
    ui_print "- (Tips:请随意选择，不影响模块安装过程~)"
    ui_print "  音量+ ：已了解使用须知"
    ui_print "  音量- ：已了解使用须知"
    ui_print "*********************************************"
    key_check
    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
      ui_print "*********************************************"
      ui_print "- 正在进入模块安装流程~"
      ui_print "*********************************************"
    else
      ui_print "*********************************************"
      ui_print "- 正在进入模块安装流程~"
      ui_print "*********************************************"
    fi
  else
    ui_print "*********************************************"
    ui_print "- 您已选择跳过模块使用须知~"
    add_lines "ro.sothx.disabled_os2_install_module_tips=true" "$MODPATH"/system.prop
    ui_print "*********************************************"
  fi
}
