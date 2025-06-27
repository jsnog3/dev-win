$wingetcommonargs = @(
    '--silent',
    '--accept-package-agreements',
    '--accept-source-agreements',
    '--source', 'winget',
    '-e'
)

winget install --id Microsoft.PowerShell $wingetCommonArgs
winget install --id Git.Git $wingetCommonArgs
winget install --id Neovim.Neovim $wingetCommonArgs
winget install --id Microsoft.PowerToys $wingetCommonArgs
winget install --id Mozilla.Firefox $wingetCommonArgs

Set-ExecutionPolicy Bypass -Scope Process -Force;

$script = @'
Invoke-RestMethod -Uri https://get.scoop.sh | Invoke-Expression
'@

$tempScript = "$env:Temp\install_scoop.ps1"
$script | Out-File -Encoding UTF8 -FilePath $tempScript

# Run unelevated PowerShell instance
Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$tempScript`"" -Verb RunAsUser

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

scoop add bucket extras
scoop install extras/glazewm
winget install --id wez.wezterm $wingetCommonArgs
git clone https://github.com/danielcopper/wezterm-session-manager.git $HOME/.config/wezterm/wezterm-session-manager
