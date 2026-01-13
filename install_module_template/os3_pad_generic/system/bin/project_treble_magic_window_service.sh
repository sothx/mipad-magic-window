# shellcheck disable=SC2034,SC1073,SC2148
copy_and_lock_xml() {
    local src="$1"
    local dest="$2"

    if [ -f "$src" ]; then
        if [ -f "$dest" ]; then
            chattr -i "$dest"
        fi
        cp -f "$src" "$dest"
        chown 1000:1000 "$dest"
        chmod 0644 "$dest"
        chcon u:object_r:system_data_file:s0 "$dest"
        if [ -f "$dest" ]; then
            chattr +i "$dest"
        fi
    fi
}
