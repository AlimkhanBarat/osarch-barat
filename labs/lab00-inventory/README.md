# Lab 0 — Inventory your own machine

Pair:                     Driver first half:
Machine: ASUS Vivobook S 16 M3607HA
Date:08.10.2026

## What I did

```cmd 
wmic cpu get Name, NumberOfCores, NumberOfLogicalProcessors, VirtualizationFirmwareEnabled
wmic memorychip get DeviceLocator, Capacity, Speed
powershell -Command "Get-PhysicalDisk | Select-Object FriendlyName, MediaType, BusType"
wmic logicaldisk where "DeviceID='C:'" get FreeSpace, Size
wmic bios get SMBIOSBIOSVersion, ReleaseDate
bcdedit | findstr /i "path" 

## Result

| What | Value | Where I got it |
| :--- | :--- | :--- |
| CPU Model | AMD Ryzen 7 260 w/ Radeon 780M Graphics | `wmic cpu get Name` |
| CPU Cores / Threads |8 Cores, 16 Logical Processors|`wmic cpu get NumberOfCores,NumberOfLogicalProcessors` |
| Total Memory & Modules |16 GB (1 module x 16 GB, DIMM 0)| `wmic memorychip get DeviceLocator, Capacity` |
| Memory Speed | 5600 MT/s | `wmic memorychip get Speed` |
| Disk Model & Type|Model : MTFDKBA512QGN-1BN1AABGA, Type : SSD, NVMe|`powershell -Command "Get-PhysicalDisk \|Select-Object FriendlyName, MediaType,BusType"` |
| Free Space on Volume C: |389.0 GB free of 476.0 GB (417713221632 bytes)| `wmic logicaldisk where "DeviceID='C:'" get FreeSpace, Size` |
| Firmware Type |UEFI (proven by \Windows\system32\winload.efi) | `bcdedit \| findstr /i "path"` |
| Firmware Version & Date|Date:27.03.2026,Version:M3607HA.317|`wmic bios get SMBIOSBIOSVersion, ReleaseDate` |
| Hardware Virtualization |Enabled (`TRUE`)| `wmic cpu get VirtualizationFirmwareEnabled` |

## What did not work the first 

1. Confusion of github interface and organizing github repository
    - What I saw : When I looked at beginning page of my repository, I did not know how to upload my screenshots(lab 0) on my github correctly
    - What it turned out to be : Turned out that I needed to download "repo_starter.zip" from canvas and simply upload it into my repository. Then, I needed to open my repository by clicking on it and start working there. 
    - What I did about it : It allowed me to correctly organize my works, upload my lab 0 and write description for lab 0.

## Evidence

- [evidence/cpu.txt](evidence/cpu.txt) - proves CPU model, core/thread count, virtualization status, and UEFI/BIOS firmware details
- [evidence/memory.txt](evidence/memory.txt) - proves installed RAM modules, capacity, and speed
- [evidence/disk.txt](evidence/disk.txt) - proves physical disk model, bus type (NVMe), and free space on volume C