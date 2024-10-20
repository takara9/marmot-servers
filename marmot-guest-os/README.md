# marmot-guest-os

このAnsibleプレイブックは、Ubuntu18.04/20.04 のOSテンプレートイメージを作成するための構成ファイルです。
条件として以下のコマンドが実行され、ansibleがインストールされていなければなりません。

~~~
sudo -s
apt update && apt install ansible -y
~~~


適用方法

~~~
git clone https://github.com/takara9/marmot-guest-os
cd marmot-guest-os
ansible-playbook install.yaml
~~~

正常に完了したらリブートします。

~~~
reboot
~~~


## 設定概要

このAnsibleプレイブックは、QEMU/KVMで動作する仮想マシンとして、必要最小の設定を実施する。
実施内容を以下の箇条書きにする。

* curl,rubyのインストール
* シリアルコンソーツの有効化
* 自動updateの禁止
* SWAPの禁止





