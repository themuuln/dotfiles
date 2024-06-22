### Symlink Example

1. Move Existing File or Directory to here
   ` Move-Item C:\Users\Themuuln\AppData\Local\nvim C:\Users\Themuuln\.dotfiles\nvim`

2. Create a Symlink
   ` New-Item -ItemType SymbolicLink -Path C:\Users\Themuuln\AppData\Local\nvim -Target C:\Users\Themuuln\.dotfiles\nvim`
