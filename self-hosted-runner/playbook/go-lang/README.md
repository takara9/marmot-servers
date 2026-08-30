# ビルド環境


bootnodeのRAM 8GB未満の場合、メモリ不足でコンパイルが失敗するので、
十分なメモリ利用を設定する。


## Kubernetesをソースコードからビルドする

仮想マシンにログイン（bootnode部分はIPアドレスに置き換え)して、
以下のコマンド実行して、Kubernetesのバイナリファイルをビルドする。

~~~
ssh -i id_rsa ubuntu@bootnode
export K8SVER=v1.18.14
curl -OL https://dl.k8s.io/${K8SVER}/kubernetes-src.tar.gz
export GOPATH=`pwd`/${K8SVER}
mkdir $GOPATH
tar -C $GOPATH -xzf kubernetes-src.tar.gz
cd $GOPATH
make
~~~

このバイナリの生成ファイルは、$GOPATH/_output/bin に集められる。
共有ディレクトリにコピーして、仮想マシンからログアウトする。

~~~
cd $GOPATH/_output/bin 
sudo cp * /srv/k8s/bin
exit
~~~



