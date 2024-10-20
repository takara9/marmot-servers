# ROOK-CEPH

このAnsibleプレイブックは、ROOK-CEPHをデプロイする。


Ceph ダッシュボードは、NodePortで開いているので、ELBのIPアドレス、または VIPでアクセスできる。

* https://k8s.labs.local:30002/
* https://<ELB VIP address>:30002/


ユーザーID: admin
パスワード: 以下の方法で表示できる。

~~~
kubectl -n rook-ceph get secret rook-ceph-dashboard-password \
-o jsonpath="{['data']['password']}" | base64 --decode && echo
~~~

