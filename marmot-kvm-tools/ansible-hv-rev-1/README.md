# LVMとOVSを利用した新しいハイパーバイザーノード


MEMO

## OVSの設定

Open-vSwitch を使ってブリッジ接続を作成する。
ハイパーバイザーノードのNIC enp5s0f0 が 192.168.1.0/24 で、外部に公開可能なアドレス
enp5s0f1は、ノード間ネットワーク用のブリッジ接続のパスとなる。

~~~
root@hv1:/home/ubuntu# ovs-vsctl add-br public
root@hv1:/home/ubuntu# ovs-vsctl add-br private
root@hv1:/home/ubuntu# ovs-vsctl list-br
private
public
root@hv1:/home/ubuntu# 
root@hv1:/home/ubuntu# ovs-vsctl add-port public enp5s0f0
root@hv1:/home/ubuntu# ovs-vsctl add-port private enp5s0f1
root@hv1:/home/ubuntu# ovs-vsctl list br
~~~

enp5s0f0/enp5s0f1 は、コンテナ用ブリッジ接続
enp4s0 は、ハイパーバイザーノードの管理用NIC 10.1.0.0/24
wlp3s0 は、ハイパーバイザーノードの外部アクセス用 兼 仮想マシンのセットアップに利用 DHCP


## LVMの設定

/dev/sda 1000GB LVM領域 仮想マシンの起動ディスク、追加ボリューム
/dev/sdb 480GB　ワークストレージ　作業が完了したら、LVM領域へ変更する
/dev/sdc 120GB  ハイパーバイザーノードのOS起動用 非LVM領域


LVMのPVとして登録するには、論理区画を切っておかなければならない。
そのため、fdiskで論理区画を設定する。

~~~
# fdisk /dev/sda

Command (m for help): n
Partition number (1-128, default 1): 
First sector (34-1953525134, default 2048): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-1953525134, default 1953525134): 

Created a new partition 1 of type 'Linux filesystem' and of size 931.5 GiB.

Command (m for help): p
Disk /dev/sda: 931.53 GiB, 1000204886016 bytes, 1953525168 sectors
Disk model: SanDisk SDSSDH3 
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 324EA98B-2A9C-11EA-BF8F-B0359FB28594

Device     Start        End    Sectors   Size Type
/dev/sda1   2048 1953525134 1953523087 931.5G Linux filesystem

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.
~~~

LVMの物理ボリューム(PVC)として /dev/sda1を登録する

~~~
root@hv1:/home/ubuntu# pvcreate /dev/sda1
  Physical volume "/dev/sda1" successfully created.
~~~


OSテンプレートのボリュームとして、lv01を作成する。

~~~
root@hv1:/home/ubuntu# lvcreate -n lv01 -L 16G vg1
~~~


上記ボリュームに、Ubuntu 20.04.5 をインストールする。


インスタンス用ボリュームをスナップショットで作成する。
これにより作られたボリュームを使って、ノードを作成する。

~~~
root@hv1:/home/ubuntu# lvcreate -s -L 8G -n lv03 /dev/vg1/lv01
~~~

## 仮想マシンの起動

仮想マシンは、