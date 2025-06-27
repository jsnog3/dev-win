$wingetCommonArgs = @(
    '--silent',
    '--accept-package-agreements',
    '--accept-source-agreements',
    '--source', 'winget',
    '-e'
)

winget install --id SlackTechnologies.Slack $wingetCommonArgs
winget install --id Zoom.Zoom $wingetCommonArgs

scoop bucket add extras
scoop install extras/chromium
