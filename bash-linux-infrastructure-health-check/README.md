# Bash Linux Infrastructure Health Check

A practical Bash automation project for performing a basic health assessment of a Linux server and generating a text report with operational warnings.

## What it checks

The script collects and evaluates:

- Hostname
- Linux distribution
- Uptime
- CPU load average
- Memory usage
- Filesystem usage
- IPv4 configuration
- Status of selected services
- Basic network connectivity

## Health logic

The script adds simple operational status checks:

- Filesystem usage at or above 90% -> `WARNING`
- Selected service not running -> `WARNING`
- Connectivity test failure -> `CRITICAL`

## Run the script

Make it executable:

```bash
chmod +x health-check.sh
```

Then run:

```bash
./health-check.sh
```

The script creates:

```text
health-report.txt
```

View the report with:

```bash
cat health-report.txt
```

## Bash concepts demonstrated

- Variables
- Command substitution with `$(...)`
- Output redirection with `>` and `>>`
- `if` / `else` conditional logic
- Arrays
- `for` loops
- `while read` loops
- String manipulation
- Exit-status based command testing
- Output suppression with `/dev/null`
- Linux service checks with `systemctl`
- Network testing with `ping`
- Filesystem monitoring with `df`
- Memory inspection with `free`
- IPv4 inspection with `ip`

## Example workflow

```text
Linux Host
    |
    v
Bash health-check.sh
    |
    +-- OS / uptime
    +-- CPU load
    +-- Memory
    +-- Filesystem threshold
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

This project is designed as an infrastructure/DevOps learning lab. Service names and thresholds should be adapted to the role of the target host in a production environment.
