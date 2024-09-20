# shellcheck disable=SC2148
valid_current_android_target_pass() {
    if [[ "$1" -eq 30 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android 11，请选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}
