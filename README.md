```
.\symlink.ps1
```
# Connect SymbolicLink on new Device

### nvim

```
New-Item -ItemType SymbolicLink -Path C:\Users\Themuln\AppData\Local\nvim -Target C:\Users\Themuln\dotfiles\nvim

```

### nvim-vscode

```
New-Item -ItemType SymbolicLink -Path C:\Users\Themuln\AppData\Local\nvim-vscode -Target C:\Users\Themuln\dotfiles\nvim-vscode

```
