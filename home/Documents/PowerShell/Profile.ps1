# Aliases
Function alias_chm { z "~\.local\share\chezmoi" }
Set-Alias "chm" alias_chm
Function alias_dotdot { cd .. }
Set-Alias ".." alias_dotdot 
Function alias_l { ls }
Set-Alias "l" alias_l
# Aliases - Git
Function alias_gs { git status $args }
Set-Alias "gs" alias_gs
Function alias_gpl { git pull $args }
Set-Alias "gpl" alias_gpl
Function alias_ga { git add $args }
Set-Alias "ga" alias_ga 

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
Function alias_cd { z $args }
Set-Alias "cd" alias_cd -Option AllScope

# Neovim
$env:XDG_CONFIG_HOME="~/.config"

# Completion
Set-PSReadlineKeyHandler -Chord Tab -Function MenuComplete
Set-PSReadlineOption -BellStyle None
