# Wayland
export GDK_BACKEND="wayland,x11"
export QT_QPA_PLATFORM="wayland"
export CLUTTER_BACKEND="wayland"
export SDL_VIDEODRIVER="wayland"
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

# Fcitx5
export XMODIFIERS="@im=fcitx"
# export QT_IM_MODULE="fcitx"
# export GTK_IM_MODULE="fcitx"

# Start Sway
if [[ -z $WAYLAND_DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec dbus-run-session sway
fi
