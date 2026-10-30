# Lab 2 — A Windows guest, and a network between them

Pair:   Driver first half: Alimkhan
Machine: ASUS Vivobook S 16 M3607HA, Windows 11, 16 GB RAM, AMD Ryzen 7, guests Ubuntu Server + Windows 11 Enterprise eval
Date: 30.10.2026

## What I did
1. Downloaded Windows 11 Enterprise evaluation. Licence: https://www.microsoft.com/en-us/evalcenter/evaluate-windows-11-enterprise
2. Created lab02-windows: 2 vCPU, 6 GB, 64 GB thin, UEFI + Secure Boot, vTPM.
3. Network mode: NAT, both guests. Why: Both guests must see each other and the internet, and bridged mode is often blocked on campus Wi-Fi.
4. Ping Ubuntu → Windows timed out because Windows Defender Firewall blocks incoming ICMP echo requests by default. Fixed with: `New-NetFirewallRule -DisplayName "Allow ping in (ICMPv4)" -Protocol ICMPv4 -IcmpType 8 -Direction Inbound -Action Allow`
5. Overcommitment: set 8 GB + 8 GB on a 16 GB host.

## Network diagram
              Internet
                 |
      Host laptop (campus Wi-Fi)
                 |
     [VMware NAT · VMnet8]
          /                \
lab01-ubuntu           lab02-windows
192.168.165.129        192.168.165.130

## Result
| | Before | After |
|---|---|---|
| Host RAM in use | 6.8 GB | 14.7 GB |
| Available | 8.4 GB | 570 MB |
| Committed / Swap used | 10.7 GB | 23.6 GB |
| What I noticed | — | The mouse cursor stuttered and windows took several seconds to respond during the load. |

## What did not work the first time
I initially tried to allocate 10 GB to each VM (20 GB total) for the overcommitment test, but VMware failed to start the second VM with a "Could not create anonymous paging file / Failed to allocate main memory" error. I had to lower it to 8 GB per VM to allow the hypervisor to start both while still overcommitting the host's physical 16 GB RAM.

## Evidence
- [evidence/ipconfig-windows.txt](evidence/ipconfig-windows.txt) — Windows address
- [evidence/ip-addr-linux.txt](evidence/ip-addr-linux.txt) — Ubuntu address
- [evidence/ping-both-ways.txt](evidence/ping-both-ways.txt) — both directions and the internet
- [evidence/host-memory-before.png](evidence/host-memory-before.png) — host memory, guests off
- [evidence/host-memory-after.png](evidence/host-memory-after.png) — host memory, both guests overcommitted
