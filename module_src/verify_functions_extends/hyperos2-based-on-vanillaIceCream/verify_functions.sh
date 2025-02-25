# shellcheck disable=SC2148

# 检查Android API版本
verify_android_api_has_pass() {
    local api_num=$(printf "%d" "$1")
    if [[ "$api_num" -ne 35 ]]; then
        ui_print "*********************************************"
        ui_print "- 模块仅支持Android15，请重新选择正确版本的模块QwQ！！！"
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
    local sothx_disabled_os2_install_module_tips=$(getprop ro.sothx.disabled_os2_install_module_tips)

        if [[ -z "$sothx_disabled_os2_install_module_tips" ]]; then
        ui_print "*********************************************"
        ui_print "- 感谢使用<完美横屏应用计划>Hyper OS 2.0版本~"
        ui_print "- 请了解以下使用须知："
        ui_print "- 1.Hyper OS 2.0的模块必须搭配Web UI使用~"
        ui_print "- 2.在[平板专区-应用横屏布局]所做的任何修改会在重启后丢失~"
        ui_print "- 3.如需修改应用横屏适配，请前往Web UI进行修改~"
        ui_print "- 4.可前往[模块设置-模块使用须知]，禁用该提醒"
        ui_print "- (Tips:请随意选择，不影响模块安装过程~)"
        ui_print "  音量+ ：已了解使用须知"
        ui_print "  音量- ：已了解使用须知"
        ui_print "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            ui_print "*********************************************"
            ui_print "- 正在进入模块安装流程~"
            ui_print "*********************************************"
        else
            ui_print "*********************************************"
            ui_print "- 正在进入模块安装流程~"
            ui_print "*********************************************"
        fi
    else
        ui_print "*********************************************"
        ui_print "- 您已选择跳过模块使用须知~"
        add_props "ro.sothx.disabled_os2_install_module_tips=true"
        ui_print "*********************************************"
    fi

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
            add_props "ro.config.sothx_miui_device_code=$sothx_miui_device_code"
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
        add_props "ro.config.sothx_miui_device_code=${device_code}"
        /bin/cp -rf "$MODPATH/common/source/miui_embedding_window_service/${device_code}/${API}/"* "$MODPATH/system/system_ext/framework/"
        /bin/chmod -R 777 "$MODPATH/system/system_ext/framework/"
    else
        return 1  # 选择否，返回1
    fi
}

device_selection() {
    # 第一个设备选择判断（简化）
    if ! select_device "小米平板7" "uke" "$API"; then
        # 第二个设备选择判断
        if ! select_device "小米平板7 Pro" "muyu" "$API"; then
            # 第三个设备选择判断
            if ! select_device "小米平板6S Pro" "sheng" "$API"; then
                # 第四个设备选择判断
                if ! select_device "小米平板6 Max" "yudi" "$API"; then
                    # 第五个设备选择判断
                    if ! select_device "小米平板6 Pro" "liuqin" "$API"; then
                        # 第六个设备选择判断
                        if ! select_device "红米平板 Pro" "dizi" "$API"; then
                            # 第七个设备选择判断
                            if ! select_device "红米平板 Pro 5G" "ruan" "$API"; then
                                # 第八个设备选择判断
                                if ! select_device "红米平板 SE" "xun" "$API"; then
                                    # 第九个设备选择判断
                                    if ! select_device "红米平板 SE 8.7 Wi-Fi" "flare" "$API"; then
                                        # 第十个设备选择判断
                                        if ! select_device "红米平板 SE 8.7 4G" "spark" "$API"; then
                                            ui_print "*********************************************"
                                            ui_print "- 全部机型都选择了否，安装失败了QwQ！！！"
                                            abort "*********************************************"
                                        fi
                                    fi
                                fi
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
}
