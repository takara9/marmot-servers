# marmot-test



## 仮想マシンのデプロイ

~~~
$ mactl -api http://hv1:8750 -ccf cluster-config.yaml create
response Status: 200 OK
~~~

## デプロイ状態確認

~~~
$ mactl -api http://hv1:8750 -ccf cluster-config.yaml status

               *** SYSTEM STATUS ***

HV-NAME    IPaddr           VCPU       RAM         
hv1        10.1.0.11        10  /12    61440 /65536 
hv2        10.1.0.12        11  /12    63488 /65536 

VM-NAME    H-Visr VKEY   VCPU  RAM    PubIP           PriIP           DATA STORAGE         
server1    hv1    vm173  2     4096   172.16.0.101    192.168.1.201   50 
server2    hv2    vm174  1     2048   172.16.0.102                    50
~~~

## Ansibleの疎通確認

~~~
$ ansible -i hosts_kvm -m ping all
server10 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
server12 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
~~~

## Ansble プレイブックの適用

~~~
$ ansible-playbook -i hosts_kvm playbook/install.yaml
~~~

## 仮想マシンの削除

~~~
$ mactl -api http://hv1:8750 -ccf cluster-config.yaml destroy
$ mactl -api http://hv1:8750 -ccf cluster-config.yaml status

               *** SYSTEM STATUS ***
HV-NAME    IPaddr           VCPU       RAM         
hv1        10.1.0.11        12  /12    65536 /65536 
hv2        10.1.0.12        12  /12    65536 /65536 

VM-NAME    H-Visr VKEY   VCPU  RAM    PubIP           PriIP           DATA STORAGE   
~~~



