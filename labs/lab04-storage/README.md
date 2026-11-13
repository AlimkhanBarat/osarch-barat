# Lab 4 — Partition, mirror, fail, recover

Pair: <name> + <name> · Date: <date> · Hypervisor: <VirtualBox / VMware / UTM>

## Windows
Number FriendlyName             PartitionStyle        Size
------ ------------             --------------        ----
     0 VMware Virtual NVMe Disk GPT            68719476736
     1 VMware Virtual NVMe Disk GPT             1073741824
                                                1056894976
MBR or GPT: I chose GPT because Windows 11 boots with UEFI, which requires a GPT partition style. Furthermore, GPT is more reliable as it keeps a backup copy of the partition table.

## Linux — layout before and after
### Before
<lsblk before>
### After
barat@localhost:~$ lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS
NAME                       SIZE TYPE  FSTYPE            MOUNTPOINTS
loop0                      1.5M loop  squashfs          /snap/hwctl/131
loop1                      1.5M loop  squashfs          /snap/hwctl/123
loop2                     66.8M loop  squashfs          /snap/core24/1643
loop3                     50.1M loop  squashfs          /snap/snapd/27710
loop4                     44.7M loop  squashfs          /snap/snapd/28254
sda                         25G disk
├─sda1                       1M part
├─sda2                       2G part  ext4              /boot
└─sda3                      23G part  LVM2_member
  └─ubuntu--vg-ubuntu--lv 11.5G lvm   ext4              /
sdb                          1G disk
└─sdb1                    1022M part  linux_raid_member
  └─md0                   1021M raid1 ext4
sdc                          1G disk
└─sdc1                    1022M part  linux_raid_member
  └─md0                   1021M raid1 ext4
sr0                        2.7G rom   iso9660

## What I did
<the commands, in order, in code blocks — create, fail, rebuild>

## Three states

| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | [2/2] [UU] | evidence/array-healthy.txt |
| Degraded | [2/1] [U_] | evidence/array-degraded.txt |
| Rebuilt | [2/2] [UU], sdd1 replaced sdc1 | evidence/array-rebuilt.txt |
Checksums before and after the failure: <match / do not match>

## RAID is not a backup
Your colleague deleted the wrong file from the mirror an hour ago. Does RAID 1 help? Why?
<three sentences>

## What did not work the first time
- **What I saw:** When adding the third disk, I got the error `mdadm: stat failed for /dev/sdd1: No such file or directory`.
- **What it was:** I used the hardware method to fail the disk (removed it in VMware and rebooted). Because the second disk was physically missing, Ubuntu shifted the letters and renamed the third disk from `sdd` to `sdc`.
- **What I did:** I ran `lsblk` to check the new names, found the 1GB disk was now `sdc1`, and successfully added it with `sudo mdadm /dev/md0 --add /dev/sdc1`.
