# Marmot-K8s 

実験動物のモルモットにかけて、Kubernetesの学習と実験用を目的としたアップストリームKubernetesのクラスタ構成するためのコード群です。Kubernetesの本番システムの設計のための検証など、小規模の実験環境を構築することを目的とします。

## 機能概要
LinuxのQEMU+KVMのクラスタ構成上で、以下のことが可能なKubernetesクラスタを構成します。

  - マルチマスター構成　３台のマスターノードとETCDの構成、内部ロードバランサーの構成
  - 外部ロードバランサー 代表IP、リバースプロキシー、CoreDNS連携したServiceタイプ LoadBalancerの実装
  - ROOK Cephによるブロックストレージの動的プロビジョニング
  - Grafana,Promethus,metrics-serverによるメトリックス監視
  - Kibana,Elasticsearch,FileBeatによるログ収集と分析
  - Istioによるサービスメッシュ Kiali, Eagerによる可観測性の実現
  - Knativeによるサーバーレス環境の実現


## 起動方法

```
tkr@hmc:~/marmot-servers/kubernetes$ mactl create

tkr@hmc:~/marmot-servers/kubernetes$ mactl status
CLUSTER    VM-NAME          H-Visr STAT  VKEY                 VCPU  RAM    PubIP           PriIP           DATA STORAGE        
k8s3       elb1             hv1    RUN   vm_elb1_0201         1     2048   172.16.3.11     192.168.1.180   8   
k8s3       master1          hv1    RUN   vm_master1_0202      2     4096   172.16.3.21                     20  
k8s3       node1            hv1    RUN   vm_node1_0203        2     8196   172.16.3.31                     20  
k8s3       node2            hv1    RUN   vm_node2_0204        2     8196   172.16.3.32                     20  

tkr@hmc:~/marmot-servers/kubernetes$ ansible -i inventory all -m ping

tkr@hmc:~/marmot-servers/kubernetes$ ansible-playbook -i inventory playbook/install.yaml

TASK [addon_dashboard : setup kubeconfig] ******************************************************************************************************************************
changed: [master1]

PLAY RECAP *************************************************************************************************************************************************************
elb1                       : ok=80   changed=54   unreachable=0    failed=0    skipped=7    rescued=0    ignored=0   
master1                    : ok=108  changed=61   unreachable=0    failed=0    skipped=15   rescued=0    ignored=0   
node1                      : ok=64   changed=39   unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
node2                      : ok=64   changed=39   unreachable=0    failed=0    skipped=10   rescued=0    ignored=0   
```

kubectlのクライアント設定の取得方法
```
tkr@hmc:~/marmot-servers/kubernetes$ cd
tkr@hmc:~$ cd .kube
tkr@hmc:~/.kube$ sftp ubuntu@172.16.3.21
Connected to 172.16.3.21.
sftp> cd .kube
sftp> get config
Fetching /home/ubuntu/.kube/config to config
/home/ubuntu/.kube/config                                                                                                             100% 5655     1.8MB/s   00:00    
sftp> quit
```

Kubernetesクラスタの起動確認
```
tkr@hmc:~$ kubectl get no
NAME      STATUS   ROLES           AGE   VERSION
master1   Ready    control-plane   13m   v1.29.9
node1     Ready    worker          12m   v1.29.9
node2     Ready    worker          12m   v1.29.9
```

Kubernetes APIの確認
```
tkr@hmc:~$ kubectl get apiservices
NAME                                   SERVICE                      AVAILABLE   AGE
v1.                                    Local                        True        15m
v1.admissionregistration.k8s.io        Local                        True        15m
v1.apiextensions.k8s.io                Local                        True        15m
v1.apps                                Local                        True        15m
v1.authentication.k8s.io               Local                        True        15m
v1.authorization.k8s.io                Local                        True        15m
v1.autoscaling                         Local                        True        15m
v1.batch                               Local                        True        15m
v1.certificates.k8s.io                 Local                        True        15m
v1.coordination.k8s.io                 Local                        True        15m
v1.discovery.k8s.io                    Local                        True        15m
v1.events.k8s.io                       Local                        True        15m
v1.flowcontrol.apiserver.k8s.io        Local                        True        15m
v1.networking.k8s.io                   Local                        True        15m
v1.node.k8s.io                         Local                        True        15m
v1.policy                              Local                        True        15m
v1.rbac.authorization.k8s.io           Local                        True        15m
v1.scheduling.k8s.io                   Local                        True        15m
v1.storage.k8s.io                      Local                        True        15m
v1beta1.metrics.k8s.io                 kube-system/metrics-server   True        12m
v1beta3.flowcontrol.apiserver.k8s.io   Local                        True        15m
v2.autoscaling                         Local                        True        15m
v2.cilium.io                           Local                        True        14m
v2alpha1.cilium.io                     Local                        True        14m
```


## 前提条件

Ubunt Linux 18.04で、KVM, QEMU, Virsh/Virt がセットアップされた環境があること。

