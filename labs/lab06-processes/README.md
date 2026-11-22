# Lab 6 - Live processes and memory pressure

Pair: Barat Alimkhan / Solo · Date: 18.11.2026 · Guests: Ubuntu Server 26.04.1 (2 GB RAM) / Windows 11 Enterprise (4 GB RAM)

## Part 1 — One process, three tools
Process chosen: `vmtoolsd.exe` (user-session instance, PID 4336 on Windows) / `vmtoolsd` (PID 15494 on Ubuntu) - why: Since I am using VMware Workstation Pro, `vmtoolsd` is the direct equivalent of `VBoxService` and runs in the background on both guests. (Note: Windows runs two `vmtoolsd.exe` instances; the table below compares the user-session instance PID `4336`, visible directly below PID `3508` in `task-manager.png` and selected with its handles pane open in `process-explorer.png`.)

| | Task Manager | Process Explorer | htop / ps |
|---|---|---|---|
| **PID** | 4336 | 4336 | 15494 |
| **Parent (name and PID)** | - (not shown) | explorer.exe (5840) | systemd (1) |
| **"Memory" as shown by default** | 1,492 K (Private WS) | 28,188 K (Working Set) | 11,380 K (RES) |
| **Private memory** | 1,492 K (Private WS) / 5,520 K (Commit size) | 1,984 K (WS Private) / 6,352 K (Private Bytes) | - (htop does not isolate private memory directly) |
| **Working set / RES** | 22,712 K | 28,188 K | 11,380 K |
| **Virtual size** | - (not shown in Task Manager) | - (column not enabled) | 111 M |
| **Handles / file descriptors** | 280 | 288 | 9 |
| **Threads** | 4 | 4 | 4 |

### Where the tools disagree
1. **Parent Process Visibility:** Task Manager does not display the parent process (PPID) on the Details tab, whereas Process Explorer shows the full process tree (`explorer.exe`, PID `5840`) and `htop` exposes the `PPID` column (`1`, `systemd`).
2. **Default "Memory" Column Definition:** Task Manager's default `Memory (private working set)` column reports only physical RAM private to the process (`1,492 K`), excluding shared DLLs. Process Explorer's `Working Set` (`28,188 K`) and `htop`'s `RES` (`11,380 K`) include shared libraries mapped into physical RAM, so the figures measure different things even for the same process.
3. **Committed Memory vs. Virtual Address Space:** Task Manager's `Commit size` (`5,520 K`) corresponds to Process Explorer's `Private Bytes` (`6,352 K`) - the private virtual memory backed by RAM or the page file. `htop` has no direct equivalent column; instead it reports `VIRT` (`111 M`), which represents the entire mapped virtual address space (including shared libraries and reserved regions) and is much larger than actual physical RAM usage (`RES: 11,380 K`).

## Part 2 - Memory pressure
Guest RAM: 1.6 GiB (VM settings reduced to 2 GB) · swap: 2.0 GiB
Steps: 
```bash
stress-ng --vm 2 --vm-bytes 70% --timeout 60s
stress-ng --vm 2 --vm-bytes 90% --timeout 60s
stress-ng --vm 2 --vm-bytes 120% --timeout 90s
stress-ng --vm 2 --vm-bytes 150% --timeout 90s
stress-ng --vm 2 --vm-bytes 200% --timeout 90s
stress-ng --vm 2 --vm-bytes 400% --timeout 90s
# System survived due to fast NVMe swap. Forced OOM by disabling swap:
sudo swapoff -a
stress-ng --vm 2 --vm-bytes 90% --timeout 60s
sudo swapon -a
```

| | Before | During (worst) | After |
|---|---|---|---|
| Available |1.1Gi |24Mi |1.1Gi |
| Swap used |0B |1.4Gi (peak) / 0B (when forced) |0B|

What happened: As the load increased, the system started relying heavily on Swap (reaching over 1.4Gi). Terminal responsiveness degraded severely (heavy input lag and freezing), and stress-ng even reported metrics-check: all bogo-op counters are zero, indicating severe thrashing. However, because the host SSD (NVMe) was extremely fast, the swap absorbed the pressure even at 400% allocation. To demonstrate the OOM killer, we temporarily disabled the swap (sudo swapoff -a). Available memory instantly plummeted to 24Mi at 13:22:10, and the kernel forcibly killed the process.

### What the kernel did
Nov 18 13:22:10 localhost kernel: Out of memory: Killed process 3902 (stress-ng-vm) total-vm:921512kB, anon-rss:862448kB, file-rss:520kB, shmem-rss:72kB, UID:1000 pgtables:1780kB oom_score_adj:1000

At exactly 13:22:10 (which perfectly matches the 24Mi available memory drop in our monitoring log), the kernel ran completely out of memory and invoked the OOM-killer. It targeted and killed the stress-ng-vm child process (PID 3902) because it was the most memory-hungry task (consuming ~862MB of anonymous memory, anon-rss:862448kB). The kernel sacrificed this process to free up pages and prevent a complete system crash.

### Windows
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 | Format-List TimeCreated, Id, Message

Get-WinEvent : No events were found that match the specified selection criteria.
At line:1 char:1
+ Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Micro ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (:) [Get-WinEvent], Exception
    + FullyQualifiedErrorId : NoMatchingEventsFound,Microsoft.PowerShell.Commands.GetWinEventCommand

Explanation: The query returned no events because the Windows VM has not experienced critical memory pressure yet. Unlike Linux, which uses the OOM Killer to aggressively terminate processes when memory runs out, Windows uses the Resource-Exhaustion-Detector (Event ID 2004) to log a warning containing the names of the top memory-consuming processes. It then starts denying new memory allocations (allocations fail) rather than arbitrarily killing running apps.

## What did not work the first time
The memory pressure experiment in Ubuntu did not trigger the OOM killer at first, even when allocating 400% of memory. I saw all bogo-op counters are zero which meant the system was thrashing, but it survived because the host's fast NVMe SSD allowed the 2GB Swap to absorb the load. To fix this and force the kernel to react, I temporarily disabled the swap using sudo swapoff -a, which immediately triggered the OOM killer as expected.

## Evidence
[evidence/task-manager.png](evidence/task-manager.png) - Task Manager details for vmtoolsd.exe

[evidence/process-explorer.png](evidence/process-explorer.png) - Process Explorer showing parent process, handles, and memory columns

[evidence/htop.png](evidence/htop.png) - htop showing tree view, PPID, and RES/VIRT for vmtoolsd

[evidence/memory-pressure.txt](evidence/memory-pressure.txt) - Record of free -h before, during, and after memory pressure

[evidence/kernel-log-extract.txt](evidence/kernel-log-extract.txt) - Log extract showing the kernel invoking the OOM killer
