# shellcheck disable=SC2148
verify_android_api_has_pass() {
    api_num=$(printf "%d" "$1")
    if [[ "$api_num" -lt 34 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android 15+，请重新选择正确版本的模块QwQ！！！"
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
    local mi_os_version_name=$(grep_prop ro.mi.os.version.name /mi_ext/etc/build.prop)
    # 目录不存在则创建目录
    if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
        /bin/mkdir -p "$MODPATH/system/system_ext/framework"
    fi
    if [[ -z "$mi_os_version_name" && "$mi_os_version_name" == 'OS1.1' ]]; then
        ui_print "*********************************************"
        ui_print "- 感谢参与<完美横屏应用计划>在小米平板6S Pro 体验增强Beta版的测试~"
        ui_print "- 目前已知Beta版问题清单(非模块产生)："
        ui_print "- 1.选择"全屏显示"但是概率性失效，表现为仍然竖屏或者居中显示，请积极向小米反馈~"
        ui_print "- 2.部分情况下第一个问题连带导致应用布局优化不生效，请积极向小米反馈~"
        ui_print "- 请了解目前本模块在Android 15下并未做充分的测试，如有遇到任何模块问题欢迎反馈给我~"
        ui_print "- 请了解Beta版的不稳定性，并非所有问题都由模块产生，如果是由Beta版产生，请跟小米反馈~"
        ui_print "- 模块反馈Q群：277757185"
        ui_print "- (Tips:请随意选择，不影响模块安装过程~)"
        ui_print "  音量+ ：已了解当前Android 15的模块为测试版"
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

    if [[ -z "$mi_os_version_name" && "$mi_os_version_name" == 'OS2' ]]; then
        ui_print "*********************************************"
        ui_print "- 请了解目前本模块在Android 15下并未做充分的适配，如有遇到任何模块问题欢迎反馈给我~"
        ui_print "- 目前Android 15的模块并未完全适配Web UI，部分功能在Web UI下无法使用，请期待后续更新~"
        ui_print "- 模块反馈Q群：277757185"
        ui_print "- (Tips:请随意选择，不影响模块安装过程~)"
        ui_print "  音量+ ：已了解当前Android 15的模块为测试版"
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
