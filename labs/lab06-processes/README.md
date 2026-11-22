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

## Part 2 — Memory pressure
Guest RAM: 1.6 GiB usable (VM settings reduced to 2 GB) · swap: 2.0 GiB

Steps:
```bash
stress-ng --vm 2 --vm-bytes 70% --timeout 60s
stress-ng --vm 2 --vm-bytes 90% --timeout 60s
stress-ng --vm 2 --vm-bytes 120% --timeout 90s
stress-ng --vm 2 --vm-bytes 150% --timeout 90s
stress-ng --vm 2 --vm-bytes 200% --timeout 90s
stress-ng --vm 2 --vm-bytes 400% --timeout 90s
# Triggered immediate OOM without swap buffer:
sudo swapoff -a
stress-ng --vm 2 --vm-bytes 90% --timeout 60s
sudo swapon -a
```

| | Before | During (worst) | After |
|---|---|---|---|
| Available |1.1Gi |4.0Mi |1.1Gi |
| Swap used |0B |2.0Gi |0B|

What happened:

12:59:52: First notable swap activity (219Mi used) during the initial stress runs, while available stayed above 570Mi.

13:05:06 - 13:09:02: Under heavier pressure (150%-200%), available dropped close to zero (7.6Mi at 13:05:53 and an overall low of 4.0Mi at 13:08:53), while swap grew steadily to 1.4Gi. Terminal responsiveness degraded severely (heavy input lag and freezing), and stress-ng reported metrics-check: all bogo-op counters are zero, indicating severe thrashing.

13:11:22 - 13:12:34: At 400%, swap reached 2.0Gi (only 3.4Mi free at 13:11:22). With both RAM and swap exhausted, the kernel invoked the OOM killer five times (13:11:23 to 13:12:34), terminating stress-ng-vm workers while the parent stress-ng process kept respawning them until the timeout expired.

13:15:49 & 13:22:10 - 13:23:10: After disabling swap (sudo swapoff -a completed by 13:15:49), running stress-ng --vm 2 --vm-bytes 90% caused available to plunge to 24Mi at 13:22:10. Without swap to absorb pages, the kernel began killing stress-ng-vm workers almost every second until the run ended. After sudo swapon -a (13:32:44), memory returned to baseline (1.1Gi available, 0B swap used).

### What the kernel did
First OOM kill (when 2.0 GiB swap hit 100% at 13:11:22):
Nov 18 13:11:23 localhost kernel: Out of memory: Killed process 3115 (stress-ng-vm) total-vm:2508900kB, anon-rss:720008kB, file-rss:520kB, shmem-rss:0kB, UID:1000 pgtables:3348kB oom_score_adj:1000

First OOM kill after disabling swap (matching the 24Mi available drop at 13:22:10):
Nov 18 13:22:10 localhost kernel: Out of memory: Killed process 3902 (stress-ng-vm) total-vm:921512kB, anon-rss:862448kB, file-rss:520kB, shmem-rss:72kB, UID:1000 pgtables:1780kB oom_score_adj:1000

At 13:11:23 (immediately after memory-pressure.txt recorded 2.0Gi swap used and 22Mi available at 13:11:22), the kernel exhausted both physical RAM and swap and killed stress-ng-vm (PID 3115, anon-rss: 720008kB). Later, with swap disabled, the same happened immediately at 13:22:10 (matching the 24Mi available drop in memory-pressure.txt), killing PID 3902 (anon-rss: 862448kB). In every case, the kernel chose stress-ng-vm workers because they held the largest share of anonymous physical memory and carried oom_score_adj: 1000 (maximum OOM priority), sparing system daemons like vmtoolsd (oom_score_adj: 0) and systemd-journal (oom_score_adj: -250).

### Windows
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Microsoft-Windows-Resource-Exhaustion-Detector'} -MaxEvents 5 | Format-List TimeCreated, Id, Message

Get-WinEvent : No events were found that match the specified selection criteria.
At line:1 char:1
+ Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Micro ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (:) [Get-WinEvent], Exception
    + FullyQualifiedErrorId : NoMatchingEventsFound,Microsoft.PowerShell.Commands.GetWinEventCommand

Explanation: The query returned no events because the Windows VM has not experienced critical memory exhaustion. Unlike Linux, which uses the OOM killer to terminate high-scoring processes when memory runs out, Windows uses the Resource-Exhaustion-Detector to write Event ID 2004 to the System log - naming the top memory-consuming processes - and then denies new memory allocations rather than automatically killing running applications.

## What did not work the first time
At lower stress levels (70% through 200%), the experiment did not trigger the OOM killer at all: the host's fast NVMe SSD allowed the 2.0 GiB swap file to absorb the pressure, causing severe thrashing without killing the workload. Even at 400%, because the parent stress-ng process automatically respawns killed workers, it initially looked as if the process survived until checking journalctl -k revealed five OOM kills once swap reached 2.0Gi. To observe immediate, unambiguous OOM-killer behavior without swap buffering, I temporarily disabled swap with sudo swapoff -a and re-ran the 90% load, then re-enabled swap with sudo swapon -a.

## Evidence
[evidence/task-manager.png](evidence/task-manager.png) - Task Manager details for vmtoolsd.exe

[evidence/process-explorer.png](evidence/process-explorer.png) - Process Explorer showing parent process, handles, and memory columns

[evidence/htop.png](evidence/htop.png) - htop showing PID, PPID, and RES/VIRT for vmtoolsd

[evidence/memory-pressure.txt](evidence/memory-pressure.txt) - Record of free -h before, during, and after memory pressure

[evidence/kernel-log-extract.txt](evidence/kernel-log-extract.txt) - Log extract showing the kernel invoking the OOM killer
