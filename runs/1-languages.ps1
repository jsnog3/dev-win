$wingetCommonArgs = @(
    '--silent',
    '--accept-package-agreements',
    '--accept-source-agreements',
    '--source', 'winget',
    '-e'
)

scoop bucket add main
scoop install main/go
scoop install main/nvm
scoop install main/lua

winget install --id Microsoft.DotNet.SDK.3_1 $wingetCommonArgs
winget install --id Microsoft.DotNet.SDK.6 $wingetCommonArgs
choco install dotnet-8.0-sdk -y
