# shellcheck disable=SC2148
verify_android_api_has_pass() {
    if [[ "$1" -ge 34 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android 15+，请重新选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}
