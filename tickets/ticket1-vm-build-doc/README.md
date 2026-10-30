# Ticket 1 - New developer starts Monday, needs a test machine

## 1. What was asked
"Hi, we have someone starting on Monday and he needs a test computer set up. Nothing special, just so he can try things without breaking anything. Can you write down how to do it so I can do the next one myself? Thanks"

## 2. What was actually needed
**What the request left out:** The request did not specify which operating systems the developer requires, the hardware constraints of the host machine, or whether the VMs need internet access to pull dependencies. 
**Where the request is wrong:** The assumption that a developer needs "nothing special" is incorrect. Developers require specific environments and network access to function. Also, testing "without breaking anything" implies a need for a reliable rollback mechanism (snapshots), not just standard virtual machines.
**What I would ask:** I would ask Aigerim: What specific OS does the developer's tech stack require? Does the VM need to reach our internal campus network, or just the public internet? What are the exact RAM and disk specifications of the laptop hosting these VMs?
**What I assumed:** I assumed a standard web development stack requiring both a Windows 11 client and an Ubuntu Server. I assumed the host machine has at least 16 GB of RAM, and that the VMs need internet access but must bypass the university's strict MAC address filtering.

## 3. What I did
1. Installed VMware Workstation Pro.
2. Downloaded Ubuntu Server and Windows 11 Enterprise Evaluation ISOs.
3. Created VMs, adjusting resources to leave overhead for the host.
4. Installed the operating systems and configured NAT networking.
5. Configured Windows firewall rules to allow ICMP traffic.
6. Took clean snapshots of both machines for immediate rollback capabilities.

**Resource Calculation:**
My host machine (ASUS Vivobook) has 16 GB of RAM and a 512 GB SSD. 
- Windows 11 VM: Allocated 6 GB RAM (increased from the initial 4 GB because the evaluation OS was lagging and unresponsive during testing).
- Ubuntu Server VM: Allocated 2 GB RAM.
- Total VMs: 8 GB. The host Windows 11 OS uses about 6 GB at idle. This leaves roughly 2 GB of headroom, ensuring the host does not start swapping and crash under memory pressure.

**Non-default Settings:**
| Setting | Default | Mine | Why |
| :--- | :--- | :--- | :--- |
| Network Mode | Bridged | NAT | The campus network filters by MAC address and drops Bridged guests. NAT shares the host's IP, bypassing the filter while providing internet. |
| Windows Hardware | Basic | TPM Added (Encrypted) | Windows 11 strictly requires a Trusted Platform Module (TPM 2.0) to boot and install. |
| Disk Allocation | Pre-allocated | Thin provisioned | A dynamically allocated disk only consumes physical space as it fills up, saving crucial space on the 512 GB host SSD. |

**What went wrong and how I fixed it:**
During network testing, I could not ping the Windows guest from the Linux guest, receiving 100% packet loss. I realized the Windows Defender Firewall was blocking ICMPv4 requests by default. Instead of disabling the firewall completely-which is a security risk-I opened "Windows Defender Firewall with Advanced Security" and explicitly enabled the inbound rule `File and Printer Sharing (Echo Request - ICMPv4-In)`. The ping then succeeded.

## 4. Evidence
- [evidence/01-new-vm-wizard.png](evidence/01-new-vm-wizard.png) - shows the hypervisor's new-VM wizard with my CPU and RAM choices.
- [evidence/02-disk-settings.png](evidence/02-disk-settings.png) - proves the disk type is dynamically allocated (thin provisioned).
- [evidence/03-network-adapter.png](evidence/03-network-adapter.png) - shows the network mode set to NAT to bypass MAC filtering.
- [evidence/04-guest-uname.txt](evidence/04-guest-uname.txt) - shows the output of `uname -a` and `lsb_release -a` inside the Linux guest.
- [evidence/05-ping-between-guests.txt](evidence/05-ping-between-guests.txt) - proves connectivity: Linux to Windows, Windows to Linux, and each guest to the internet.
- [evidence/06-snapshot-list.png](evidence/06-snapshot-list.png) - shows the snapshot manager with the clean snapshot ready for rollback.

## 5. What I would do differently
Next time, I would allocate 6 GB of RAM to the Windows 11 guest from the very beginning. I initially started with 4 GB, but the evaluation OS lagged significantly and was unresponsive during the setup. Anticipating this and giving it 6 GB immediately would save time and make the configuration process much smoother.

## AI Usage Declaration

| Assignment | AI Tool | Purpose |
| :--- | :--- | :--- |
| Ticket 1 | Gemini | Used to clarify the assignment instructions in the step-by-step guide, refine the explanations in BUILD.md for non-technical users, and self-check the logic and completeness of the report. |
