# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Zinit setup
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Load Powerlevel10k immediately
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Plugins with Turbo Mode (wait)
zinit wait lucid for \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    Aloxaf/fzf-tab

# Snippets with Turbo Mode
zinit wait lucid for \
    OMZL::git.zsh \
    OMZP::git \
    OMZP::sudo \
    OMZP::aws \
    OMZP::kubectl \
    OMZP::kubectx \
    OMZP::command-not-found

# Optimized compinit with caching
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
set -o vi

# History
HISTSIZE=10000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory hist_ignore_space hist_ignore_all_dups hist_save_no_dups hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

# Interactive tool inits
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
[[ -f ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh
eval "$(atuin init zsh)"

# Lazy-load Keychain Secrets
load_secrets() {
  export OPENROUTER_API=$(security find-generic-password -a "$USER" -s "OPENROUTER_API" -w)
  export GITLAB_TOKEN=$(security find-generic-password -a "$USER" -s "GITLAB_TOKEN" -w)
  export HAMUGA_SDK_KEY=$(security find-generic-password -a "$USER" -s "HAMUGA_SDK_KEY" -w)
  echo "Secrets loaded from Keychain."
}

# Aliases
alias vi='nvim'
alias vim='nvim'
alias ls='eza --color=always --long --icons=always --no-user'
alias l='eza --color=always --long --icons=always --no-user'
alias ll='eza --color=always --long --icons=always --no-user'
alias lg='lazygit'
alias oc='opencode'
alias cat='bat -pp'
alias ps='procs'
alias du='dust'
alias top='btm'
alias help='tlrc'
alias git-viz='gitui'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Interactive project switcher
pj() {
  local dir
  dir=$(find ~/coding ~/development -maxdepth 2 -type d 2> /dev/null | fzf --preview 'eza -T --level=2 --color=always {}')
  if [[ -n "$dir" ]]; then
    cd "$dir"
  fi
}

# React / React Native
alias ni='pnpm install'
alias ns='pnpm start'
alias nx='pnpm dlx'
alias nrd='pnpm run android'
alias nri='pnpm run ios'

# Flutter
alias fl='fvm flutter'
alias flr='fvm flutter run'
alias fld='fvm flutter devices'
alias flc='fvm flutter clean && fvm flutter pub get'

# glab aliases
alias gil='glab issue list'
alias gic='glab issue create'
alias gib='/Users/ict/.config/gitlab/issue-branch.sh'

# Project specific
alias air='$(go env GOPATH)/bin/air'

# Source Powerlevel10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Docker completions
fpath=(/Users/ict/.docker/completions $fpath)
eval "$(mise activate zsh)"
