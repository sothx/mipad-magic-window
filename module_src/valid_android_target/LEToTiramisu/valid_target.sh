# shellcheck disable=SC2148
valid_current_android_target_pass() {
    if [[ "$1" -ge 32 && "$1" -le 34 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android12/13，请选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}
