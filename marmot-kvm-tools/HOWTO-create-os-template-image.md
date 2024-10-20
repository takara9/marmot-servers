# ISOファイルからテンプレートイメージの作成方法 Ubuntu18.04

~~~
# yum install ruby rubygem-bundler
~~~


## 1 ISOイメージのダウンロード

~~~
curl -O -L https://releases.ubuntu.com/18.04/ubuntu-18.04.5-live-server-amd64.iso
mv ubuntu-18.04.5-live-server-amd64.iso /var/lib/libvirt/images/
~~~



## 2 ISOイメージから仮想サーバーの起動


GUI画面のメニューで選択ポイント列挙

~~~
---
File -> New Virtual Machine 
Check [Local install media (ISO image or CDROM)]
Click Forward
~~~


~~~
---
Choose ISO or CDROM install media:
[ubuntu-18.04.5-live-server-amd64.iso]
Click Forward
~~~

~~~
---
Memory: 1024
CPUs: 1

Click Forward
~~~


~~~
---
Check Enable storage for this virual machine

Select Create a disk image for the virtual machine
12 GiB
~~~


~~~
---
Ready to begin the installation

Name ubuntu18.04

Click Finish
~~~





# 3 Ubuntu 18.04のインストール


~~~
Open QEMU/KVM Window

start Ubntu install process
~~~


~~~
---
select your language

English
~~~


~~~
---
Installer update available

Continue without updating

Choice [Continue without upating]
~~~

~~~
---
Keyboard configuration

Layout [ Japanese ]

[Done]

~~~


~~~
----
Network connections

[Done]
~~~


~~~
----
Configure proxy

[Done]
~~~



~~~
----
Confirure Ubnutu archive mirror

[Done]
~~~


~~~
---
Guided storage configuration
use default value

[Done]
~~~


~~~
---
Storage configuration
use default value

[Done]
~~~


~~~
for Confirm Window
[Continue]
~~~


~~~
---
Profile setup

Your name: Ubuntu
Your server's name:  ubuntu
Pick a username: ubuntu
Choose a password: ubuntu
Confirm your password: ubuntu
[Done]
~~~


~~~
----
SSH Setup

Check Install OpenSSH server
[Done]

~~~

~~~
----
Featured Server Snaps

no action
[Done]
~~~

~~~
----
Installation complete!

[Reboot]
~~~



# 4 シリアルコンソールの設定

shutdown vm


~~~
root@yukikaze:/home/images# ls -al
total 3069520
drwxrwxr-x 2 root root        4096  2月  7 07:53 .
drwxr-xr-x 4 root root        4096  2月  6 21:49 ..
-rw------- 1 root root 12887130112  2月  7 07:53 ubuntu18.04.qcow2
root@yukikaze:/home/images# modprobe nbd max_part=8
root@yukikaze:/home/images# qemu-nbd --connect=/dev/nbd2 ubuntu18.04.qcow2 
root@yukikaze:/home/images# lsblk
NAME     MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
loop0      7:0    0 255.6M  1 loop /snap/gnome-3-34-1804/36
loop1      7:1    0    55M  1 loop /snap/core18/1880
loop2      7:2    0  62.1M  1 loop /snap/gtk-common-themes/1506
loop3      7:3    0  29.9M  1 loop /snap/snapd/8542
loop4      7:4    0  49.8M  1 loop /snap/snap-store/467
sda        8:0    0 931.5G  0 disk 
├─sda1     8:1    0   128M  0 part 
└─sda2     8:2    0 931.4G  0 part 
sdb        8:16   0 111.8G  0 disk 
├─sdb1     8:17   0   300M  0 part 
├─sdb2     8:18   0   100M  0 part /boot/efi
├─sdb3     8:19   0   128M  0 part 
├─sdb4     8:20   0   110G  0 part 
├─sdb5     8:21   0   892M  0 part 
└─sdb6     8:22   0   455M  0 part 
sdc        8:32   0 447.1G  0 disk 
├─sdc1     8:33   0   512M  0 part 
└─sdc2     8:34   0 446.6G  0 part /
sr0       11:0    1  1024M  0 rom  
nbd2      43:32   0    12G  0 disk 
├─nbd2p1  43:33   0     1M  0 part 
└─nbd2p2  43:34   0    12G  0 part 
root@yukikaze:/home/images# 
root@yukikaze:/home/images# mkdir /mnt/d2
root@yukikaze:/home/images# mount /dev/nbd2p2 /mnt/d2
~~~






~~~
[tkr@yukikaze virt]$ sudo virsh 
virsh # list
 Id    Name                           State
----------------------------------------------------
 2     ubuntu18.04                    running

virsh # Ctrl-D
~~~


login from Virtual Machine Manager

~~~
sudo -s
password for ubuntu: ubuntu

vi /etc/default/grub
~~~



~~~file:/etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
#GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0,115200"

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"

# Uncomment to disable graphical terminal (grub-pc only)
GRUB_TERMINAL="console serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command `vbeinfo'
#GRUB_GFXMODE=640x480

# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"
~~~

apply changed file

~~~
# grub-mkconfig -o /boot/grub/grub.cfg
# reboot
~~~


# misc

ubuntuにroot昇格権限付与

~~~
cat /etc/sudoers.d/ubuntu
Defaults:ubuntu !requiretty
ubuntu ALL = (ALL) NOPASSWD:ALL
~~~

ネットワークI/Fの設定変更
~~~
network:
  version: 2
  ethernets:
    enp1s0:
      dhcp4: false
    enp2s0:
      addresses:
      - 172.16.0.10/16
    enp3s0:
      addresses:
      - 192.168.1.10/24
      gateway4: 192.168.1.1
      nameservers:
        addresses:
        - 8.8.8.8
~~~





# Confirm serial login

~~~
[tkr@yukikaze virt]$ sudo virsh 
virsh # list
 Id    Name                           State
----------------------------------------------------
 2     ubuntu18.04                    running

virsh # Ctrl-D
~~~

if appear ubuntu login then successfuly done

~~~
[tkr@yukikaze virt]$ sudo virsh console 2
Connected to domain ubuntu18.04
Escape character is ^]

Ubuntu 18.04.5 LTS ubuntu ttyS0

ubuntu login: 
~~~


## Start VM

list stopped VM

~~~
virsh # list --all
 Id    Name                           State
----------------------------------------------------
 -     ubuntu18.04                    shut off
Ctrl-D
~~~

start VM

~~~
[tkr@yukikaze virt]$ sudo virsh start ubuntu18.04 --console
Ubuntu 18.04.5 LTS ubuntu ttyS0

ubuntu login: 
Ctrl-]
~~~


~~~
apt-get update -y
apt install net-tool ansible
~~~


~~~
virt-install  --name marmot-test --memory 2048 --vcpus 1 --cpu kvm64 --hvm --os-variant ubuntu20.04 --network network=default,model=virtio --network network=private --network bridge=virbr1 --import --graphics none --noautoconsole --disk /home/images/ubuntu20.04-12.qcow2
~~~

# Copy virtual DISK

[tkr@yukikaze virt]$ sudo -s
[root@yukikaze virt]# cp /var/lib/libvirt/images/ubuntu18.04.qcow2 .



$ sudo apt install -y ansible qemu-kvm libvirt-bin bridge-utils virtinst virt-manager ruby ruby-bundler virt-top


# Ubuntu 20.04
$ sudo apt install -y ansible qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager virt-top ruby ruby-bundler


$ systemctl is-active libvirtd
