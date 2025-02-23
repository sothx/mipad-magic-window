MODDIR=${0%/*}

key_check() {
    while true; do
        key_check=$(/system/bin/getevent -qlc 1)
        key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
        key_status=$(echo "$key_check" | awk '{ print $4 }')
        if [[ "$key_event" == *"KEY_"* && "$key_status" == "DOWN" ]]; then
            keycheck="$key_event"
            break
        fi
    done
    while true; do
        key_check=$(/system/bin/getevent -qlc 1)
        key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
        key_status=$(echo "$key_check" | awk '{ print $4 }')
        if [[ "$key_event" == *"KEY_"* && "$key_status" == "UP" ]]; then
            break
        fi
    done
}

if [[ "$KSU" == "true" || "$APATCH" == "true" ]]; then
    echo "*********************************************"
    echo "正在重新载入"自定义规则"的配置ww"
    echo "*********************************************"

    sh "$MODDIR"/common/source/update_rule/update_rule.sh || true

    echo "*********************************************"
    echo "模块已重新载入"自定义规则"，更新成功了ww"
    echo "*********************************************"

    sleep 3 # 延迟5秒
else
    HAS_BEEN_INSTALLED_KsuWebUI_APK=$(pm list packages | grep io.github.a13e300.ksuwebui)
    if [[ $HAS_BEEN_INSTALLED_KsuWebUI_APK == *"package:io.github.a13e300.ksuwebui"* ]]; then
        echo "- 正在打开Web UI，请稍等~"
        am start -n io.github.a13e300.ksuwebui/.WebUIActivity -e id MIUI_MagicWindow+
    else
        echo "*********************************************"
        echo "- 是否安装KsuWebUI？"
        echo "- [重要提醒]: 安装并赋予Root权限可以可视化管理模块提供的部分功能"
        echo "  音量+ ：是"
        echo "  音量- ：否"
        echo "*********************************************"
        key_check
        if [[ "$keycheck" == "KEY_VOLUMEUP" ]]; then
            echo "- 正在为你安装KSU Web UI，请稍等~"
            pm install -r "$MODPATH"/common/apks/KsuWebUI.apk &>/dev/null
            HAS_BEEN_INSTALLED_KsuWebUI_APK=$(pm list packages | grep io.github.a13e300.ksuwebui)
            if [[ $HAS_BEEN_INSTALLED_KsuWebUI_APK == *"package:io.github.a13e300.ksuwebui"* ]]; then
                echo "- 好诶，KSUWebUI安装完成！"
                sleep 5 # 延迟5秒
            else
                abort "- KSUWebUI安装失败，请尝试重新安装！"
                abort "- 也可前往模块网盘下载单独的 KsuWebUI apk 进行手动安装！"
                sleep 5 # 延迟5秒
            fi
        else
            echo "*********************************************"
            echo "- 你选择不安装KsuWebUI"
            echo "*********************************************"
            sleep 5 # 延迟5秒
        fi
    fi
fi
