$wingetCommonArgs = @(
    '--silent',
    '--accept-package-agreements',
    '--accept-source-agreements',
    '--source', 'winget',
    '-e'
)

winget install --id Discord.Discord $wingetCommonArgs
winget install --id Spotify.Spotify $wingetCommonArgs
winget install --id Obsidian.Obsidian $wingetCommonArgs
