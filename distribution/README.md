# CNCF Distribution registry 仮想サーバー

`https://distribution.github.io/distribution/` の仮想サーバーをセットアップします。
- URL: registry.labo.local:5000
- HTTPSは設定していません。
- データは、hv2 のオブジェクトストレージに保存されます。


## デプロイ

~~~
$ cd marmot-registry
$ mactl create
$ ansible -i inventory -m ping all 
$ ansible-playbook -i inventory playbook/install.yaml 
~~~

## 使用の準備

`/etc/docker/daemon.json` に、以下の内容のファイルを作成します。

```
{
  "insecure-registries" : ["registry.labo.local:5000"]
}
```

## テスト

```
$ docker pull alpine
$ docker tag apline registry.labo.local:5000/alpine 
$ docker push registry.labo.local:5000/alpine
$ docker rmi registry.labo.local:5000/alpine
$ docker pull egistry.labo.local:5000/alpine
```


## crane を利用したアクセステスト
https://github.com/google/go-containerregistry/tree/main/cmd/crane

```
$ crane catalog registry.labo.local:5000 --insecure
alpine
hello-world
ubuntu

$ crane catalog registry.labo.local:5000 --insecure --full-ref 
registry.labo.local:5000/alpine
registry.labo.local:5000/hello-world
registry.labo.local:5000/ubuntu

$ crane ls registry.labo.local:5000/alpine --insecure --full-ref 
registry.labo.local:5000/alpine:latest
```
