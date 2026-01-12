# Setup

```bash
brew install eza fd fzf git ripgrep thefuck tmux zsh zoxide yazi neovim aerospace bat ghostty lazygit starship
```

## For delta

```bash
wget --output-document ~/delta-themes.gitconfig https://raw.githubusercontent.com/dandavison/delta/master/themes.gitconfig
git config --global include.path  "~/delta-themes.gitconfig"
git config --global delta.features "collared-trogon"
```

```bash
mkdir -p "$(bat --config-dir)/themes"
cd "$(bat --config-dir)/themes"
# Replace _night in the lines below with _day, _moon, or _storm if needed.
curl -O https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/sublime/tokyonight_night.tmTheme
bat cache --build
bat --list-themes | grep tokyo # should output "tokyonight_night"
echo '--theme="tokyonight_night"' >> "$(bat --config-dir)/config"
```
