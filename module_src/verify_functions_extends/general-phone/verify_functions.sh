# shellcheck disable=SC2148
verify_android_api_has_pass() {
    local characteristics=$(getprop ro.build.characteristics)
    if [[ "$characteristics" == "tablet" ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅适配小米手机，不适配平板或者大折叠设备，用于适配小米妙享桌面流转到平板上的体验，请重新选择正确版本的模块QwQ！！！"
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
    local muiltdisplayType=$(getprop persist.sys.muiltdisplay_type)
    if [[ "$muiltdisplayType" == 2 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅适配小米手机，不适配平板或者大折叠设备，用于适配小米妙享桌面流转到平板上的体验，请重新选择正确版本的模块QwQ！！！"
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
