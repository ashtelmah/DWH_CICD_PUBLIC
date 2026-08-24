$ErrorActionPreference = "Stop"

Write-Host "========================================"
Write-Host "RUNNER CHECK"



# 1. SQL Server
Write-Host ""
Write-Host "1. SQL SERVER"

if (Test-NetConnection -ComputerName "HQ01DB02" -Port 1433 -InformationLevel Quiet) {
    Write-Host "SUCCESS: HQ01DB02:1433 is reachable."
}
else {
    Write-Error "ERROR: HQ01DB02:1433 is not reachable."
}


# 2. GitHub API
Write-Host ""
Write-Host "2. GITHUB INTERNET ACCESS"

if (Test-NetConnection -ComputerName "api.github.com" -Port 443 -InformationLevel Quiet) {
    Write-Host "SUCCESS: api.github.com:443 is reachable."
}
else {
    Write-Error "ERROR: api.github.com:443 is not reachable."
}


# 3. Visual Studio
Write-Host ""
Write-Host "3. VISUAL STUDIO"

$devenv = Get-ChildItem `
    "C:\Program Files (x86)\Microsoft Visual Studio" `
    -Filter "devenv.exe" `
    -Recurse `
    -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($null -eq $devenv) {
    Write-Error "ERROR: devenv.exe not found."
}
else {
    Write-Host "SUCCESS: devenv.exe found:"
    Write-Host $devenv.FullName
}


# 4. SSIS Deployment Wizard
Write-Host ""
Write-Host "4. SSIS DEPLOYMENT WIZARD"

$wizard = Get-ChildItem `
    "C:\Program Files (x86)\Microsoft Visual Studio" `
    -Filter "ISDeploymentWizard.exe" `
    -Recurse `
    -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($null -eq $wizard) {
    Write-Error "ERROR: ISDeploymentWizard.exe not found."
}
else {
    Write-Host "SUCCESS: ISDeploymentWizard.exe found:"
    Write-Host $wizard.FullName
}


# 5. SSRS
Write-Host ""
Write-Host "5. SSRS"

$rs = Get-ChildItem `
    "C:\Program Files\Microsoft SQL Server Reporting Services" `
    -Filter "rs.exe" `
    -Recurse `
    -ErrorAction SilentlyContinue |
    Select-Object -First 1

if ($null -eq $rs) {
    Write-Error "ERROR: rs.exe not found."
}
else {
    Write-Host "SUCCESS: rs.exe found:"
    Write-Host $rs.FullName
}

Write-Host "RUNNER CHECK COMPLETED"
