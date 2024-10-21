# VM上でCoreDNS他を構築するAnsibleプレイブック

## 概要

これはMarmotで起動した仮想マシン上で、CoreDNSサーバーを構成します。
また、このサーバーには、以下の設定が入っています。

* プライベート認証局
* プライベートドメインのDNSサーバー（CoreDNS）
* LDAPサーバー
* OIDC認証サーバー(Federated identity 環境)
* Nginx (Virtual Host環境)
* Docker & Docker-Compose 環境
* メールサーバー labo.localドメイン（予定）


## 起動方法

~~~
tkr@hmc:~/marmot-servers/marmot-coredns$ mactl create
成功終了

# 起動確認
tkr@hmc:~/marmot-servers/marmot-coredns$ ansible -i inventory all -m ping
coredns | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

# セットアップ
tkr@hmc:~/marmot-servers/marmot-coredns$ ansible-playbook -i inventory playbook/install.yaml 
PLAY [basic information] **********************************************************************
TASK [Gathering Facts] ************************************************************************
＜中略＞
TASK [ca-download : Copy file with owner and permissions] **************************************************************************************
changed: [coredns]

TASK [ca-download : Execute update-ca-certificates] ********************************************************************************************
changed: [coredns]

PLAY RECAP *************************************************************************************************************************************
coredns                    : ok=143  changed=130  unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
~~~

稼働確認
```
tkr@hmc:~/marmot-servers/marmot-coredns$ mactl status
CLUSTER    VM-NAME          H-Visr STAT  VKEY                 VCPU  RAM    PubIP           PriIP           DATA STORAGE        
infra      coredns          hv1    RUN   vm_coredns_0124      2     4096   172.16.0.8      192.168.1.8     2   2   2   2   2   
```

## 削除

~~~
tkr@hmc:~/marmot-servers/marmot-coredns$ mactl destroy
~~~

