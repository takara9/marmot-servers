# ISOファイルからテンプレートイメージの作成方法 Ubuntu


## Grub の設定ファイルを編集

仮想マシンに Virtual Machine Manager の画面からログインして、/etc/default/grub を編集する。


~~~
sudo -s
password for ubuntu: ubuntu

vi /etc/default/grub
~~~


## 編集箇所

次のファイルの下３行と同じになるように編集する。

~~~file:/etc/default/grub
GRUB_DEFAULT=0
#GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=""

GRUB_CMDLINE_LINUX="console=tty1 console=ttyS0,115200"
GRUB_TERMINAL="console serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
~~~


## 設定を反映させ、再起動する

~~~
# grub-mkconfig -o /boot/grub/grub.cfg
# reboot
~~~



## 仮想シリアルラインからのログイン

仮想マシンをリストして、ログインしたいマシンのId を取得する

~~~
[tkr@yukikaze virt]$ sudo virsh 
virsh # list
 Id    Name                           State
----------------------------------------------------
 2     ubuntu                         running
~~~

次のコマンドで、仮想シリアルラインからログインする。

~~~
[tkr@yukikaze virt]$ sudo virsh console 2
Connected to domain ubuntu
Escape character is ^]

Ubuntu 20.04.5 LTS ubuntu ttyS0

ubuntu login: 
~~~

ログアウトする時は、Ctrlキーを押しながら"]"キーを押すことでログアウトができる。





## その他


### ubuntuにroot昇格権限付与

~~~
cat /etc/sudoers.d/ubuntu
Defaults:ubuntu !requiretty
ubuntu ALL = (ALL) NOPASSWD:ALL
~~~

