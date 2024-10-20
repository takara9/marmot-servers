
* cluster-config  K8sクラスタ構成ファイル
* setup.rb    cluster-configの構成ファイルからプレイブックの生成
* cleanup.sh  生成したプレイブックをクリーンナップ
* libruby　　 setup.rbで使用するライプラリ
* virt        QEMU/KVM, libvirtコマンドを使用するためのプログラムなど
* virt/ca     QEMU/KVM, libvirtでハイパーバイザーノードのクラスタを組むための証明書


構成ファイルから仮想サーバーを起動する
* vm-clean-up  　起動したVMを削除する
* vm-create.rb　 virt-install による仮想サーバーの起動、構成ファイルを指定
* vm-create-remote.rb  vm-create.rb のライブラリ
* vm-destroy.rb  構成ファイルを指定して起動したVMを削除
* vm-setup.rb    vm-create.rbで起動したVMにAnsibleを適用してセットアップ

一連の手作業を自動化するシェル
* vm-start     setup.rb,vm-destroy.rb,vm-create.rb,vm-setup.rbをバッチ処理として実行
* vm-retry     Ansible適用ステップで止まった場合のリトライ用
* vm-start-1　 ブートノードのセットアップplaybook/install_k8s-1.yamlまでを実行、その後は手作業を想定
* vm-start-2   vm-start-1からplaybook/install_k8s-7.yamlまでを順次適用するシェル


SREの作業を具達的に表現すると、どうなるだろうか？
