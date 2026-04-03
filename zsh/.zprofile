[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Programming
export PATH="$HOME/.local/bin:$PATH"
export CARGO_HOME="$HOME/.cargo"
export GOPATH="$HOME/.local/go"

# Wayland
export GDK_BACKEND="wayland"
export QT_QPA_PLATFORM="wayland"
export CLUTTER_BACKEND="wayland"
export SDL_VIDEODRIVER="wayland"
export MOZ_ENABLE_WAYLAND=1
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=sway

# Fcitx5
export XMODIFIERS="@im=fcitx"
export QT_IM_MODULE="fcitx"
export GTK_IM_MODULE="fcitx"

# XDG Base Dir
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Start Sway
if [[ -z $WAYLAND_DISPLAY && $XDG_VTNR -eq 1 ]]; then
    exec dbus-run-session sway
fi
