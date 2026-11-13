# Lab 4 - Partition, mirror, fail, recover

Pair: Barat Alimkhan (Solo) - Date: 13.11.2026 - Hypervisor: VMware Workstation Pro

## Windows

```powershell
Get-Disk | Select Number, FriendlyName, PartitionStyle, Size
```
```text
Number FriendlyName             PartitionStyle Size
------ ------------             -------------- ----
     0 VMware Virtual NVMe Disk GPT            68719476736
     1 VMware Virtual NVMe Disk GPT            1073741824
```

```powershell
Get-Volume | Where FileSystemLabel -eq 'LAB04'
```
```text
DriveLetter FileSystemLabel FileSystemType DriveType SizeRemaining Size
----------- --------------- -------------- --------- ------------- ----
D           LAB04           NTFS           Fixed     994111488     1056894976
```

MBR or GPT: I chose GPT because Windows 11 boots with UEFI, which requires a GPT partition style. Furthermore, GPT provides better reliability by maintaining a backup copy of the partition table at the end of the disk and calculating checksums for data integrity.

## Linux - layout before and after

### Before
```text
NAME                       SIZE TYPE FSTYPE      MOUNTPOINTS
loop0                     66.8M loop squashfs    /snap/core24/1643
loop1                      1.5M loop squashfs    /snap/hwctl/131
loop2                     50.1M loop squashfs    /snap/snapd/27710
loop3                      1.5M loop squashfs    /snap/hwctl/123
loop4                     44.7M loop squashfs    /snap/snapd/28254
sda                         25G disk 
├─sda1                       1M part 
├─sda2                       2G part ext4        /boot
└─sda3                      23G part LVM2_member 
  └─ubuntu--vg-ubuntu--lv 11.5G lvm  ext4        /
sdb                          1G disk 
sdc                          1G disk 
sdd                          1G disk 
sr0                        2.7G rom  iso9660
```

### After
```text
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
  └─md0                   1021M raid1 ext4              /mnt/mirror
sdc                          1G disk 
└─sdc1                    1022M part  linux_raid_member 
  └─md0                   1021M raid1 ext4              /mnt/mirror
sdd                          1G disk
└─sdd1                    1022M part
sr0                        2.7G rom   iso9660
```

## What I did

```bash
mkdir -p ~/lab04/evidence && cd ~/lab04
{ echo '$ lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS'; lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS; } > evidence/lsblk-before.txt

for d in sdb sdc sdd; do
  sudo parted -s /dev/$d mklabel gpt mkpart primary 1MiB 100% set 1 raid on
done

sudo apt install -y mdadm
sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
{ echo '$cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-healthy.txt

sudo mkfs.ext4 -L mirror /dev/md0
sudo mkdir -p /mnt/mirror
sudo mount /dev/md0 /mnt/mirror
sudo chown $USER: /mnt/mirror
echo "Lab 4 proof file - Barat Alimkhan - $(date)" > /mnt/mirror/proof.txt
head -c 20M /dev/urandom > /mnt/mirror/random.bin
cd /mnt/mirror && { echo '$ sha256sum proof.txt random.bin'; sha256sum proof.txt random.bin; } > ~/lab04/evidence/checksum-before.txt; cd ~/lab04

sudo mdadm /dev/md0 --fail /dev/sdc1
sudo mdadm /dev/md0 --remove /dev/sdc1
{ echo '$cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-degraded.txt
cd /mnt/mirror && { echo '$ sha256sum proof.txt random.bin'; sha256sum proof.txt random.bin; } > ~/lab04/evidence/checksum-after-failure.txt; cd ~/lab04

sudo mdadm /dev/md0 --add /dev/sdc1
{ echo '$cat /proc/mdstat'; cat /proc/mdstat; echo; echo '$ sudo mdadm --detail /dev/md0'; sudo mdadm --detail /dev/md0; } > evidence/array-rebuilt.txt

sudo mdadm --detail --scan | sudo tee -a /etc/mdadm/mdadm.conf
sudo update-initramfs -u
```

## Three states

| State | What /proc/mdstat showed | File |
| --- | --- | --- |
| Healthy | [2/2] [UU] | [evidence/array-healthy.txt](evidence/array-healthy.txt) |
| Degraded | [2/1] [U_] | [evidence/array-degraded.txt](evidence/array-degraded.txt) |
| Rebuilt | [2/2] [UU], sdc1 was added back | [evidence/array-rebuilt.txt](evidence/array-rebuilt.txt) |

Checksums before and after the failure: match.

## RAID is not a backup

No, RAID 1 does not help in this situation. A RAID 1 mirror instantly replicates all changes across the disks, meaning the accidental deletion was immediately applied to both drives simultaneously. To recover a deleted file, the colleague would need a true backup or a previous snapshot, not a high-availability hardware mirror.

## What did not work the first time

- What I saw: When I was already at steps 8 and 9, the third disk was missing from the system, and I could not rebuild the array.
- What it was: I initially added the third virtual hard disk to the wrong controller section in the VMware settings. Because of this, the disk kept disappearing after creation and the Ubuntu OS could not see it.
- What I did: I had to power off the virtual machine, delete the wrong disk, re-add the new hard disk to the correct controller (the same one as the system disk), and redo the previous steps to finish the lab successfully.

## Evidence

- [evidence/lsblk-before.txt](evidence/lsblk-before.txt) - Initial state showing the empty 1 GB virtual disks.
- [evidence/array-healthy.txt](evidence/array-healthy.txt) - RAID 1 array in a healthy state.
- [evidence/array-degraded.txt](evidence/array-degraded.txt) - RAID 1 array in a degraded state.
- [evidence/checksum-before.txt](evidence/checksum-before.txt) - Checksums before disk failure.
- [evidence/checksum-after-failure.txt](evidence/checksum-after-failure.txt) - Checksums after disk failure.
- [evidence/array-rebuilt.txt](evidence/array-rebuilt.txt) - RAID 1 array successfully rebuilt.
