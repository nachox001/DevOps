# Python Infrastructure Health Check

A practical Python infrastructure automation project that performs health checks on a Linux host and writes the results as structured JSON.

## What it checks

- Hostname and operating system
- Root filesystem capacity and free-space percentage
- Total and available memory
- Nginx and SSH service status
- TCP connectivity to an external target

## Health logic

- Disk free space below 10% -> `WARNING`
- Available memory below 0.5 GB -> `WARNING`
- Selected service not active -> `WARNING`
- Connectivity failure -> `CRITICAL`

## Run the script

```bash
python3 health_check.py
```

The script generates:

```text
health-report.json
```

View the report with:

```bash
cat health-report.json
```

## Example report structure

```json
{
    "hostname": "linux-host",
    "checks": {
        "disk": {
            "status": "OK"
        },
        "memory": {
            "status": "OK"
        },
        "services": {
            "nginx": "OK",
            "ssh": "OK"
        },
        "connectivity": {
            "status": "OK"
        }
    }
}
```

## Python concepts demonstrated

- Standard-library modules and imports
- Variables and dictionaries
- Lists and `for` loops
- Conditional expressions and `if` / `else`
- Reading and parsing Linux `/proc` data
- Running operating-system commands with `subprocess`
- Exception handling with `try` / `except`
- TCP connectivity testing with sockets
- File handling with `with open(...)`
- JSON serialization

## Why JSON?

Unlike a purely human-readable text report, JSON provides structured output that can be consumed by other automation, monitoring systems, APIs, CI/CD pipelines, or log-processing tools.

## Notes

This is an infrastructure/DevOps learning lab rather than a production monitoring agent. Thresholds and monitored services should be adapted to the requirements of the target environment.
