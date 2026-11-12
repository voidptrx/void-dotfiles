# History
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS

zshaddhistory() {
  emulate -L zsh
  setopt EXTENDED_GLOB
  [[ $1 == (#i)*(passw|token|secret|api[_-]#key|authorization|bearer)* ]] && return 2
  return 0
}

# Completion
fpath=("$ZDOTDIR/completions" $fpath)
autoload -Uz compinit

() {
  setopt LOCAL_OPTIONS EXTENDED_GLOB
  local zcd="$XDG_CACHE_HOME/zsh/zcompdump"
  if [[ -n $zcd(#qN.mh+24) ]]; then
    compinit -d "$zcd"
  else
    compinit -C -d "$zcd"
  fi
}
_comp_options+=(globdots)
alias rcomp='rm -f -- $XDG_CACHE_HOME/zsh/zcompdump*(N); exec zsh'

# General Options
setopt AUTO_CD
setopt CORRECT
bindkey -v
KEYTIMEOUT=10

# Aliases
# alias ls='ls --color=auto'
# alias lsd='lsd -AFlgh --header'
# alias ls="lsd"
alias bigtime='bigtime --file simple -sdfi -F 2'
alias rusty-rain='rusty-rain -g classic -d down -s -C 0,190,65 -H 225,255,235 -S 55,170'
alias mcat='mcat -t kanagawa'
alias searxng-up='docker compose --project-directory $HOME/Projects/searxng up -d'
alias searxng-down='docker compose --project-directory $HOME/Projects/searxng down'
alias clear='neoclear \
  -d top \
  -t 1100 \
  -f 350 \
  --fade-steps 14 \
  --fps 60 \
  -c "#00ff41" \
  --head-color "#72f58d" \
  --colormode truecolor \
  --trail 16 \
  --rest 0.25 \
  --speed 0 \
  -s 4 \
  --stagger 0.85 \
  --glitch 0.06 \
  --chars FF66-FF9D'

# Functions
# topgrade command with ssh
tgs() {
  (
    eval "$(ssh-agent -s)" >/dev/null || exit 1
    trap 'ssh-agent -k >/dev/null 2>&1' EXIT

    ssh-add "$HOME/.ssh/id_ed25519" || exit 1

    topgrade "$@"
  )
}

paste-clipboard() {
  LBUFFER+="$(wl-paste --no-newline)"
  zle redisplay
}

custom_clear_widget() {
  clear
  zle redisplay
}

zle -N paste-clipboard
zle -N custom_clear_widget

# Prompt
unsetopt PROMPT_SUBST
zmodload zsh/parameter

precmd() {
  local exit_code=$?
  local color=green host_color=magenta dir=${PWD:A} venv job

  (( exit_code )) && color=red
  [[ -n $SSH_CONNECTION || -n $SSH_CLIENT ]] && host_color=cyan

  # User, host, working directory
  local p='[%(!.%F{red}.%F{green})%n%f@'
  p+="%F{$host_color}%m%f]: %F{cyan}%~%f"

  # Virtual environment
  if [[ -n $VIRTUAL_ENV ]]; then
    venv=${VIRTUAL_ENV:t}
    p+=" %F{yellow}[venv:${venv//\%/%%}]%f"
  fi

  # Find a .git marker, including through symlinked paths
  while true; do
    if [[ -e $dir/.git ]]; then
      p+=' %F{green}[.git]%f'
      break
    fi
    [[ $dir == / ]] && break
    dir=${dir:h}
  done

  # Show the actual exit code on failure
  (( exit_code )) && p+=" %F{red}[exit:$exit_code]%f"

  # Jobs, ordered by job number
  for job in ${(kon)jobtexts}; do
    p+=$'\n'"%F{yellow}[$job] ${jobstates[$job]%%:*}%f ${jobtexts[$job]//\%/%%}"
  done

  PROMPT=$p$'\n'"%F{$color}%(!.#.>)%f "
}

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

# Keybindings
bindkey '^ ' autosuggest-accept
bindkey '^f' autosuggest-accept
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[OA' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M viins '^[OB' history-substring-search-down
bindkey -M viins '^P' paste-clipboard
bindkey -M vicmd 'p'  paste-clipboard
bindkey '^L' custom_clear_widget
