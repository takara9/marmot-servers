# URLとアクセス方法



## Kubernetes UI  ダッシュボードのURL

Kubernetesクラスタの状態をFirefoxなどブラウザから参照できる便利なツール

URL: https://dashboard.k8s1.labo.local/

トークンを選択して、次のコマンドを実行する。取得した文字列をコピーして、入力フィールドにペーストして、「サインイン」をクリックする。

~~~
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard \
get secret |grep kubernetes-dashboard-token-* | awk '{print $1}') |awk '$1=="token:"{print $2}'
~~~




## イングレスコントローラー

イングレスコンローラーとロードバランサーで、外部からのトラフィックをサービスのクラスタIP
アドレスへ導くことができる。このコントローラーには、NGINX Ingress controllerを使用している。

URL:
* http://ingress.k8s1.labo.local
* https://ingress.k8s1.labo.local

イングレスが設定されてない場合は、404 Not Foundが応答される。
自己署名証明書を使っているので、curl -k https://ingre.... として -k を設定する必要がある。





## Istio イングレスゲートウェイ

Isitoのイングレスゲートウェイは、前述のイングレスコントローラーと同様に、外部からのトラフィックを
サービスのクラスタIPへ導くことができる。設定は、Istioのドキュメントに従って設定が必要となる。

URL:
* http://istio-ingressgateway.istio-system.k8s3.labo.local/

設定が無い状態で、アクセスすると以下のメッセージの様に、Envoyプロキシーから応答が返される。

~~~
$ curl -i http://istio-ingressgateway.istio-system.k8s3.labo.local/
HTTP/1.1 404 Not Found
date: Mon, 18 Jan 2021 12:25:17 GMT
server: istio-envoy
content-length: 0
~~~




## メトリックス監視 Grafana

ノードポートで開いているので、パブリックネットワークにIPアドレスを指定すれば良い。

IPアドレスの求め方は、kubectl get node -o wide で表示されるノードのEXTERNAL-IPに
設定していないので、hv-statusコマンドのPub-IPが表示されるK8sクラスタのノードを指定する。

ポート番号の求め方は、kubectl get svc -n prometheus grafana を実行する

URL:
* http://10.0.0.141:30000/

上記のアドレスにアクセスすると、ログイン画面が現れるので、
ユーザーIDは admin として、パスワードは以下のコマンドの結果をコピペしてログインする。

~~~
kubectl get secret --namespace prometheus grafana -o jsonpath="{.data.admin-password}" \
| base64 --decode ; echo
~~~

初めてログインした直後は、Grafanaのデータソースが設定されていない。そのため、以下を実施する。

1 データソースに Prometheus を選択
2 HTTP URL に　http://prometheus-server をセットする
3 Save & Test をクリック


既成のダッシュボードをインポートする。

* 11074 1 Node Exporter for Prometheus Dashboard English Version UPDATE 1102
* 10000 Cluster Monitoring for Kubernetes
* 8685 K8s Cluster Summary
* 1860 Node Exporter Full
* 7249 Kubernetes Cluster





## ログ分析 Kibana

Kibanaのサービスをポート番号指定のNodePortとして公開しているので、マスターノードのパブリックIP指定でアクセスできる。

URL: http://10.0.0.141:31601/

ElasticsearchとKibanaと合わせて、ログシッパーとしてFileBeatをインストールをインストールしています。

トップメニューから Kibana -> Discover -> Add your data で データソースとしてFilebeat を選択することで
Filebeatから送られるデータを表示できる。


## Istio - Kiali マップ


## Rook Ceph

URL: http://10.0.0.141:30002/

kubectl -n rook-ceph get secret rook-ceph-dashboard-password \
-o jsonpath="{['data']['password']}" | base64 --decode && echo
'cL<f,|ZB}j;Rh?39+H6



## Jenkins

独立の仮想サーバーx3 で動作するJenkinsのクラスタ

URL: http://jenkins.labo.local/

Ansibleの結果またはログインして以下を実行して、パスワードを取得する

~~~
# cat /var/lib/jenkins/secrets/initialAdminPassword
b7ef9828e7a74fd69a7b62afd2c06f4a
~~~


## Harbor

https://harbor.labo.local/

ユーザーID: admin
パスワード: Harbor12345




## GitLab

https://gitlab.labo.local/

初期ユーザーはroot
パスワードは、gitlabのサーバーにログインして以下のコマンドで取得する
sudo docker exec -it gitlab_web_1 cat /etc/gitlab/initial_root_password

