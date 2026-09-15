#!/system/bin/sh
# shellcheck disable=SC2148,SC1091,SC2086,SC2034,SC2154,SC2004

# 传入参数
INPUT_DISPLAY_MODE_RECORD_ID="$1"
INPUT_IS_DISABLE_DISPLAY_MODE_DAEMON_PROCESS="$2"

# 校验参数
if [ -z "$INPUT_DISPLAY_MODE_RECORD_ID" ]; then
  echo "用法：$0 <模式ID> [true/false]"
  echo "第二个参数传 true 仅单次设置，不后台循环守护"
  exit 1
fi

# 计算最终ID
CURRENT_ADJJSTED_ID=$((INPUT_DISPLAY_MODE_RECORD_ID - 1))

# 先执行一次设置
service call SurfaceFlinger 1035 i32 "$CURRENT_ADJJSTED_ID"

# 守护循环逻辑统一包裹，通过判断控制是否执行
if [ "$INPUT_IS_DISABLE_DISPLAY_MODE_DAEMON_PROCESS" != "true" ]; then
  while true; do
    # 获取当前系统ID
    SYSTEM_DISPLAY_MODE_RECORD_ID=$(dumpsys display | grep 'mActiveModeId' | awk -F= '{print $2}')

    # 判断是否需要重新设置
    if [ "$INPUT_DISPLAY_MODE_RECORD_ID" != "$SYSTEM_DISPLAY_MODE_RECORD_ID" ]; then
      service call SurfaceFlinger 1035 i32 "$CURRENT_ADJJSTED_ID"
    fi

    sleep 1
  done
fi
