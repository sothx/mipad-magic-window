# shellcheck disable=SC2148
verify_android_api_has_pass() {
    if [[ "$1" -ne 33 && "$1" -ne 34 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块当前仅支持Android13/14且暂未适配Android 15，请重新选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}
