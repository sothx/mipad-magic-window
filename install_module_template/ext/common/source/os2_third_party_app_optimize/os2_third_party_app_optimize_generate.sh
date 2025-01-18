#!/bin/bash
MODULE_CUSTOM_CONFIG_PATH="/data/adb/MIUI_MagicWindow+"

# 输入文件
THIRD_PARTY_APP_OPTIMIZE_CONFIG="$MODULE_CUSTOM_CONFIG_PATH"/config/third_party_app_optimize.prop
# 输出文件
THIRD_PARTY_APP_OPTIMIZE_RESET_APP_MODE="$MODULE_CUSTOM_CONFIG_PATH"/config/third_party_app_optimize_reset_app_mode.sh

# 判断输入文件是否存在
if [[ -f "$THIRD_PARTY_APP_OPTIMIZE_CONFIG" ]]; then
    # 清空输出文件
    > "$THIRD_PARTY_APP_OPTIMIZE_RESET_APP_MODE"

    # 读取每一行
    while IFS=',' read -r package mode; do
        # 生成命令并写入输出文件
        echo "cmd miui_embedding_window set-appMode $package $mode" >> "$THIRD_PARTY_APP_OPTIMIZE_RESET_APP_MODE"
    done < "$THIRD_PARTY_APP_OPTIMIZE_CONFIG"
fi
