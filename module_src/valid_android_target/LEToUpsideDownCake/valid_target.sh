# shellcheck disable=SC2148
valid_current_android_target_pass() {
    if [[ "$1" -ge 34 && "$1" -le 35 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块当前仅支持Android14且暂不支持Android 15，请选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}
