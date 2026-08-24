param(
    [Parameter(Mandatory = $true)]
    [string]$Project,

    [Parameter(Mandatory = $true)]
    [string]$Server
)

$ErrorActionPreference = "Stop"

$root = (Get-Location).Path
$paramsFile = Join-Path $root ".github\ssis-params.yml"

$content = Get-Content $paramsFile

$projectBlock = $false
$solution = $null
$ispac = $null
$destination = $null

foreach ($line in $content) {

    if ($line -match "^\s{2}$Project`:\s*$") {
        $projectBlock = $true
        continue
    }

    if ($projectBlock -and $line -match "^\s{2}\S") {
        break
    }

    if ($projectBlock -and $line -match "^\s{4}solution:\s*[""']?(.*?)[""']?\s*$") {
        $solution = $matches[1]
    }

    if ($projectBlock -and $line -match "^\s{4}ispac:\s*[""']?(.*?)[""']?\s*$") {
        $ispac = $matches[1]
    }

    if ($projectBlock -and $line -match "^\s{4}destination:\s*[""']?(.*?)[""']?\s*$") {
        $destination = $matches[1]
    }
}

Write-Host "Project: $Project"
Write-Host "Solution: $solution"
Write-Host "ISPAC: $ispac"
Write-Host "Destination: $destination"

# ========================================
# BUILD
# ========================================

Write-Host ""
Write-Host "BUILD"

$devenv = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\devenv.exe"

if (!(Test-Path $devenv)) {
    Write-Error "devenv.exe not found: $devenv"
    exit 1
}

$buildProcess = Start-Process `
    -FilePath $devenv `
    -ArgumentList @(
        "`"$Solution`"",
        "/Build",
        "Development"
    ) `
    -Wait `
    -PassThru

Write-Host "devenv.exe exit code: $($buildProcess.ExitCode)"

if ($buildProcess.ExitCode -ne 0) {
    Write-Error "Build failed. Exit code: $($buildProcess.ExitCode)"
    exit $buildProcess.ExitCode
}

Write-Host "SUCCESS: Build completed."
# ========================================
# DEPLOY
# ========================================

Write-Host ""
Write-Host "DEPLOY"

$ispacFullPath = Join-Path $root $ispac.TrimStart(".\")

$wizard = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\Common7\IDE\CommonExtensions\Microsoft\SSIS\160\Binn\ISDeploymentWizard.exe"

Write-Host "Wizard: $wizard"
Write-Host "Source: $ispacFullPath"
Write-Host "Server: HQ01DB02"
Write-Host "Destination: $destination"


$arguments = @(
    "/Silent+"
    "/SourceType:File"
    "/ModelType:Project"
    "/SourcePath:$ispacFullPath"
    "/DestinationServer:$Server"
    "/DestinationAuthenticationType:Windows"
    "/DestinationPath:$destination"
)


$process = Start-Process `
    -FilePath $wizard `
    -ArgumentList $arguments `
    -Wait `
    -PassThru


Write-Host "ISDeploymentWizard exit code: $($process.ExitCode)"


if ($process.ExitCode -ne 0) {
    Write-Error "SSIS deployment failed. Exit code: $($process.ExitCode)"
    exit $process.ExitCode
}


Write-Host ""
Write-Host "SUCCESS: SSIS project deployed."
