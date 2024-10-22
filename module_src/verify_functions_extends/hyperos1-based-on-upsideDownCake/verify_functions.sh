# shellcheck disable=SC2148
verify_android_api_has_pass() {
    api_num=$(printf "%d" "$1")
    if [[ "$api_num" -ne 34 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android14，请重新选择正确版本的模块QwQ！！！"
        ui_print "- Android 15 推荐安装[小米平板安卓15测试(Beta)版]模块，专版模块会在Hyper OS 2.0发布后才会考虑发布哦~"
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
    local sothx_miui_device_code=$(getprop ro.config.sothx_miui_device_code)
    # 目录不存在则创建目录
    if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
        /bin/mkdir -p "$MODPATH/system/system_ext/framework"
    fi
    if [[ -z "$sothx_miui_device_code" ]]; then
        ui_print "*********************************************"
        ui_print "- 请选择符合你当前系统的机型代号(移植包请以移植包的机型为准)"
        ui_print "- 是否为小米平板6S Pro(sheng)？"
        ui_print "  音量+ ：是"
        ui_print "  音量- ：否"
        ui_print "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            ui_print "- 正在为你写入小米平板6S Pro(sheng)的模块配置文件"
            add_props "\n# 模块机型:小米平板6S Pro(sheng)\n"
            add_props "ro.config.sothx_miui_device_code=sheng"
            /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/sheng/$API/"* "$MODPATH/system/system_ext/framework/"
            /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
        else
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
                /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/yudi/$API/"* "$MODPATH/system/system_ext/framework/"
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
                    /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/liuqin/$API/"* "$MODPATH/system/system_ext/framework/"
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
                        /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/pipa/$API/"* "$MODPATH/system/system_ext/framework/"
                        /bin/cp -rf "$MODPATH/common/source/miui_autoui_service/pipa/$API/"* "$MODPATH/system/system_ext/framework/"
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
                            /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/dagu/$API/"* "$MODPATH/system/system_ext/framework/"
                            /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
                        else
                            ui_print "*********************************************"
                            ui_print "- 全部机型都选择了否，安装失败了QwQ！！！"
                            abort "*********************************************"
                        fi
                    fi
                fi
            fi
        fi
    else
        if [ -d "$MODPATH/common/source//miui_embedding_window_service/$sothx_miui_device_code/$API/" ]; then
            ui_print "*********************************************"
            ui_print "- 正在为你修补"应用横屏布局"有关的系统文件"
            ui_print "*********************************************"
            /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/$sothx_miui_device_code/$API/"* "$MODPATH/system/system_ext/framework/"
        fi
        if [ -d "$MODPATH/common/source/miui_autoui_service/$sothx_miui_device_code/$API/" ]; then
            ui_print "*********************************************"
            ui_print "- 正在为你修补"应用布局优化"有关的系统文件"
            ui_print "*********************************************"
            /bin/cp -rf "$MODPATH/common/source/miui_autoui_service/$sothx_miui_device_code/$API/"* "$MODPATH/system/system_ext/framework/"
        fi
        /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
    fi
}
