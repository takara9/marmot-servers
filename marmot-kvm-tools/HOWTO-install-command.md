# ハイパーバイザー管理のセットアップ方法


## 前提となるデータベース etcd のインストール

~~~
# apt install etcd
~~~

## marmotコマンドのインストール

~~~
# ./install.sh
~~~


## Rubyのモジュールをインストール

~~~
# bundler
~~~


## 定義ファイルの作成

~~~
# cat hypevisors-4.yaml
hypervisor_specs:
  - nodename: "hv2"  
    cpu: 16
    memory:  65536
    ip-addr: 10.1.0.12/8    
~~~


## 定義ファイルの読み込み

~~~
# ./hv-init -f hypevisors-4.yaml 
HVノードのリスト削除
VMノードのリスト削除
VM管理データ初期化
HVデータの読み取りとetcdへの書込み
~~~


## 動作チェック

~~~
# hv-status

=== ハイパーバイザーの資源残存量 ===
HVノード名               IPアドレス                vCPU数       RAM(MB)   
hv2                   10.1.0.12/8                   16/16       65536/65536

=== 仮想サーバーのリスト ===
VM-Name           HV-Host       vCPU  RAM(MB)   DISK{GB}    Pub-IP            Pri-IP
~~~




