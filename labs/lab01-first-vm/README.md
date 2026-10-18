# Lab 1 — Your first virtual machine

Pair:                     Driver first half:
Machine: ASUS Vivobook S 16 M3607HA | Guest: Ubuntu Server 24.04.1 LTS
Date: 

Hypervisor: VMware Workstation Pro (Free Personal Use) - https://support.broadcom.com/web/ecx/home 

## What I did

```
<command>
<output, trimmed>
```

## Result
vCPU : 2. Justification : My AMD Ryzen 7 processor has 8 physical cores. Giving 2 vCPUs to the VM gives Ubuntu Server enough speed for smooth terminal commands without slowing down your host Windows system.

Memory : 4GB. Justification : I allocated 4 GB of my 16 GB because Windows already leverages about 6 GB when idle, and I need room for a Windows guest in Lab 2.

Disk : 25GB. Justification : Allocating a 25 GB dynamic virtual disk uses only 3-4 GB today and will never exceed 6% of my available host drive space, making it completely safe for the host OS.

Network : NAT. Justification : NAT acts as a virtual firewall, hiding your virtual machine from other devices on the local classroom Wi-Fi network while still giving it full outbound internet access.

## What did not work the first time

At least one thing. What I saw, what it turned out to be, what I did about it.

## Evidence

- [evidence/](evidence/) - one line per file on what it proves
