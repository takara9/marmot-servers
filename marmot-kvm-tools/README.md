# marmot-kvm-tools

1. Ubuntu 20.04 Desktop のインストール
1. ~/.ssh の準備　GitHubに登録したパブリックキーに対応するプライベートキーを配置
1. IPアドレスの設定とルーティング設定
1. sshd のインストール apt install ssh
1. GitHub https://github.com/takara9/marmot-kvm-tools のクローン
1. Ansible のインストール　apt update && apt install ansible
1. Ansible の動作テスト

~~~
$ sudo -s
# cd marmot-kvm-tools/ansible-hv-single-node
# ansible-playbook -i hosts  test.yaml
~~~

1. KVM,QEMUなど仮想環境のインストール

* [LVMとOVSを利用した新しいハイパーバイザーノード](ansible-hv-rev-1)
* [旧ハイパーバイザークラスタノードのセットアップ]ansible-hv-node)
* [旧管理ノード兼ハイパーバイザーノードのセットアップ](ansible-hv-single-node)
* [ブリッジの設定](HOWTO-setup-bridge.md)


ディレクトリを ansible-hv-rev-1 へ移動

~~~
# cd ansible-hv-rev-1
# ansible-playbook -i hosts install.yaml 
~~~





* [Marmotコマンドのインストール方法](HOWTO-install-command.md)
* [ansible-client-setup](ansible-client-setup)
* [ansible-hv-ca](ansible-hv-ca)
* [HOWTO-create-os-template-image.md](HOWTO-create-os-template-image.md)


* [HOWTO-setup-ubuntu-desktop.md](HOWTO-setup-ubuntu-desktop.md)
* [MEMO.md](MEMO.md)
* [MEMO_ubunt20.04_error.md](MEMO_ubunt20.04_error.md)


