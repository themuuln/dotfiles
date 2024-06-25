### .gitconfig
Remove-Item $HOME\.gitconfig
New-Item -ItemType SymbolicLink -Path $HOME\.gitconfig -Target $HOME\dotfiles\.gitconfig

### neovim

Remove-Item $HOME\AppData\Local\nvim
New-Item -ItemType SymbolicLink -Path $HOME\AppData\Local\nvim -Target $HOME\dotfiles\nvim
### nvim-vscode

Remove-Item $HOME\.config\nvim-vscode
New-Item -ItemType SymbolicLink -Path $HOME\.config\nvim-vscode -Target $HOME\dotfiles\nvim-vscode

### powershell
Remove-Item $HOME\.config\powershell
Remove-Item $HOME\.config\starship.toml
New-Item -ItemType SymbolicLink -Path $HOME\.config\powershell -Target $HOME\dotfiles\powershell
New-Item -ItemType SymbolicLink -Path $HOME\.config\starship.toml -Target $HOME\dotfiles\starship.toml
