export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

typeset -U path PATH
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$HOME/go/bin"
  $path
)
export PATH

export EDITOR="nvim"
export VISUAL="nvim"
export SUDO_EDITOR="nvim"
export MANPAGER="nvim +Man!"

export DO_NOT_TRACK=1
export LESSHISTFILE=-
export PYTHON_HISTORY=/dev/null
export SQLITE_HISTORY=/dev/null
# export DOTNET_CLI_TELEMETRY_OPTOUT=1
# export NEXT_TELEMETRY_DISABLED=1
