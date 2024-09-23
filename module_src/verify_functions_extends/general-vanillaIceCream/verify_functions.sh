# shellcheck disable=SC2148
verify_android_api_has_pass() {
    if [[ "$1" -lt 35 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android 15+，请重新选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}

verify_special_rule_pass() {
    local mi_os_version_name=$(grep_prop ro.mi.os.version.name /mi_ext/etc/build.prop)
    # 目录不存在则创建目录
    if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
        /bin/mkdir -p "$MODPATH/system/system_ext/framework"
    fi
    if [ -z "$mi_os_version_name" == 'OS1.1' ]; then
        ui_print "*********************************************"
        ui_print "- 感谢参与<完美横屏应用计划>在小米平板6S Pro 体验增强Beta版的测试~"
        ui_print "- 请了解目前本模块在Android 15下并未做充分的测试，如有遇到任何模块问题欢迎反馈给我~"
        ui_print "- 模块反馈Q群：277757185"
        ui_print "- (Tips:请随意选择，不影响模块安装过程~)"
        ui_print "  音量+ ：我已了解当前Android 15的模块为测试版"
        ui_print "  音量- ：已读不回.jpg"
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
    fi
}
