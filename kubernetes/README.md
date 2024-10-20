# Marmot-K8s 

実験動物のモルモットにかけて、Kubernetesの学習と実験用を目的としたアップストリームKubernetesのクラスタ構成するためのコード群です。Kubernetesの本番システムの設計のための検証など、小規模の実験環境を構築することを目的とします。




B. LinuxのQEMU+KVMのクラスタ構成上で、Kubernetesクラスタを構成
  1. マルチマスター構成　３台のマスターノードとETCDの構成、内部ロードバランサーの構成
  2. 外部ロードバランサー 代表IP、リバースプロキシー、CoreDNS連携したServiceタイプ LoadBalancerの実装
  3. ROOK Cephによるブロックストレージの動的プロビジョニング
  4. Grafana,Promethus,metrics-serverによるメトリックス監視
  5. Kibana,Elasticsearch,FileBeatによるログ収集と分析
  6. Istioによるサービスメッシュ Kiali, Eagerによる可観測性の実現
  7. Knativeによるサーバーレス環境の実現
  8. 複数Linux QEMU/LVMクラスタの構成、および、VMのHypervisorへのスケジューリング（空き資源による自動割当て）

### git clone でサブモジュールまで取得する方法

~~~
git clone ssh://git@github.com/takara9/marmot-k8s --recursive
~~~


### サブモジュールのアップデート方法
サブモジュールは、コミットIDでリンクするため、サブモジュールを設定したときのコミットと
リンクしています。そのため、最新のサブモジュールに変更する場合は、サブモジュールに移動して
次のコマンドを実行します。

~~~
cd manifests/webapl-01-nodejs
git fetch && git reset --hard origin/master 
~~~



このMarmot K8sには、以下の特徴がある。

* K8sクラスタの仮想マシンの構築は、マスター/ワーカーそしてロードバランサーなどを起動する。
* kubeadm などツールを使用せず、playbook を読めば、すべての作業が手作業で再現できることを目指す。
* ローカルでソースコードからビルドしたKubernetesをデプロイできることを目指す。
* クラスタ・ネットワークは、CNIプラグインとして bridge, flannel, calico を使用できることを目指す。
* kube-apiserver,kube-controller-manager,kube-scheduler,kube-proxy,kubeletなどはsystemd から起動する。
* マスターノードの数は１〜３を選択できる。そしてetcdはマスターノードで動作する。マスターノードが複数の場合はetcdは、それぞれをpeerとして高可用性を実現する。
* マスターノードを複数で稼働させる場合は、HA構成のHA-Proxyをmlb1とmlb2として、keeepalivedを併用してVIPを設定する。
* K8sクラスタ外部からK8sサービスへのリクエスト転送は、HA-ProxyとKeepalivedで構成した elb1/elb2 のVIPで受けて内部へ転送する。
* 外部ロードバランサーに、ロードバランサーコントローラーを構成して、Service の Type Loadbalancer を指定した場合、VIPの獲得、DNS設定、Keepalived,HA-Proxyを自動設定する。
* K8sクラスタの構成は、構成ファイルから選択することで、自動的に起動できる。


--- 以下作成途上 ---

![RatK8sのシステム概要](docs/images/ratk8s_overview.png)


## 構成パターン

学習や設計のための検証実験など、目的に応じて構成を変更できるようにした。 Ansibleのプレイブックの生成プログラム setup.rbがcluster-configの定義ファイルをプレイブックの生成プログラム setup.rbが読んで必要なプレイブックの要素を生成する事で実現する。

* [最小構成](docs/config-02.md) マスターノード x1, ワーカーノード x1、ブートノード x1
* [デフォルト構成](docs/config-03.md) マスターノード x1, ワーカーノード x1、ブートノード x1
* [フル構成](docs/config-01.md) フロントLB アクティブ・スタンバイ構成,マスターノード用LB アクティブ・スタンバイ構成,マスターノード x3, アプリ用ワーカーノード x3, 永続ストレージ用ワーカーノード x3、ブートノード x1
* [フル構成+](docs/config-04.md) フロントLB アクティブ・スタンバイ構成,マスターノード用LB アクティブ・スタンバイ構成,マスターノード x3, アプリ用ワーカーノード x3, 永続ストレージ用ワーカーノード x3、ブートノード x1

※ ブートノードは、K8sクラスタを構成するノード群をAnsibleを使用して自動設定するためのノードで、AnsibleとNFSのサーバーとなっている。




## 基本的な起動方法



~~~
tkr@hmc:~$ git clone ssh://git@github.com/takara9/marmot-k8s k8s
~~~


~~~
tkr@hmc:~$ cd k8s
tkr@hmc:~$ screen
tkr@hmc:~$ sudo k8s-start -f cluster-config/kvm-full-3.yaml -s 0
...
TASK [addon_knative : change knative domain] ***********************************
changed: [bootnode]

PLAY RECAP *********************************************************************
bootnode                   : ok=79   changed=66   unreachable=0    failed=0   

admin.kubeconfig                                                       100% 6277     4.6MB/s   00:00    

