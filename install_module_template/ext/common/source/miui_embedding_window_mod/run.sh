#!/bin/bash
# shellcheck disable=SC2003,SC2046,SC2086,SC2162
workfile=${0%/*}
APKEditor="java -jar $workfile/../../tools/jar/APKEditor.jar"
mkdir -p $workfile/tmp/
$APKEditor d -f -i $workfile/miui-embedding-window.jar -o $workfile/miui-embedding-window 2>&1 1>&/dev/null

# 应用横屏布局服务异常修复
# 查找原函数位置
smali_mod1=$(find $workfile/miui-embedding-window/smali/*/com/android/server/wm/ -type f -iname "MiuiSystemEmbeddedRule.smali")
start_line=$(grep -n -m 1 "invoke-static {}, Landroid/sizecompat/MiuiSizeCompatManager;->getMiuiSizeCompatEnabledApps()Ljava/util/Map;" $smali_mod1 | cut -d: -f1)
# 从.start_line开始查找第一个move-result-object v2行号
end_line=$(tail -n +"$start_line" $smali_mod1 | grep -n -m 1 "move-result-object v2" | cut -d: -f1)
# 计算.end method的行号
actual_end_line=$((start_line + end_line - 1))
# 删除原方法
sed -i "${start_line},${actual_end_line}d" $smali_mod1
# 插入新方法
sed -i "$((start_line - 1))r $workfile/add1.txt" $smali_mod1

$APKEditor b -f -i $workfile/miui-embedding-window -o $workfile/miui-embedding-window_out.jar 2>&1 1>&/dev/null
