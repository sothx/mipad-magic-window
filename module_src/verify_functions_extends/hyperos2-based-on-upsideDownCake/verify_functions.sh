# shellcheck disable=SC2148

# 检查Android API版本
verify_android_api_has_pass() {
    local api_num=$(printf "%d" "$1")
    if [[ "$api_num" -ne 34 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android14，请重新选择正确版本的模块QwQ！！！"
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

    local mi_os_version_name=$(grep_prop ro.mi.os.version.code /mi_ext/etc/build.prop)
    if [[ -z "$mi_os_version_name" || "$mi_os_version_name" != "2" && "$mi_os_version_name" -ne 2 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Hyper OS 2，请重新选择正确版本的模块QwQ！！！"
        ui_print "- 您可以选择强制安装Hyper OS版本不受支持的模块，但可能导致系统出现各种异常，是否继续？"
        ui_print "  音量+ ：哼，我偏要装(强制安装)"
        ui_print "  音量- ：否"
        ui_print "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            ui_print "*********************************************"
            ui_print "- 你选择了强制安装Hyper OS版本不受支持的模块！！！"
            ui_print "*********************************************"
        else
            ui_print "*********************************************"
            ui_print "- 请重新选择正确版本的模块QwQ！！！"
            abort "*********************************************"
        fi
    fi
}

# 处理专版模块
verify_special_rule_pass() {
    local sothx_miui_device_code=$(grep_prop ro.config.sothx_miui_device_code "$magisk_path$module_id/system.prop")

    # 目录不存在则创建目录
    if [[ ! -d "$MODPATH/system/system_ext/framework" ]]; then
        /bin/mkdir -p "$MODPATH/system/system_ext/framework"
    fi

    if [[ -z "$sothx_miui_device_code" ]]; then
        ui_print "*********************************************"
        ui_print "- 专版模块不同于通用版，存在可能导致系统异常或者卡米的风险！"
        ui_print "- 专版模块仅对 Hyper OS 2 最新版本做兼容，请确保系统版本为最新！"
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

        # 机型选择
        device_selection
    else
        if [ -d "$MODPATH/common/source/miui_embedding_window_service/$sothx_miui_device_code/$API/" ]; then
            ui_print "*********************************************"
            ui_print "- 正在为你修补应用横屏布局有关的系统文件"
            ui_print "*********************************************"
            /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/$sothx_miui_device_code/$API/"* "$MODPATH/system/system_ext/framework/"
            add_lines "ro.config.sothx_miui_device_code=$sothx_miui_device_code" "$MODPATH"/system.prop
            /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
        fi
    fi
}

select_device() {
    local device_name=$1
    local device_code=$2
    local api_path=$3

    ui_print "*********************************************"
    ui_print "- 请选择符合你当前系统的机型代号(移植包请以移植包的机型为准)"
    ui_print "- 是否为${device_name}(${device_code})？"
    ui_print "  音量+ ：是"
    ui_print "  音量- ：否"
    ui_print "*********************************************"
    key_check

    if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
        ui_print "- 正在为你写入${device_name}(${device_code})的模块配置文件"
        add_lines "ro.config.sothx_miui_device_code=${device_code}" "$MODPATH"/system.prop
        /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/${device_code}/${API}/"* "$MODPATH/system/system_ext/framework/"
        /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
    else
        return 1  # 选择否，返回1
    fi
}

device_selection() {
    # 第一个设备选择判断（简化）
    if ! select_device "小米平板6" "pipa" "$API"; then
        # 第二个设备选择判断
        if ! select_device "小米平板5 Pro 12.4" "dagu" "$API"; then
            ui_print "*********************************************"
            ui_print "- 全部机型都选择了否，安装失败了QwQ！！！"
            abort "*********************************************"
        fi
    fi
}
