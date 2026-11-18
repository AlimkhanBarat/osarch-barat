# Lab 6 — Live processes and memory pressure

Pair: <name> + <name> · Date: <date> · Guests: <Ubuntu version / Windows edition, RAM of each>

## Part 1 — One process, three tools
Process chosen: vmtoolsd.exe / vmtoolsd (VMware Tools) — why: Since I am using VMware Workstation Pro, vmtoolsd is the direct equivalent of the VBoxService. It runs in the background on both the Windows and Ubuntu guests.

| | Task Manager | Process Explorer | htop / ps |
|---|---|---|---|
| **PID** | 3508 | 3508 | 15494 |
| **Parent (name and PID)** | — (not shown) | services.exe | systemd (1) |
| **"Memory" as shown by default** | 3,004 K | 23,900 K | 11380 (RES) |
| **Private memory** | 3,004 K | 10,412 K | — (htop doesn't isolate private memory directly) |
| **Working set / RES** | 23,800 K | 23,900 K | 11380 K |
| **Virtual size** | 10,408 K | 2,151,818,312 K | 111 M (114040 K) |
| **Handles / file descriptors** | 399 | 399 | 9 |
| **Threads** | 14 | 14 | 4 |

### Where the tools disagree
1. **Parent Process Visibility:** Task Manager does not show the parent process (PPID) by default, grouping processes by application instead. Process Explorer and `htop` display the process tree, clearly showing the parent.
2. **Memory Terminology and Measurement:** Task Manager's default "Memory" column actually shows the "Private working set" (memory that cannot be shared with other processes, here 3,004 K). Process Explorer's default "Working Set" shows total physical memory mapped (23,900 K). `htop` shows "RES" (Resident Set Size, 11380 K), which includes shared libraries. They display different numbers because they measure fundamentally different concepts of memory usage.
3. **Virtual Size Discrepancy:** In Windows, Task Manager's "Commit size" (10,408 K) roughly corresponds to Process Explorer's "Private Bytes" (10,412 K). However, Process Explorer's "Virtual Size" shows a massive 2+ TB (2,151,818,312 K) because it maps the entire 64-bit theoretical address space, whereas `htop` displays "VIRT" (111 M), which maps the allocated address space including shared libraries.

## Part 2 — Memory pressure
Guest RAM: <…> · swap: <…>
Steps: <the commands, in order>
| | Before | During (worst) | After |
| Available | | | |
| Swap used | | | |
What happened: <responsiveness, what happened to the process, with times>

### What the kernel did
<the OOM line(s), quoted, and your explanation: which process, why, when>

### Windows
<the Get-WinEvent command and its result, and your explanation>

## What did not work the first time
<at least one real thing>
