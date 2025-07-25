# Kubernetes のビルド用仮想サーバー


## 仮想マシンのデプロイ

~~~
$ git clone <このGitHub>
$ cd marmot-build
$ mactl -api http://hv1:8750 -ccf cluster-config.yaml create
response Status: 200 OK
~~~


## デプロイ状態確認

~~~
$ mactl -api http://hv1:8750 -ccf cluster-config.yaml status
CLUSTER    VM-NAME          H-Visr STAT  VKEY                 VCPU  RAM    PubIP           PriIP           DATA STORAGE        
test       server1          hv1    RUN   vm_server1_0524      16    16383  172.16.99.101                   100 100 
~~~


## グローバルステータス確認

~~~
ubuntu@hmc:~/marmot-build$ mactl global-status

               *** SYSTEM STATUS ***
HV-NAME    ONL IPaddr          VCPU      RAM(MB)        Storage(GB) 
hv1        RUN 10.1.0.11          8/24    49153/65536   vg1(ssd):   883/931   vg2(nvme):  1707/1907  vg3(hdd):   931/931   

CLUSTER    VM-NAME          H-Visr STAT  VKEY                 VCPU  RAM    PubIP           PriIP           DATA STORAGE        
test       server1          hv1    RUN   vm_server1_0524      16    16383  172.16.99.101                   100 100 
~~~

## Ansibleの疎通確認

~~~
$ ansible -i inventory -m ping all
server1 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
~~~


## Ansble プレイブックの適用

Kubernetes のビルド環境を作るには、以下の二つのプレイブックを提供する。
一つ目(setup_base.yaml)が GoやDockerのビルド環境、2つ目(setup_build.yaml)が、Kubernetesのリポジトリのクローンなどです。

~~~
$ ansible-playbook -i inventory playbook/setup_base.yaml 
$ ansible-playbook -i inventory playbook/setup_build.yaml 
~~~


## 仮想マシンの停止と再開

仮想マシンを停止することで、CPUとメモリのリソースを解放して、他に利用することができる。
この仮想マシンを停止するには、marmot-buildのディレクトリで`mactl stop`を実行する。 

~~~
$ mactl stop
成功終了
~~~

停止の確認は以下のコマンドを利用して、`STAT`が`STOP`になっていれば、停止したことになる。

~~~
$ mactl status
CLUSTER    VM-NAME          H-Visr STAT  VKEY                 VCPU  RAM    PubIP           PriIP           DATA STORAGE        
test       server1          hv1    STOP  vm_server1_0524      16    16383  172.16.99.101                   100 100 
~~~

次のコマンドで、残りのリソースを含めて全体を確認できる。

~~~
$ mactl global-status

               *** SYSTEM STATUS ***
HV-NAME    ONL IPaddr          VCPU      RAM(MB)        Storage(GB) 
hv1        RUN 10.1.0.11         24/24    65536/65536   vg1(ssd):   883/931   vg2(nvme):  1707/1907  vg3(hdd):   931/931   

CLUSTER    VM-NAME          H-Visr STAT  VKEY                 VCPU  RAM    PubIP           PriIP           DATA STORAGE        
test       server1          hv1    STOP  vm_server1_0524      16    16383  172.16.99.101                   100 100 
~~~

再開は、`mactl start`を実行する。


## 仮想マシンの削除

~~~
$ mactl -api http://hv1:8750 -ccf cluster-config.yaml destroy
~~~


## Kubernetesのビルド

`/build/src` の下に、リリースごとに、ディレクトリが作成される。

~~~
ubuntu@hmc:~$ ssh ubuntu@172.16.99.101
$ cd /build/src
~~~

目的のリリースに移動して、`build.sh` を実行する。
作成したバイナリ、コンテナのイメージは、/nfs/kubernetesの下に展開される。
ブラウザで、http://hmc.labo.local/dl/ を開いて、ダウンロードできる。


ビルドするリリースバージョンを変更するには、inventory の15行目を変更する。

~~~
ubuntu@hmc:~/marmot-build$ cat -n inventory 
     1  # Generate by mactl gen-inv
     2  server1  ansible_ssh_host=172.16.99.101  ansible_ssh_private_key_file=~/.ssh/id_rsa  ansible_ssh_user=root
     3
     4  [all:vars]
     5  work_dir        = "/build"
     6  download_dir    = "{{ work_dir }}/download"
     7  go_version      = "1.20.5"
     8  docker_version  = "5:24.0.2-1~ubuntu.20.04~focal"
     9  docker_compose_version = "1.26.2"
    10  cluster_admin   = "ubuntu"
    11  cadmin_home     = "/home/{{ cluster_admin }}"
    12  ca_kubeconfig   = "{{ work_dir }}/kubeconfig"
    13  internal_subnet = "192.168.1.0/24"
    14  public_ip_dns   = "192.168.1.4"
    15  k8s_version     = "1.27"
    16  k8s_release     = "release-{{ k8s_version }}"
~~~


container-images/docker/registry/v2/repositories/hello-world/_layers/sha256
