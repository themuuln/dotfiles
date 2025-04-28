export ZSH="$HOME/.oh-my-zsh"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.2.1.jdk/Contents/Home
export PATH="$JAVA_HOME/bin:$PATH"
[[ -f /Users/$USER/.dart-cli-completion/zsh-config.zsh ]] && . /Users/$USER/.dart-cli-completion/zsh-config.zsh || true
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
if [[ $FIND_IT_FASTER_ACTIVE -eq 1 ]]; then
  FZF_DEFAULT_OPTS='--height=50%'
fi

### export paths
export PATH=$PATH:/Users/$USER/.spicetify
export PATH="/Users/$USER/development/flutter/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export STARSHIP_CONFIG=~/.config/starship/starship.toml
export EDITOR="nvim"

### cli init
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
eval "$(starship init zsh)"
eval $(thefuck --alias)

### aliases
# EZA
alias ls="eza --color=always --long --git --icons=always --no-user"
alias ll="eza --color=always --long --git --icons=always --no-user"
alias l="eza -l --icons --git -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias ltree="eza --tree --level=2  --icons --git"
alias vi='nvim'
alias cd='z'
alias vim='nvim'
alias f='fuck'


# setup new key guide
# security add-generic-password -a "$USER" -s "my_api_key_name" -w "your-secret-api-key" -U 
# export GEMINI_API=$(security find-generic-password -a "$USER" -s "GEMINI_API" -w)
export GEMINI_API=$(security find-generic-password -a "$USER" -s "GEMINI_API_2" -w)
export OPENROUTER_API=$(security find-generic-password -a "$USER" -s "OPENROUTER_API" -w)
