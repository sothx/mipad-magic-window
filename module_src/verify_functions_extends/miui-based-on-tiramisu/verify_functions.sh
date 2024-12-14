# shellcheck disable=SC2148
verify_android_api_has_pass() {
    api_num=$(printf "%d" "$1")
    if [[ "$api_num" -ne 33 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块当前仅支持Android13，请重新选择正确版本的模块QwQ！！！"
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
    local sothx_miui_device_code=$(grep_prop ro.config.sothx_miui_device_code "$magisk_path$module_id/system.prop")
    # 目录不存在则创建目录
    if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
        /bin/mkdir -p "$MODPATH/system/system_ext/framework"
    fi
    if [ -z "$sothx_miui_device_code" ]; then

        ui_print "*********************************************"
        ui_print "- 专版模块不同于通用版，存在可能导致系统异常或者卡米的风险！"
        ui_print "- 请自备救砖模块，如若出现任何系统异常问题，建议切换为通用版模块，是否继续？"
        ui_print "  音量+ ：是，已了解模块风险"
        ui_print "  音量- ：否"
        ui_print "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            ui_print "*********************************************"
            ui_print "- 你选择了继续安装专版模块！！！"
            ui_print "*********************************************"
        else
            ui_print "*********************************************"
            ui_print "- 请重新选择正确版本的模块QwQ！！！"
            abort "*********************************************"
        fi

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
                    ui_print "- 请选择符合你当前系统的机型代号(移植包请以移植包的机型为准)"
                    ui_print "- 是否为小米平板5 Pro 12.4(dagu)？"
                    ui_print "  音量+ ：是"
                    ui_print "  音量- ：否"
                    ui_print "*********************************************"
                    key_check
                    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
                        ui_print "- 正在为你写入小米平板5 Pro 12.4(dagu)的模块配置文件"
                        add_props "\n# 模块机型:小米平板5 Pro 12.4(dagu)\n"
                        add_props "ro.config.sothx_miui_device_code=dagu"
                        /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/dagu/"* "$MODPATH/system/system_ext/framework/"
                        /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
                    else
                        ui_print "*********************************************"
                        ui_print "- 全部机型都选择了否，安装失败了QwQ！！！"
                        abort "*********************************************"
                    fi
                fi
            fi
        fi
    else
        if [ -d "$MODPATH/common/source//miui_embedding_window_service/$sothx_miui_device_code/" ]; then
            ui_print "*********************************************"
            ui_print "- 正在为你修补"应用横屏布局"有关的系统文件"
            ui_print "*********************************************"
            /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/$sothx_miui_device_code/"* "$MODPATH/system/system_ext/framework/"
        fi
        add_props "ro.config.sothx_miui_device_code=$sothx_miui_device_code"
        /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
    fi
}
