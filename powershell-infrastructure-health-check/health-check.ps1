$ReportPath = ".\health-report.txt"

"INFRASTRUCTURE HEALTH CHECK" | Out-File $ReportPath
"Generated: $(Get-Date)" | Out-File $ReportPath -Append
"====================================" | Out-File $ReportPath -Append

"`nCOMPUTER" | Out-File $ReportPath -Append
$env:COMPUTERNAME | Out-File $ReportPath -Append

"`nOPERATING SYSTEM" | Out-File $ReportPath -Append
Get-CimInstance Win32_OperatingSystem |
    Select-Object Caption, Version, LastBootUpTime |
    Format-List |
    Out-File $ReportPath -Append

"`nCPU" | Out-File $ReportPath -Append
Get-CimInstance Win32_Processor |
    Select-Object Name, LoadPercentage |
    Format-List |
    Out-File $ReportPath -Append

"`nMEMORY" | Out-File $ReportPath -Append
$OS = Get-CimInstance Win32_OperatingSystem
$TotalMemoryGB = [math]::Round($OS.TotalVisibleMemorySize / 1MB, 2)
$FreeMemoryGB = [math]::Round($OS.FreePhysicalMemory / 1MB, 2)

"Total Memory: $TotalMemoryGB GB" | Out-File $ReportPath -Append
"Free Memory:  $FreeMemoryGB GB" | Out-File $ReportPath -Append

if ($FreeMemoryGB -lt 2) {
    "WARNING: Free memory is below 2 GB" | Out-File $ReportPath -Append
}

"`nDISK" | Out-File $ReportPath -Append
$Disks = Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3"

foreach ($Disk in $Disks) {
    $SizeGB = [math]::Round($Disk.Size / 1GB, 2)
    $FreeGB = [math]::Round($Disk.FreeSpace / 1GB, 2)
    $FreePercent = [math]::Round(($Disk.FreeSpace / $Disk.Size) * 100, 2)

    "$($Disk.DeviceID) Size: $SizeGB GB | Free: $FreeGB GB | Free %: $FreePercent" |
        Out-File $ReportPath -Append

    if ($FreePercent -lt 10) {
        "WARNING: $($Disk.DeviceID) has less than 10% free space" |
            Out-File $ReportPath -Append
    }
}

"`nNETWORK" | Out-File $ReportPath -Append
Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object { $_.IPAddress -notlike "169.254*" } |
    Select-Object InterfaceAlias, IPAddress, PrefixLength |
    Format-Table -AutoSize |
    Out-File $ReportPath -Append

"`nIMPORTANT SERVICES" | Out-File $ReportPath -Append
$ImportantServices = @("WinRM", "wuauserv", "Dnscache")

foreach ($ServiceName in $ImportantServices) {
    $Service = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue

    if ($Service -and $Service.Status -eq "Running") {
        "$ServiceName : OK - Running" | Out-File $ReportPath -Append
    }
    else {
        "$ServiceName : WARNING - Not Running" | Out-File $ReportPath -Append
    }
}

"`nCONNECTIVITY TEST" | Out-File $ReportPath -Append
$Connection = Test-NetConnection 8.8.8.8

if ($Connection.PingSucceeded) {
    "Connectivity: OK" | Out-File $ReportPath -Append
}
else {
    "Connectivity: CRITICAL - Ping failed" | Out-File $ReportPath -Append
}

"`nHealth check completed." | Out-File $ReportPath -Append
Write-Host "Report generated at $ReportPath"
