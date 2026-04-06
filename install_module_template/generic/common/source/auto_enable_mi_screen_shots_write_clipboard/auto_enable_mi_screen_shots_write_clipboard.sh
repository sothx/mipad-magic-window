# shellcheck disable=SC2148
if [ "$(settings get secure mi_screen_shots_write_clipboard_enable)" !== "1" ]; then
  settings put secure mi_screen_shots_write_clipboard_enable 1
fi
