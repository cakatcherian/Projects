Write-Output "n=== Firewall Status =="
Get-NetFirewallProfile | Select-Object Name, Enabled

# Current CPU/RAM/Disk Usage
Write-Output "n=== Current CPU/RAM/Disk Usage ==="
Write-Output "CPU Usage:"
Get-Counter '\Processor(Total)% Processor Time' | Select-Object -ExpandProperty CounterSamples |
Select-Object InstanceName, CookedValue

Write-Output "RAM Usage:"
Get-CimInstance Win32_OperatingSystem | ForEach-Object {
    "Total: $($.TotalVisibleMemorySize / 1MB) GB"
    "Free: $($.FreePhysicalMemory / 1MB) GB"
}

Write-Output "Disk Usage:"
Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{Name="UsedGB";Expression={[math]::Round($.Used/1GB,2)}}, @{Name="FreeGB";Expression={[math]::Round($.Free/1GB,2)}}, @{Name="TotalGB";Expression={[math]::Round($.Used/1GB+$.Free/1GB,2)}}

Last 20 Event Log Errors
Write-Output "n=== Last 20 Event Log Errors ==="
Get-EventLog -LogName System -EntryType Error -Newest 20 | Select-Object TimeGenerated, Source, EventID, Message

# Users and Groups
Write-Output "n=== Users and Groups ==="
Get-LocalUser | Select-Object Name, Enabled
Get-LocalGroup | ForEach-Object {
    Write-Output "`nGroup: $($.Name)"
    Get-LocalGroupMember -Group $_.Name | Select-Object Name, ObjectClass
}

Shares
Write-Output "n=== Shares ==="
Get-SmbShare | Select-Object Name, Path, Description

# Printers
Write-Output "n=== Printers ==="
Get-Printer | Select-Object Name, DriverName, PortName

Network Information
Write-Output "`n=== Network Information ==="
Get-NetIPAddress | Select-Object InterfaceAlias, IPAddress, PrefixLength, AddressFamily
Get-NetAdapter | Select-Object Name, Status, MacAddress, LinkSpeed
