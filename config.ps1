$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$dry = $false

Set-Location $scriptDir

foreach ($arg in $args)
{
    if ($arg -eq "--dry")
    {
        $dry = $true
    }
}

function Log
{
    param([string]$message)
    if ($dry)
    {
        Write-Host "[DRY_RUN]: $message"
    }
}

function Copy-Dir
{
    param (
        [string]$SourceDir,
        [string]$DestinationDir
    )

    Push-Location $SourceDir

    $dirs = Get-ChildItem -Directory

    foreach ($dir in $dirs)
    {
        $destPath = Join-Path $DestinationDir $dir.Name

        if ($dry)
        {
            log "remove: $destPath"
            log "copy from $dir.FullName to $destPath"

        } else
        {
            # Remove existing destination directory
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $destPath
            # Copy directory
            Copy-Item -Recurse -Force $dir.FullName -Destination $destPath
        }

    }

    Pop-Location
}


function Copy-File
{
    param (
        [string]$source,
        [string]$destination,
        [int]$dry_run = 0
    )


    if ($dry)
    {
        log "removing: $destination"
        log "copying: $source to $destination"

    } else
    {
        Remove-Item -Path $destination -ErrorAction SilentlyContinue
        Copy-Item -Path $source -Destination $destination
    }
}

# Call the function
Copy-Dir "config/.glzr" "$HOME/.glzr"
Copy-File "config/.wezterm.lua" "$HOME/.wezterm.lua"
Copy-File "config/.ideavimrc" "$HOME/.ideavimrc"
Copy-File "config/powershell/Microsoft.Powershell_profile.ps1" "$PROFILE"