export KUBECONFIG=/home/tkr/k8s4/admin.kubeconfig-k8s3

開始からの経過時刻 =  3003 秒
~~~


## 動作確認

Ansibleプレイブックの最後に環境変数の設定を表示するので、コピペしてkubectlコマンドを実行すれば良い
。

~~~
tkr@hmc:~/k8s4$ export KUBECONFIG=/home/tkr/k8s4/admin.kubeconfig-k8s3
tkr@hmc:~/k8s4$ kubectl get node
NAME       STATUS   ROLES     AGE   VERSION
master1    Ready    master    25m   v1.20.4
master2    Ready    master    25m   v1.20.4
master3    Ready    master    25m   v1.20.4
node1      Ready    worker    21m   v1.20.4
node2      Ready    worker    21m   v1.20.4
node3      Ready    worker    21m   v1.20.4
node4      Ready    worker    21m   v1.20.4
storage1   Ready    storage   21m   v1.20.4
storage2   Ready    storage   21m   v1.20.4
storage3   Ready    storage   21m   v1.20.4
storage4   Ready    storage   21m   v1.20.4


tkr@hmc:~/k8s4$ kubectl top node
NAME       CPU(cores)   CPU%   MEMORY(bytes)   MEMORY%   
master1    192m         9%     1368Mi          76%       
master2    111m         5%     1132Mi          63%       
master3    126m         6%     1337Mi          74%       
node1      82m          4%     1853Mi          23%       
node2      63m          3%     1280Mi          16%       
node3      71m          3%     1987Mi          25%       
node4      63m          3%     1306Mi          16%       
storage1   125m         4%     1935Mi          12%       
storage2   160m         5%     2965Mi          18%       
storage3   187m         6%     2843Mi          17%       
storage4   142m         4%     2910Mi          18%       


tkr@hmc:~/k8s4$ kubectl cluster-info
Kubernetes control plane is running at https://192.168.1.132:6443
CoreDNS is running at https://192.168.1.132:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
Metrics-server is running at https://192.168.1.132:6443/api/v1/namespaces/kube-system/services/https:metrics-server:/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
~~~



## クリーンナップ方法

起動に使ったコンフィグファイルを使用して、k8s-cleanupを実行する。

~~~
$ tkr@hmc:~/k8s$ sudo k8s-cleanup -f cluster-config/kvm-full-3.yaml 
~~~




## 前提条件

Ubunt Linux 18.04で、KVM, QEMU, Virsh/Virt がセットアップされた環境があること。



## 仮想サーバーのノード追加手順

クラスタが起動している状態から、仮想サーバーのワーカーノードを追加する方法
git clone したディレクトリで、以下にノードを追加する。

* Vagrantfile にノード追加
* hosts_vagrant にノード追加
* hosts_k8s にノード追加
* playbook/vars/main.yaml にノード追加
* playbook/base_linux/templates/hosts.j2
* vagrant up node2

ブートノードにログインして、以下を実行する
* vagrant ssh bootnode
* sudo vi /etc/hosts ノードのエントリ追加
* cd /vagrant
* ansible -i hosts_k8s all -m ping
* ansible-playbook -i hosts_k8s playbook/add-k8s-node.yaml
* kubectl get no で３ノード目の追加を確認



## ノードのIPアドレスとpingが通らない時の対処法

* ip route で問題のサブネットと vboxnetのインタフェース番号を確認
* VBoxManage hostonlyif remove vboxnet37 などで番号を指定して削除


## エッジクラスタの起動方法

このエッジノードは内部ネットワークを持たず、パブリックネットワークのみで稼働する

* エッジクラスタを構成する　./setup.rb -f cluster-config/edge-flannel.yaml
* エッジクラスタを起動する  vagrant up
* 環境変数 KUBECONFIG を設定してkubectl get nodeで確認する
* playbook/create_kubeconfig_node.yaml を編集してエッジのノード名とIPアドレスを設定
* ansible-playbook -i hosts_k8s playbook/create_kubeconfig_node.yaml を実行して証明書を作成
* ラズパイへ証明書などを転送する

ここからラズパイの作業

* ラズパイをインストールする。 ubuntu 18.04 で検証済み
* ラズパイにログインする
* プレイブックをクローンする git clone https://github.com/takara9/rat-k8s
* ディレクトリを移動する cd rat-k8s
* sudo ansible-playbook -i hosts_edge playbook/install_edge.yaml

ホスト、または、ブートノードでの作業

* kubectl get node でエッジノードの参加を確認


## Dashboad UIへのアクセス方法

トークンの表示

~~~
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret |grep kubernetes-dashboard-toke\
> n-* | awk '{print $1}') |awk '$1=="token:"{print $2}'
~~~

フル構成の場合
https://192.168.1.131:30445/#/login



## 起動を高速化する方法

`vagrant up` を実行する前に、以下のコマンドを実行しておくことで、起動の時間短縮ができる。

~~~
vagrant plugin install vagrant-cachier
~~~


