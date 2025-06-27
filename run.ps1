$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$filters = @()
$dry = $false
$failedScripts = @()

Set-Location $scriptDir

# Get all executable files in the 'runs' directory
$scripts = Get-ChildItem -Path "runs" -File -Filter "*.ps1" | Sort-Object

# Parse arguments
foreach ($arg in $args)
{
    if ($arg -eq "--dry")
    {
        $dry = $true
    } else
    {
        $filters += $arg
    }
}

function Log
{
    param([string]$message)
    if ($dry)
    {
        Write-Host "[DRY_RUN]: $message"
    } else
    {
        Write-Host $message
    }
}

function Execute($scriptPath)
{
    Write-Host "execute: $scriptPath"
    pwsh -File $scriptPath
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0)
    {
        throw "Script $scriptPath failed with exit code $exitCode"
    }
}

Log "run: filters $filters"

foreach ($script in $scripts)
{
    if ($filters -and -not ($filters | Where-Object { $script.Name.ToLower().Contains($_.ToLower()) }))
    {
        continue
    }

    try
    {
        if ($dry) {
            Log "running script: $($script.FullName)"
        } else {
            Log "running script: $($script.FullName)"
            Execute $script.FullName
        }
    } catch
    {
        $failedScripts += $script.FullName
        Write-Warning "Script $($script.FullName) failed: $($_.Exception.Message)"
    }
}

if ($failedScripts.Count -gt 0)
{
    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host "The following scripts failed:"
    foreach ($failedScript in $failedScripts)
    {
        Write-Host "- $failedScript"
    }
    Write-Host "----------------------------------------"
    Exit 1
} else
{
    Write-Host ""
    Write-Host "----------------------------------------"
    Write-Host "All scripts ran successfully."
    Write-Host "----------------------------------------"
}
