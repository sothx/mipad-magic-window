#!/system/bin/sh
# shellcheck disable=SC2148,SC1091,SC2086,SC2034,SC2154,SC2004

# 传入参数
INPUT_DISPLAY_MODE_RECORD_ID="$1"

# 校验参数
if [ -z "$INPUT_DISPLAY_MODE_RECORD_ID" ]; then
  echo "用法：$0 <模式ID>"
  exit 1
fi

# 计算最终ID
CURRENT_ADJJSTED_ID=$((INPUT_DISPLAY_MODE_RECORD_ID - 1))

service call SurfaceFlinger 1035 i32 "$CURRENT_ADJJSTED_ID"

# 循环守护
while true; do
  # 获取当前系统ID
  SYSTEM_DISPLAY_MODE_RECORD_ID=$(dumpsys display | grep 'mActiveModeId' | awk -F= '{print $2}')

  # 判断是否需要重新设置
  if [ "$INPUT_DISPLAY_MODE_RECORD_ID" != "$SYSTEM_DISPLAY_MODE_RECORD_ID" ]; then
    service call SurfaceFlinger 1035 i32 "$CURRENT_ADJJSTED_ID"
  fi

  sleep 1
done
