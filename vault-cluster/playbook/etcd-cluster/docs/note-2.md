

## クラスタアクセスの時の環境変数

```
export ETCDCTL_API=3
export ETCDCTL_CACERT='/etc/etcd/ca.pem'
export ETCDCTL_CERT='/etc/etcd/etcd-node1.pem'
export ETCDCTL_KEY='/etc/etcd/etcd-node1-key.pem'
export ETCDCTL_ENDPOINTS='172.16.31.11:2379,172.16.31.12:2379,172.16.31.13:2379'
```

## クラスタ状態の表示

```
$ etcdctl --write-out=table member list
+------------------+---------+-------+---------------------------+----------------------+------------+
|        ID        | STATUS  | NAME  |        PEER ADDRS         |     CLIENT ADDRS     | IS LEARNER |
+------------------+---------+-------+---------------------------+----------------------+------------+
| 330faa2f596183f6 | started | node2 | https://172.16.31.12:2380 | https://0.0.0.0:2379 |      false |
| 7131c0dc0e5e859d | started | node1 | https://172.16.31.11:2380 | https://0.0.0.0:2379 |      false |
| 95aad10603de694e | started | node3 | https://172.16.31.13:2380 | https://0.0.0.0:2379 |      false |
+------------------+---------+-------+---------------------------+----------------------+------------+

$ etcdctl --write-out=table endpoint status
+-------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|     ENDPOINT      |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+-------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| 172.16.31.11:2379 | 7131c0dc0e5e859d |  3.5.18 |   25 kB |     false |      false |         9 |         43 |                 43 |        |
| 172.16.31.12:2379 | 330faa2f596183f6 |  3.5.18 |   20 kB |      true |      false |         9 |         43 |                 43 |        |
| 172.16.31.13:2379 | 95aad10603de694e |  3.5.18 |   20 kB |     false |      false |         9 |         43 |                 43 |        |
+-------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+

ubuntu@hmc:~$ etcdctl --write-out=table endpoint health
+-------------------+--------+-------------+-------+
|     ENDPOINT      | HEALTH |    TOOK     | ERROR |
+-------------------+--------+-------------+-------+
| 172.16.31.12:2379 |   true | 16.038336ms |       |
| 172.16.31.13:2379 |   true | 24.043567ms |       |
| 172.16.31.11:2379 |   true | 23.046968ms |       |
+-------------------+--------+-------------+-------+
```


## 書き込み
```
$ etcdctl put foo "Hello World!"
OK
```

## 読み取り
```
$ etcdctl get foo
foo
Hello World!
```

## プレフィックスで取得

準備の書き込み
```
etcdctl put ocha1 "お～い お茶"
etcdctl put ocha2 "爽健美茶"
etcdctl put ocha3 "綾鷹"
```
キーの先頭文字が一致するものをリスト
```
etcdctl get ocha --prefix 
ocha1
お～い お茶
ocha2
爽健美茶
ocha3
綾鷹
```

## キー削除

```
$ etcdctl del ocha3
1
$ etcdctl get ocha --prefix
ocha1
お～い お茶
ocha2
爽健美茶
```


## hmc に　etcdctl と　etcdutl のバイナリと証明書などをインストール

```
$ etcdctl get ocha --prefix
ocha1
お～い お茶
ocha2
爽健美茶
```

## トランザクション


```
$ etcdctl put /users/12345/email "old.address@johndoe.com"
OK
$ etcdctl put /users/12345/phone "123-456-7890"
OK
```


```
$ etcdctl txn --interactive
compares:
value("/users/12345/email") = "old.address@johndoe.com"

success requests (get, put, del):
put /users/12345/email "new.address@johndoe.com"
put /users/12345/phone "098-765-4321"

failure requests (get, put, del):
get /users/12345/email

SUCCESS

OK

OK
```

```
$ etcdctl get /users/12345/email
/users/12345/email
new.address@johndoe.com
$ etcdctl get /users/12345/phone
/users/12345/phone
098-765-4321
```

## キーの監視

監視側
```
$ etcdctl watch stock1
PUT
stock1
1000
PUT
stock1
1011
```

更新側
```
$ etcdctl put stock1 1000
OK
$ etcdctl get stock1 1000
$ etcdctl update stock1 1001
Error: unknown command "update" for "etcdctl"
Run 'etcdctl --help' for usage.
$ etcdctl put stock1 1011
OK
```


## 指定時間で消える

```
$ etcdctl lease grant 120
lease 059d949cf217db0c granted with TTL(120s)
$ etcdctl put sample value --lease=059d949cf217db0c
OK
$ date
2025年  1月 25日 土曜日 20:26:32 JST
$ etcdctl get sample
sample
value
$ date
2025年  1月 25日 土曜日 20:27:09 JST
$ etcdctl get sample
sample
value
$ date
2025年  1月 25日 土曜日 20:28:34 JST
$ etcdctl get sample

$
```

## ロック


```
etcdctl lock mutex1
```