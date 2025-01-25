


データのセット

```
$ etcdctl --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/etcd-node1.pem --key=/etc/etcd/etcd-node1-key.pem put greeting "Hello, etcd"
```


データの取り出し

```
$ etcdctl --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/etcd-node1.pem --key=/etc/etcd/etcd-node1-key.pem get greeting
greeting
Hello, etcd
```



```
export ETCDCTL_API=3
NODE1=172.16.31.11
NODE2=172.16.31.12
NODE3=172.16.31.13
ENDPOINTS=$NODE1:2379,$NODE2:2379,$NODE3:2379

ubuntu@node1:~$ etcdctl --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/etcd-node1.pem --key=/etc/etcd/etcd-node1-key.pem --endpoints=$ENDPOINTS --write-out=table  member list
+------------------+---------+-------+---------------------------+----------------------+------------+
|        ID        | STATUS  | NAME  |        PEER ADDRS         |     CLIENT ADDRS     | IS LEARNER |
+------------------+---------+-------+---------------------------+----------------------+------------+
| 330faa2f596183f6 | started | node2 | https://172.16.31.12:2380 | https://0.0.0.0:2379 |      false |
| 7131c0dc0e5e859d | started | node1 | https://172.16.31.11:2380 | https://0.0.0.0:2379 |      false |
| 95aad10603de694e | started | node3 | https://172.16.31.13:2380 | https://0.0.0.0:2379 |      false |
+------------------+---------+-------+---------------------------+----------------------+------------+

ubuntu@node1:~$ etcdctl --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/etcd-node1.pem --key=/etc/etcd/etcd-node1-key.pem --endpoints=$ENDPOINTS --write-out=table endpoint status
+-------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
|     ENDPOINT      |        ID        | VERSION | DB SIZE | IS LEADER | IS LEARNER | RAFT TERM | RAFT INDEX | RAFT APPLIED INDEX | ERRORS |
+-------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+
| 172.16.31.11:2379 | 7131c0dc0e5e859d |  3.5.18 |   20 kB |     false |      false |         2 |          8 |                  8 |        |
| 172.16.31.12:2379 | 330faa2f596183f6 |  3.5.18 |   20 kB |      true |      false |         2 |          8 |                  8 |        |
| 172.16.31.13:2379 | 95aad10603de694e |  3.5.18 |   20 kB |     false |      false |         2 |          8 |                  8 |        |
+-------------------+------------------+---------+---------+-----------+------------+-----------+------------+--------------------+--------+

ubuntu@node1:~$ etcdctl --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/etcd-node1.pem --key=/etc/etcd/etcd-node1-key.pem --endpoints=$ENDPOINTS --write-out=table endpoint health
+-------------------+--------+-------------+-------+
|     ENDPOINT      | HEALTH |    TOOK     | ERROR |
+-------------------+--------+-------------+-------+
| 172.16.31.11:2379 |   true |  9.613101ms |       |
| 172.16.31.12:2379 |   true | 10.088187ms |       |
| 172.16.31.13:2379 |   true | 17.476718ms |       |
+-------------------+--------+-------------+-------+
```


```
ubuntu@node1:~$ etcdctl --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/etcd-node1.pem --key=/etc/etcd/etcd-node1-key.pem --endpoints=$ENDPOINTS put key1 "Hello, etcd"
OK
ubuntu@node1:~$ etcdctl --cacert=/etc/etcd/ca.pem --cert=/etc/etcd/etcd-node1.pem --key=/etc/etcd/etcd-node1-key.pem --endpoints=$ENDPOINTS get key1
key1
Hello, etcd
```

