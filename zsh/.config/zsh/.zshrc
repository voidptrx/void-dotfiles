# .zshrc

# ── History ───────────────────────────────────────────────────
HISTFILE="$ZDOTDIR/.zhistory"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

# ── Completion ────────────────────────────────────────────────
fpath+=$ZDOTDIR/.zfunc
zstyle :compinstall filename '$ZDOTDIR/.zshrc'
autoload -Uz compinit && compinit
autoload -U colors && colors
_comp_options+=(globdots)

# ── General Options ──────────────────────────────────────────
setopt AUTO_CD
setopt CORRECT
bindkey -v

bindkey '^ ' autosuggest-accept        # Ctrl+Space
bindkey '^f' autosuggest-accept        # Ctrl+F

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down

zle -N paste-clipboard
bindkey -M viins '^P' paste-clipboard
bindkey -M vicmd 'p' paste-clipboard

# ── Environment ───────────────────────────────────────────────
export EDITOR='nvim'
export SUDO_EDITOR='nvim'
export MYVIMRC='/home/can/.config/nvim/init.lua'
export MANPAGER='nvim +Man!'

# ── Aliases ───────────────────────────────────────────────────
alias ls='ls --color=auto'
alias lsd='lsd -AFlgh --header'
alias bigtime='bigtime --file simple -sdfi -F 2'
alias rusty-rain='rusty-rain -g jap -s'

# ── Functions ─────────────────────────────────────────────────
timer() {
    command timer "$@" -f && paplay /usr/share/sounds/freedesktop/stereo/complete.oga
}

# topgrade command with ssh
tgs() {
  eval $(ssh-agent)
  trap 'ssh-agent -k > /dev/null; unset SSH_AUTH_SOCK SSH_AGENT_PID; echo "[-] SSH Agent closed."' EXIT INT TERM
  ssh-add ~/.ssh/id_ed25519 || { echo "[-] Failed to add key, exiting."; return 1; }
  topgrade "$@"
}

function paste-clipboard() {
  LBUFFER+="$(wl-paste --no-newline)"
  zle redisplay
}

# ── Prompt ────────────────────────────────────────────────────
autoload -U colors && colors
autoload -Uz vcs_info add-zsh-hook
setopt PROMPT_SUBST

zstyle ':vcs_info:git:*' enable git
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

add-zsh-hook precmd precmd

last_status=0

precmd() {
    last_status=$?
    vcs_info
    built_prompt
}

prompt_wrapper() {
    local retc="$1"
    local field_name="$2"
    local field_value="$3"
    local out="%F{$retc}─%B%F{green}[%b%f"
    [[ -n "$field_name" ]] && out+="${field_name}:"
    out+="%F{$retc}${field_value}%B%F{green}]%b%f"
    echo -n "$out"
}

built_prompt() {
    local retc=green
    [[ $last_status -ne 0 ]] && retc=red

    local p=""

    # ┬─[user@host:path]
    p+="%F{$retc}┬─%B%F{green}[%b"

    if [[ $EUID -eq 0 ]]; then
        p+="%B%F{red}%n%b"
    else
        p+="%B%F{yellow}%n%b"
    fi

    p+="%B%F{white}@%b"

    if [[ -n "$SSH_CLIENT" ]]; then
        p+="%B%F{cyan}%m%b"
    else
        p+="%B%F{blue}%m%b"
    fi

    p+="%B%F{white}:%b%F{$retc}%~%B%F{green}]%b%f"

    # Date
    p+="$(prompt_wrapper $retc '' $(date +%X))"

    # Virtual Env
    if [[ -n "$VIRTUAL_ENV" ]]; then
        p+="$(prompt_wrapper $retc 'V' $(basename "$VIRTUAL_ENV"))"
    fi

    # Git
    if [[ -n "${vcs_info_msg_0_}" ]]; then
        local git_info="${vcs_info_msg_0_}"

        local upstream
        upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)
        if [[ -n "$upstream" ]]; then
            local ahead behind
            ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
            behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
            [[ $ahead -gt 0 ]]  && git_info+=" 󰛃 ${ahead}"
            [[ $behind -gt 0 ]] && git_info+=" 󰛀 ${behind}"
        fi

        local staged unstaged untracked
        staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
        unstaged=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
        untracked=$(git ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
        [[ $staged -gt 0 ]]    && git_info+="| ${staged}"
        [[ $unstaged -gt 0 ]]  && git_info+="| ${unstaged}"
        [[ $untracked -gt 0 ]] && git_info+="| ${untracked}"
        p+="$(prompt_wrapper $retc 'G' "$git_info")"
    fi

    # Battery
    if command -v acpi &>/dev/null; then
        if acpi -a 2>/dev/null | grep -q 'off-line'; then
            p+="$(prompt_wrapper $retc 'B' "$(acpi -b | cut -d' ' -f4-)")"
        fi
    fi

    p+=$'\n'

    # Jobs
    local job
    while IFS= read -r job; do
        [[ -n "$job" ]] && p+="%F{$retc}│ %F{yellow}${job}%f"$'\n'
    done < <(jobs 2>/dev/null)

    p+="%f%F{$retc}└─>%B%F{red}$ %b%f"

    PROMPT="$p"
}

# ── Autostart ────────────────────────────────────────────────
fastfetch
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
