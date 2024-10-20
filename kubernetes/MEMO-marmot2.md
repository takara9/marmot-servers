# 手作業を減らすためのツール

* cluster-config.yaml をインプットにして、ノード数に関係する部分のテンプレートファイルの生成
   * hosts_kvm
   * base_linux/templates/hosts.j2

* マスターノードからのkubeconfig の取得と環境変数の設定


mactl に機能追加が良いね。


~~~
mactl gen-inv  <--- cluster-config.yaml をインプットにして、inventory を生成
                        グローバル変数は、別のファイル(ansible-vars.yaml) が読んで、後部に結合する形にする。
			hmcは、DNSに登録しておく、エントリーしない。
　　　		　　　　hostsファイルの生成が必要 playbook//base_linux/templates/hosts.j2
			playbook/base_linux/vars/main.yamlを生成
			playbook/vars/main.yaml を生成
# 既存に手を入れない
mactl create
mactl status
ansible -i host_kvm -m ping all
ansible-playbook -i host_kvm playbook/install.yaml
# ここまで

mactl get-kubeconfig <--- kubecofigをゲットして、環境変数に追加
                          scp root@master1:/etc/kubernetes/admin.conf admin.kubeconfig
			  export KUBECONFIG=`pwd`/admin.kubeconfig
~~~




