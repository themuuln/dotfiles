export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.2.1.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
export PATH=$PATH:/Users/$USER/.spicetify
plugins=(git zsh-autosuggestions zsh-syntax-highlighting you-should-use tmux)
source $ZSH/oh-my-zsh.sh
[[ -f /Users/$USER/.dart-cli-completion/zsh-config.zsh ]] && . /Users/$USER/.dart-cli-completion/zsh-config.zsh || true
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
if [[ $FIND_IT_FASTER_ACTIVE -eq 1 ]]; then
  FZF_DEFAULT_OPTS='--height=50%'
fi
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval $(thefuck --alias)

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

export EDITOR="nvim"
export GEMINI_API=$(security find-generic-password -a "$USER" -s "GEMINI_API_2" -w)
export OPENROUTER_API=$(security find-generic-password -a "$USER" -s "OPENROUTER_API" -w)
export GITLAB_TOKEN=$(security find-generic-password -a "$USER" -s "GITLAB_TOKEN" -w)
export GITLAB_VIM_URL="https://git.ictgroup.mn/"
