libvirtdを分散環境で利用するために、プライベートなデジタル証明書を作成して配布するためのansibleのplaybookです。


次のような構成を想定したもので、ハイパーバイザーの管理サーバー(Hypervisor Management Server)の管理下に、複数のHypervisorを搭載するサーバーで構成されることを想定しています。

~~~
hmc       ハイパーバイザーの管理サーバー
├── hv1　 ハイパーバイザー搭載サーバー #1
├── hv2　 ハイパーバイザー搭載サーバー #2
├── hv3　 ハイパーバイザー搭載サーバー #3
└── hv4   ハイパーバイザー搭載サーバー #4
~~~

ハイパーバイザーのソフトウェアは、Linux の virsh と libvirtd であり、QEMUとKVMを操作します。

hmcのvirsh から各サーバーのlibvirtdに操作するためには、同一の認証局に署名されたサーバー証明書とクライアント証明書が必要となる。


本playbookでは、以下を実行する。

* CAの証明書と鍵を作成
* CAの証明書を各サーバーへ配置
* hv1〜4 のサーバー証明書と鍵を作成
* サーバー証明書と鍵を各サーバーへ配置
* hv1〜4 のクライアント証明書と鍵を作成
* クライアント証明書と鍵を各サーバーへ配置


## Ansible の環境設定確認

hmcから各hvに対して、ansibleのpingが通っていることを確認する。

~~~
tkr@hmc:~/marmot-k8s/tools-vm/ansible-hv-ca$ sudo ansible -i hosts_hv -m ping all
hv1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
hv3 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
hv4 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
hv2 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
~~~




## セットアップ

次のプレイブックにより、インベントリに登録されたハイパーバイザーノードと管理サーバーに、libvirtdの証明書の設定を実施する。


~~~
tkr@hmc:~/marmot-k8s/tools-vm/ansible-hv-ca$ sudo ansible-playbook -i hosts_hv setup-1-hv-cluster.yaml
~~~

