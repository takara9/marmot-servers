# Vault & Etcd cluster サーバー

Linuxサーバーx3と、その上で稼働する etcdクラスタ、vaultクラスタを構築します。


稼働したEtcd, Vaultをアクセスするための環境変数

```
# for etcd cluster
export ETCDCTL_API=3
export ETCDCTL_CACERT='/etc/etcd/ca.pem'
export ETCDCTL_CERT='/etc/etcd/etcd-node1.pem'
export ETCDCTL_KEY='/etc/etcd/etcd-node1-key.pem'
export ETCDCTL_ENDPOINTS='172.16.31.11:2379,172.16.31.12:2379,172.16.31.13:2379'

# for vault cluster
export VAULT_SKIP_VERIFY=1
export VAULT_CA_CERT=/etc/vault/ca.pem
export VAULT_CLIENT_CERT=/etc/vault/vault-node1.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-node1-key.pem
export VAULT_ADDR=https://172.16.31.11:8200
#export VAULT_ADDR=https://127.0.0.1:8200
```