#!/system/bin/sh
# shellcheck disable=SC2148,SC1091,SC2086,SC2034,SC2154,SC2004

INPUT_DISPLAY_MODE_RECORD_ID="$1"
SYSTEM_DISPLAY_MODE_RECORD_ID=$(dumpsys display | grep 'mActiveModeId' | awk -F= '{print $2}')

# 校验参数必须传
if [ -z "$INPUT_DISPLAY_MODE_RECORD_ID" ]; then
  echo "用法：$0 <模式ID>"
  exit 1
fi

# 计算最终要设置的 id
CURRENT_ADJJSTED_ID=$((INPUT_DISPLAY_MODE_RECORD_ID - 1))

# 无论如何先设置一次当前配置
service call SurfaceFlinger 1035 i32 "$CURRENT_ADJJSTED_ID"

while true; do
  # 每次循环都重新获取当前系统显示模式ID
  SYSTEM_DISPLAY_MODE_RECORD_ID=$(dumpsys display | grep 'mActiveModeId' | awk -F= '{print $2}')

  # 只有 传入ID ≠ 当前系统ID 时才执行设置
  if [ "$INPUT_DISPLAY_MODE_RECORD_ID" != "$SYSTEM_DISPLAY_MODE_RECORD_ID" ]; then
    service call SurfaceFlinger 1035 i32 "$CURRENT_ADJJSTED_ID"
  fi

  # 等待 1 秒
  sleep 1
done
