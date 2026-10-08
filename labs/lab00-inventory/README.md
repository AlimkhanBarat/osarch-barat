# Lab 0 — Inventory your own machine

Pair:                     Driver first half:
Machine: ASUS Vivobook S 16 M3607HA
Date:08.10.2026

## What I did

Steps, with commands in code blocks. Not prose about the steps.

```
systeminfo
wmic cpu get Name, NumberOfCores, NumberOfLogicalProcessors
wmic memorychip get DeviceLocator, Capacity, Speed
powershell -Command "Get-PhysicalDisk | Select-Object FriendlyName, MediaType, BusType; Get-Volume C | Select-Object DriveLetter, @{Name='Free_GB';Expression={[math]::round($_.SizeRemaining/1GB,1)}}, @{Name='Total_GB';Expression={[math]::round($_.Size/1GB,1)}}"
bcdedit | findstr /i "path"
wmic cpu get VirtualizationFirmwareEnabled
wmic logicaldisk where "DeviceID='C:'" get FreeSpace, Size
wmic bios get SMBIOSBIOSVersion, ReleaseDate

```

## Result

## What did not work the first time

At least one thing. What I saw, what it turned out to be, what I did about it.
1) Confusion of github interface and organizing github repository
    - What I saw : When I looked at beginning page of my repository, I did not know how to upload my screenshots(lab 0) on my github correctly
    - What it turned out to be : Turned out that I needed to download "repo_starter.zip" from canvas and simply upload it into my repository. Then, I needed to open my repository by clicking on it and start working there. 
    - What I did about it : It allowed me to correctly organize my works, upload my lab 0 and write description for lab 0.

## Evidence

- [evidence/systeminfo.png](evidence/systeminfo.png) — proves general information regarding system 
- [evidence/hardware_commands.png](evidence/hardware_commands.png) — proves hardware characteristics of the laptop