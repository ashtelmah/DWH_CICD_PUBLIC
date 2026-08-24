# DWH CI/CD

A practical CI/CD framework for Microsoft SQL Server data-platform projects using GitHub Actions and self-hosted Windows runners.

## Purpose

This repository demonstrates an approach to managing and deploying SQL Server data-platform components through Git-based source control and automated CI/CD pipelines.

The main goal is to make deployments:

* repeatable;
* traceable;
* automated;
* environment-aware;
* independent of manual deployment steps.

The repository is structured so that deployment logic, validation scripts, project configuration, and documentation are separated from the actual project packages.

## Main Approach

The solution uses GitHub as the source-control and CI/CD platform and a self-hosted Windows runner for deployment to the target SQL Server environment.

The general deployment flow is:

```text
Developer
    │
    ▼
Git repository
    │
    ▼
GitHub Release
    │
    ▼
GitHub Actions
    │
    ▼
Self-hosted Windows Runner
    │
    ├── Build
    │
    └── Deploy
    │
    ▼
SQL Server / SSIS Catalog
```

A release tag identifies which project should be deployed.

For example:

```text
NBU-V1.0.0
twhDb01-V1.0.3
```

The project name is extracted from the tag by taking everything before the version suffix:

```text
NBU-V1.0.0
└── NBU

twhDb01-V1.0.3
└── twhDb01
```

This allows one workflow to support multiple SSIS projects without changing the workflow for every release.

## Repository Structure

```text
.
├── .github/
│   └── workflows/
│       └── SSIS release workflows
│
├── docs/
│   ├── Instruction_SSIS.md
│   ├── architecture/
│   ├── pipelines/
│   └── standards/
│
├── scripts/
│   ├── ps/
│   │   ├── Runner_Check.ps1
│   │   └── Test-SSIS.ps1
│   │
│   └── sql/
│       └── Check-SSISDB.sql
│
├── ssis/
│   ├── project definitions
│   ├── project parameters
│   └── project configuration
│
├── ssas/
├── ssrs/
└── tests/
```

## CI/CD Components

### GitHub Actions

GitHub Actions is responsible for executing the deployment workflow.

The workflow:

1. Detects the release tag.
2. Determines the SSIS project.
3. Checks out the repository.
4. Builds the project using Visual Studio.
5. Creates the ISPAC package.
6. Deploys the project using `ISDeploymentWizard.exe`.
7. Uses the configured GitHub Environment for deployment settings.

### Self-hosted Runner

The deployment runs on a Windows self-hosted runner.

The runner provides the required environment for SQL Server data-platform deployment, including:

* Visual Studio / SSIS build tools;
* SSIS Deployment Wizard;
* SQL Server connectivity;
* network access to GitHub;
* Windows authentication to the target SQL Server.

Runner validation scripts are stored in:

```text
scripts/ps/
```

### Environment Configuration

Deployment-specific values are separated from the workflow logic.

The GitHub Environment contains environment-level configuration such as:

```text
SSIS_SERVER
```

Project-specific deployment information is defined in the workflow configuration rather than requiring a separate workflow for every project.

## Validation

Before using the runner for CI/CD, the environment can be checked with the PowerShell validation script.

The validation covers the basic requirements for:

* SQL Server connectivity;
* GitHub connectivity;
* Visual Studio;
* SSIS Deployment Wizard;
* SSRS tooling.

The same deployment script can also be executed locally for testing before creating a GitHub Release.

See:

```text
scripts/ps/
```

for the PowerShell scripts and their documentation.

## Deployment Model

The repository separates three areas:

```text
Source Code
    │
    ├── project definitions
    ├── parameters
    └── configuration

Automation
    │
    ├── GitHub Actions
    └── PowerShell

Validation
    │
    ├── SQL checks
    └── Runner checks
```

This separation makes it possible to change deployment infrastructure without changing the SSIS projects themselves.

## Documentation

Detailed documentation is maintained separately from the main README.

* `docs/` — architecture, deployment process, and project documentation.
* `scripts/` — PowerShell and SQL scripts with usage and parameter descriptions.
* `.github/workflows/` — GitHub Actions workflow definitions.

The main README provides the overall architecture and approach; detailed operational instructions belong in the corresponding directories.

