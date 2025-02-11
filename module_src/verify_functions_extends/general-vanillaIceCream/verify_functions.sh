# shellcheck disable=SC2148
verify_android_api_has_pass() {
    api_num=$(printf "%d" "$1")
    if [[ "$api_num" -lt 35 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android 15+，请重新选择正确版本的模块QwQ！！！"
        ui_print "- 基于 Android 14的Hyper OS 2请安装安卓14通用版，不适用于该版本！！！"
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
    # 目录不存在则创建目录
    if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
        /bin/mkdir -p "$MODPATH/system/system_ext/framework"
    fi
    if [[ -z "$mi_os_version_code" || "$mi_os_version_code" == "2" || "$mi_os_version_code" -eq 2 ]]; then
        ui_print "*********************************************"
        ui_print "- 感谢参与<完美横屏应用计划>在Hyper OS 2.0的测试~"
        ui_print "- 请了解以下使用须知："
        ui_print "- 1.Hyper OS 2.0的模块必须搭配Web UI使用~"
        ui_print "- 2.在[平板专区-应用横屏布局]所做的任何修改会在重启后丢失~"
        ui_print "- 3.如需修改应用横屏适配，请前往Web UI进行修改~"
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
        ui_print "- 模块仅支持Hyper OS 2.0，请重新选择正确版本的模块QwQ！！！"
        ui_print "- 您可以选择强制安装Hyper OS版本不受支持的模块，但可能导致系统出现各种异常，是否继续？"
        ui_print "  音量+ ：哼，我偏要装(强制安装)"
        ui_print "  音量- ：否"
        ui_print "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            ui_print "*********************************************"
            ui_print "- 你选择了强制安装Hyper OS版本不受支持的模块！！！"
            ui_print "*********************************************"
        else
            ui_print "*********************************************"
            ui_print "- 请重新选择正确版本的模块QwQ！！！"
            abort "*********************************************"
        fi
    fi
}
