# shellcheck disable=SC2148
verify_android_api_has_pass() {
    api_num=$(printf "%d" "$1")
    if [[ "$api_num" -ne 30 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块当前仅支持Android11，请重新选择正确版本的模块QwQ！！！"
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
    local sothx_magic_window_version=$(grep_prop ro.config.sothx_magic_window_version "$magisk_path$module_id/system.prop")
    if [ -z "$sothx_magic_window_version" ]; then
        ui_print "*********************************************"
        ui_print "- Android 11版本仅提供基础的模块规则适配，不支援Web UI和其他模块增强功能"
        ui_print "- 如需修改部分应用的适配规则，请参考[模块首页-自定义规则]"
        ui_print "- 强烈推荐老机型升级到至少MIUI14的正式版，即可享受完整的[完美横屏应用计划]"
        ui_print "- (Tips:请随意选择，不影响模块安装过程~)"
        ui_print "  音量+ ：已了解使用须知"
        ui_print "  音量- ：已了解使用须知"
        ui_print "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            add_props "ro.config.sothx_magic_window_version=magicWindow"
            ui_print "*********************************************"
            ui_print "- 正在进入模块安装流程~"
            ui_print "*********************************************"
        else
            add_props "ro.config.sothx_magic_window_version=magicWindow"
            ui_print "*********************************************"
            ui_print "- 正在进入模块安装流程~"
            ui_print "*********************************************"
        fi
    fi
}
