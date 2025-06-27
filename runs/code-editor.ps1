$wingetCommonArgs = @(
    '--silent',
    '--accept-package-agreements',
    '--accept-source-agreements',
    '--source', 'winget',
    '-e'
)

winget install --id VSCodium.VSCodium $wingetCommonArgs
winget install --id JetBrains.Rider $wingetCommonArgs

# dependencies for neovim config
choco install -y wget unzip gzip mingw make
scoop bucket add main
scoop install main/fd
scoop install main/ripgrep
