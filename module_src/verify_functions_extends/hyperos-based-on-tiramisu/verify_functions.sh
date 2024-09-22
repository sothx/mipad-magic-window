# shellcheck disable=SC2148
verify_android_api_has_pass() {
    if [[ "$1" -ne 33 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android 13，请重新选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}
