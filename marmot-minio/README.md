# オブジェクトストレージ MinIO 

シングル構成のMinIOサーバーとフロントのNginxを設定します。

ドメインは　https://minio.labo.local/ です。このアドレスをアクセスするとMinIOコンソールが表示されます。


## 仮想マシンのデプロイ

~~~
$ git clone <このGitHub>
$ cd marmot-minio
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

オブジェクトストレージのセットアップには、以下のコマンドを実行する。

~~~
$ ansible-playbook -i inventory playbook/setup.yaml
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



## MinIOのクラスタ化

https://min.io/docs/minio/linux/operations/install-deploy-manage/deploy-minio-multi-node-multi-drive.html


## MinIOとNginx の設定方法

https://min.io/docs/minio/linux/integrations/setup-nginx-proxy-with-minio.html



## MinIOの使い方

https://min.io/docs/minio/linux/reference/minio-mc.html






