# Lab 1 — Your first virtual machine

Pair:                     Driver first half:
Machine: ASUS Vivobook S 16 M3607HA | Guest: Ubuntu Server 24.04.1 LTS
Date: 20.10.2026

Hypervisor: VMware Workstation Pro (Free Personal Use) - https://support.broadcom.com/web/ecx/home 

## What I did
1. Installed VMware Workstation Pro. Licence: [https://knowledge.broadcom.com/external/article/368667/download-and-license-vmware-desktop-hype.html](https://support.broadcom.com/web/ecx/home) 
2. Created VM lab01-ubuntu: 2 vCPU, 4 GB RAM, 25 GB dynamic disk, NAT.
3. Installed Ubuntu Server, took snapshot clean-install.
4. Broke it: 
cat /etc/hostname
sudo rm /etc/hostname
sudo reboot
5. Rolled back to clean-install: 
cat /etc/hostname


```
cat /etc/hostname     
sudo rm /etc/hostname
cat /etc/hostname          
sudo reboot
```

## Result
vCPU : 2. Justification : My AMD Ryzen 7 processor has 8 physical cores. Giving 2 vCPUs to the VM gives Ubuntu Server enough speed for smooth terminal commands without slowing down your host Windows system.

Memory : 4GB. Justification : I allocated 4 GB of my 16 GB because Windows already leverages about 6 GB when idle, and I need room for a Windows guest in Lab 2.

Disk : 25GB. Justification : Allocating a 25 GB dynamic virtual disk uses only 3-4 GB today and making it completely safe for the host OS.

Network : NAT. Justification : NAT acts as a virtual firewall, hiding your virtual machine from other devices on the local classroom Wi-Fi network while still giving it full outbound internet access.

The VM boots; the break-and-rollback cycle is shown in the evidence below.

## What did not work the first time
1. 
What I saw : In the step 9 I chose option A to break my VM. I run all the commands but forgot to take a screenshot before and after the commands.
What it turned out to be : When I realized that I needed to take screenshots I was really confused when exactly to take the since after the last command everything was rebooting. In fact, I needed to take the first screenshot before the last command to show my server name and to demonstrate that there was no such a file or directory after the third screenshot. The second screenshot was required to be taken after running 'sudo reboot' and 'hostname'
What I did : So, when I understood my mistake, I took the following screenshots the right way. 


## Evidence

- [evidence/vm-settings.png](evidence/vm-settings.png) — CPU, memory and disk as configured
- [evidence/guest-release.txt](evidence/guest-release.txt) — Ubuntu Server is running in the guest
- [evidence/broken.png](evidence/broken.png) — the guest in its broken state
- [evidence/snapshot-list.png](evidence/snapshot-list.png) — the snapshot, after the rollback
