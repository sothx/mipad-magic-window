# shellcheck disable=SC2148
verify_android_api_has_pass() {
    if [[ "$1" -ne 33 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android 13，请重新选择正确版本的模块QwQ！！！"
        abort "*********************************************"
    fi
}

verify_miui_based_on_tiramisu_pass() {
    local sothx_miui_device_code=$(grep_prop sothx_miui_device_code "$magisk_path$module_id/system.prop")
    # 目录不存在则创建目录
    if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
        /bin/mkdir -p "$MODPATH/system/system_ext/framework"
    fi
    if [ -z "$sothx_miui_device_code" ]; then
        ui_print "*********************************************"
        ui_print "- 请选择符合你当前系统的机型代号(移植包请以移植包的机型为准)"
        ui_print "- 是否为小米平板6 Max(yudi)？"
        ui_print "  音量+ ：是"
        ui_print "  音量- ：否"
        ui_print "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            ui_print "- 正在为你写入小米平板6 Max(yudi)的模块配置文件"
            add_props "\n# 模块机型:小米平板6 Max(yudi)\n"
            add_props "ro.config.sothx_miui_device_code=yudi"
            /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/yudi/"* "$MODPATH/system/system_ext/framework/"
            /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
        else
            ui_print "*********************************************"
            ui_print "- 请选择符合你当前系统的机型代号(移植包请以移植包的机型为准)"
            ui_print "- 是否为小米平板6 Pro(liuqin)？"
            ui_print "  音量+ ：是"
            ui_print "  音量- ：否"
            ui_print "*********************************************"
            key_check
            if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
                ui_print "- 正在为你写入小米平板6 Pro(liuqin)的模块配置文件"
                add_props "\n# 模块机型:小米平板6 Pro(liuqin)\n"
                add_props "ro.config.sothx_miui_device_code=liuqin"
                /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/liuqin/"* "$MODPATH/system/system_ext/framework/"
                /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
            else
                ui_print "*********************************************"
                ui_print "- 请选择符合你当前系统的机型代号(移植包请以移植包的机型为准)"
                ui_print "- 是否为小米平板6(pipa)？"
                ui_print "  音量+ ：是"
                ui_print "  音量- ：否"
                ui_print "*********************************************"
                key_check
                if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
                    ui_print "- 正在为你写入小米平板6(pipa)的模块配置文件"
                    add_props "\n# 模块机型:小米平板6(pipa)\n"
                    add_props "ro.config.sothx_miui_device_code=pipa"
                    /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/pipa/"* "$MODPATH/system/system_ext/framework/"
                    /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
                else
                    ui_print "*********************************************"
                    ui_print "- 全部机型都选择了否，安装失败了QwQ！！！"
                    abort "*********************************************"
                fi
            fi
        fi
    else
        /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/$sothx_miui_device_code/"* "$MODPATH/system/system_ext/framework/"
        /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
    fi
}
