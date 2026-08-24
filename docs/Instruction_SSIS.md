# SSIS CI/CD Instruction

## 1. Repository Structure

```text
DWH_CICD/
├── .github/
│   ├── workflows/
│   │   └── ssis-release-deploy.yml
│   └── ssis-params.yml
├── scripts/
│   ├── ps/
│   │   ├── Runner_Check.ps1
│   │   └── Test-SSIS.ps1
│   └── sql/
│       └── Check-SSISDB.sql
└── ssis/
    ├── NBU/
    └── twhDb01/
```

## 2. Runner Requirements

The self-hosted Windows Runner requires:

* GitHub API access: `api.github.com:443`
* SQL Server access: `HQ01DB02:1433`
* Domain Windows account with permissions to deploy to SSISDB
* Visual Studio 2019 with SSIS tools
* `devenv.exe`
* `ISDeploymentWizard.exe`
* SSRS tools if required

Check the Runner:

```powershell
.\scripts\ps\Runner_Check.ps1
```

## 3. SQL Server Check

Run:

```text
scripts/sql/Check-SSISDB.sql
```

The script checks:

* SQL Server
* SSISDB folders
* Projects
* Packages

## 4. SSIS Project Parameters

All SSIS project parameters are stored in:

```text
.github/ssis-params.yml
```

Example:

```yaml
NBU:
  solution: ".\ssis\NBU\NBU.sln"
  ispac: ".\ssis\NBU\bin\Development\NBU.ispac"
  destination: "/SSISDB/NBU_ETL/NBU"

twhDb01:
  solution: ".\ssis\twhDb01\twhDb01.sln"
  ispac: ".\ssis\twhDb01\bin\Development\twhDb01.ispac"
  destination: "/SSISDB/Accounts/Accounts"
```

When adding a new SSIS project, add its `solution`, `ispac` and `destination` to this file.

## 5. GitHub Environment

Path:

```text
Repository
→ Settings
→ Environments
→ SSIS_SERVER
```

Environment Variable:

```text
SSIS_SERVER = HQ01DB02
```

The server is common for all SSIS projects.

## 6. Release Tag

Release tags use the format:

```text
PROJECT-VERSION
```

Examples:

```text
NBU-V1.0.0
twhDb01-V1.0.3
```

The project name is taken from everything before `-V`.

Example:

```text
twhDb01-V1.0.3
       ↓
SSIS_PROJECT = twhDb01
```

The workflow then finds `twhDb01` in:

```text
.github/ssis-params.yml
```

and uses its parameters.

## 7. Test-SSIS.ps1

Script:

```text
scripts/ps/Test-SSIS.ps1
```

The same script is used both for **local testing** and by **GitHub Actions** for deployment.

Local test:

```powershell
.\scripts\ps\Test-SSIS.ps1 -Project twhDb01 -Server HQ01DB02
```

The script:

1. Builds the SSIS solution.
2. Creates the ISPAC.
3. Deploys the ISPAC to SSISDB.

## 8. GitHub Actions

Workflow:

```text
.github/workflows/ssis-release-deploy.yml
```

When a Release is published, GitHub Actions:

1. Gets the project name from the Release tag.
2. Gets project parameters from `.github/ssis-params.yml`.
3. Gets the SQL Server from the `SSIS_SERVER` Environment.
4. Runs `Test-SSIS.ps1`.
5. Builds the SSIS project.
6. Deploys the ISPAC to SSISDB.

## 9. Developer Workflow

Developer:

```text
Create branch
    ↓
Modify SSIS project
    ↓
Commit
    ↓
Push branch
    ↓
Pull Request
```

Senior reviews and merges the Pull Request into `main`.

When the change is ready for deployment:

```text
Create Release
    ↓
Create tag PROJECT-VERSION
    ↓
Publish Release
    ↓
GitHub Actions
    ↓
Build + Deploy
```

Example:

```text
twhDb01-V1.0.3
```

No manual deployment to SSISDB is required after the Release is published.
