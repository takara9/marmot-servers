# Private ネットワークの設定

enp3s0f1 のブリッドネットワークに接続する172.16.0.8のゲストVMと、ホストOSの間で、通信を確保する。


## 仮想マシン用privateブリッジの作成

以下のnet-bridge.xmlを作成する。IPアドレスはノードごとに変更する。

~~~
<network>
  <name>private</name>
  <bridge name='virbr1' stp='on' delay='0'/>
  <ip address='172.16.0.254' netmask='255.255.0.0'/>
</network>
~~~


設定は永続化するために、いきなりnet-createで作成するのではなく、
net-defineで定義したあとnet-start, net-autostartを設定する。

~~~
# virsh net-define net-bridge.xml
# virsh net-start private
# virsh net-autostart private
~~~



## コマンドによる物理インタフェースとの接続

コマンドで、仮想ブリッジと物理インタフェースを繋ぐ場合は以下を実行する。
ただし、再起動すると設定が消えるので、テストにしか利用できない。

~~~
$ sudo ip link set enp3s0f1 master virbr1
~~~


## systemdから物理インタフェースと接続

ホストを再起動しても設定が残るようにするには、
以下のbridge.serviceファイルを/etc/systemd/systemに置く。

~~~
[Unit]
Description=Job that runs your user script
After=libvirt-guests.service

[Service]
ExecStart=/usr/sbin/ip link set enp3s0f1 master virbr1
Type=oneshot
RemainAfterExit=yes
Restart=on-failure

[Install]
WantedBy = multi-user.target
~~~

設定を有効にして、設定を保存する。

~~~
# systemctl daemon-reload
# systemctl start bridge
# systemctl enable bridge
~~~




## 確認

仮想ネットワークの確認

~~~
tkr@hv2:~$ virsh net-list
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
 private   active   yes         yes
~~~


仮想ブリッジの確認

~~~
tkr@hv2:~$ brctl show virbr1
bridge name	bridge id		STP enabled	interfaces
virbr1		8000.525400488b86	yes		enp3s0f1
							virbr1-nic
							vnet1
~~~

物理インタフェースと仮想ブリッジの接続確認

~~~
tkr@hv2:~$ sudo ip link show enp3s0f1
4: enp3s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel master virbr1 state UP mode DEFAULT group default qlen 1000
    link/ether 00:15:17:2e:3c:47 brd ff:ff:ff:ff:ff:ff
~~~



# Public ネットワークの設定

net-public.xmlのファイルを作成

~~~
<network>
  <name>public</name>
  <forward mode="bridge">
    <interface dev="enp3s0f0"/>
  </forward>
</network>
~~~

仮想ネットワークを設定する。

~~~
# virsh net-define net-public.xml
# virsh net-start public
# virsh net-autostart public
~~~

設定確認

~~~
tkr@hv2:~$ virsh net-list
 Name      State    Autostart   Persistent
--------------------------------------------
 default   active   yes         yes
 private   active   yes         yes
 public    active   yes         yes
~~~






参考資料
https://atmarkit.itmedia.co.jp/ait/articles/1709/28/news029.html
https://linuxconfig.org/how-to-use-bridged-networking-with-libvirt-and-kvm
https://qiita.com/hana_shin/items/3fc67e2e6132bd534932
https://www.it-mure.jp.net/ja/libvirt/virsh%E3%81%A7%E3%83%8D%E3%83%83%E3%83%88%E3%83%AF%E3%83%BC%E3%82%AF%E3%81%AE%E5%A4%89%E6%9B%B4%E3%82%92%E4%BF%9D%E5%AD%98%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%84%E3%81%AE%E3%81%AF%E3%81%AA%E3%81%9C%E3%81%A7%E3%81%99%E3%81%8B%EF%BC%9F/960258907/


