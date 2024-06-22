# Alias
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias ll ls
Set-Alias g git

Invoke-Expression (&starship init powershell)
# List View on AutoCompletion
Set-PSReadLineOption -PredictionViewStyle ListView

# Icons
Import-Module -Name Terminal-Icons

# Fzf
#Import-Module PSFzf
#Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

