# Symlink Example

1. Move Existing File or Directory to here
   ` Move-Item C:\Users\Themuuln\AppData\Local\nvim C:\Users\Themuuln\.dotfiles\nvim`

2. Create a Symlink
   ` New-Item -ItemType SymbolicLink -Path C:\Users\Themuuln\AppData\Local\nvim -Target C:\Users\Themuuln\.dotfiles\nvim`

# Connect SymbolicLink on new Device

### nvim

```
New-Item -ItemType SymbolicLink -Path C:\Users\Themuln\AppData\Local\nvim -Target C:\Users\Themuln\dotfiles\nvim

```

### nvim-vscode

```
New-Item -ItemType SymbolicLink -Path C:\Users\Themuln\AppData\Local\nvim-vscode -Target C:\Users\Themuln\dotfiles\nvim-vscode

```
