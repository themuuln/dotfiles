export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.2.1.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
export PATH=$PATH:/Users/$USER/.spicetify
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use tmux)
# Faster completion initialization
autoload -Uz compinit
if [[ -n ${ZSH_COMPDUMP:#(#s)$HOME/.zcompdump-.(N[1,24].) ]]; then
  compinit
else
  compinit -C
fi

source $ZSH/oh-my-zsh.sh
[[ -f /Users/$USER/.dart-cli-completion/zsh-config.zsh ]] && . /Users/$USER/.dart-cli-completion/zsh-config.zsh || true
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
if [[ $FIND_IT_FASTER_ACTIVE -eq 1 ]]; then
  FZF_DEFAULT_OPTS='--height=50%'
fi
# Faster tool initialization
if [[ ! -f ~/.cache/zsh/zoxide_init.zsh ]]; then
  mkdir -p ~/.cache/zsh
  zoxide init zsh > ~/.cache/zsh/zoxide_init.zsh
fi
source ~/.cache/zsh/zoxide_init.zsh

if [[ ! -f ~/.cache/zsh/starship_init.zsh ]]; then
  mkdir -p ~/.cache/zsh
  starship init zsh > ~/.cache/zsh/starship_init.zsh
fi
source ~/.cache/zsh/starship_init.zsh

# Lazy load fzf
fzf() {
  unfunction fzf
  eval "$(command fzf --zsh)"
  fzf "$@"
}

alias fuck='eval $(thefuck $(fc -ln -1))'

export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

export PATH="/Users/$USER/.codeium/windsurf/bin:$PATH"
export PATH="/Users/$USER/development/flutter/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

alias ls="eza --color=always --long --git --icons=always --no-user"
alias ll="eza --color=always --long --git --icons=always --no-user"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias f='fuck'
# glab aliases
alias gil='glab issue list'
alias gib='/Users/ict/.config/gitlab/issue-branch.sh'

# API Tokens Caching
TOKEN_CACHE="$HOME/.cache/zsh/api_tokens.zsh"
if [[ -f "$TOKEN_CACHE" ]]; then
  source "$TOKEN_CACHE"
else
  mkdir -p "$(dirname "$TOKEN_CACHE")"
  echo "export GEMINI_API=\"$(security find-generic-password -a "$USER" -s "GEMINI_API_2" -w 2>/dev/null)\"" > "$TOKEN_CACHE"
  echo "export OPENROUTER_API=\"$(security find-generic-password -a "$USER" -s "OPENROUTER_API" -w 2>/dev/null)\"" >> "$TOKEN_CACHE"
  echo "export GITLAB_TOKEN=\"$(security find-generic-password -a "$USER" -s "GITLAB_TOKEN" -w 2>/dev/null)\"" >> "$TOKEN_CACHE"
  source "$TOKEN_CACHE"
fi
export GITLAB_VIM_URL="https://git.ictgroup.mn/"

export EDITOR="nvim"
