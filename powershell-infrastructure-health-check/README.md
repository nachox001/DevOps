# PowerShell Infrastructure Health Check

A practical PowerShell automation project for performing a basic health assessment of a Windows workstation or server and generating a text report with health warnings.

## What it checks

The script collects and evaluates:

- Computer name
- Windows version and last boot time
- CPU model and current load
- Total and free physical memory
- Local fixed-disk capacity and free-space percentage
- IPv4 interface configuration
- Status of selected Windows services
- Basic network connectivity

## Health logic

The script adds simple operational status checks:

- Free memory below 2 GB -> `WARNING`
- Disk free space below 10% -> `WARNING`
- Selected service not running -> `WARNING`
- Connectivity test failure -> `CRITICAL`

These thresholds are intentionally simple for a hands-on infrastructure automation lab and can be adjusted for a production environment.

## Run the script

Open PowerShell in the project directory and run:

```powershell
.\health-check.ps1
```

If local execution policy prevents the lab script from running, a process-scoped policy can be used for the current PowerShell session:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\health-check.ps1
```

The script creates:

```text
health-report.txt
```

View the report with:

```powershell
Get-Content .\health-report.txt
```

## PowerShell concepts demonstrated

- Variables and environment variables
- PowerShell object pipeline
- `Get-CimInstance`
- `Get-Service`
- `Get-NetIPAddress`
- `Test-NetConnection`
- `Select-Object` and `Where-Object`
- Arrays and `foreach` loops
- `if` / `else` conditional logic
- Comparison operators such as `-lt` and `-eq`
- Calculated disk and memory values
- File output with `Out-File`
- Basic infrastructure monitoring logic

## Example workflow

```text
Windows Host
    |
    v
PowerShell health-check.ps1
    |
    +-- OS / uptime
    +-- CPU
    +-- Memory + threshold
    +-- Disk + threshold
    +-- IPv4 configuration
    +-- Important services
    +-- Connectivity
    |
    v
health-report.txt
    |
    +-- OK
    +-- WARNING
    +-- CRITICAL
```

## Notes

This project is designed as an infrastructure/DevOps learning lab. Whether a stopped Windows service is actually unhealthy depends on the intended role and configuration of the target machine. For example, WinRM being stopped is only a concern where PowerShell remoting or another WinRM-dependent management workflow is expected.
