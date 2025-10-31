$env:TERM = "msys"

# zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-PSReadlineOption -EditMode vi
Set-PSReadlineOption -BellStyle None

# Basic Git shortcuts
function gs
{
    git status
}
function ga
{
    git add .
}
function gc
{
    git commit -m $args
}
function gca
{
    git commit -am $args
}
function gpl
{
    git pull
}
function gph
{
    git push
}

# Branch operations
function gb
{
    git branch $args
}
function gc-
{
    git checkout -
}
function gco
{
    git checkout $args
}
function gm
{
    git merge $args
}

# Log and history
function gll
{
    git log --oneline -10
}
function glll
{
    git log --oneline --graph --decorate --all
}
function gdf
{
    git diff $args
}

# Remote operations
function gf
{
    git fetch
}

# Stash operations
function gst
{
    git stash push -m $args
}
function gstp
{
    git stash pop
}
function gstl
{
    git stash list
}
function gstclear
{
    git stash clear
}

# Undo operations
function gundo
{
    git reset --soft HEAD~1
}
function greset
{
    git reset --hard HEAD
}

# More advanced shortcuts
function gclean
{
    git branch --merged | Where-Object { $_ -notmatch "main|master|develop" } | ForEach-Object { git branch -d $_.Trim() }
}

## cget cset

$Global:CliCommandFile = "$HOME\personal\dev-win-private\cli-commands.txt"

function cset {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    if (Test-Path $CliCommandFile) {
        $exists = Get-Content $CliCommandFile | Where-Object { $_ -ieq $Command }
        if ($exists) {
            Write-Host "Command already saved. Skipping."
            return
        }
    }

    Add-Content -Path $CliCommandFile -Value $Command
    Write-Host "Saved: $Command"
}

function cget {
    Get-Content $CliCommandFile | fzf | clip
}

## notifications

function notify {
    New-BurntToastNotification -Text "PowerShell", "Command has completed"
}

