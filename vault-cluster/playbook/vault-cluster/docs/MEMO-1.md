
https://developer.hashicorp.com/vault/tutorials/get-started/learn-http-api


vault server -dev -dev-root-token-id root -dev-tls

ubuntu@node1:~$ export VAULT_ADDR='https://127.0.0.1:8200'
ubuntu@node1:~$ export VAULT_CACERT='/tmp/vault-tls2028219547/vault-ca.pem'
ubuntu@node1:~$ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.18.3
Build Date      2024-12-16T14:00:53Z
Storage Type    inmem
Cluster Name    vault-cluster-610d4181
Cluster ID      1e575ccb-0c5a-88cc-a029-76e2073cace5
HA Enabled      false


export VAULT_TOKEN=$(vault print token)


## 認証方法を有効にして設定

以下２つのコマンドは、同じ操作
```
vault auth enable userpass
curl -k -H "X-Vault-Token: $VAULT_TOKEN" -X POST -d '{"type": "userpass"}' $VAULT_ADDR/v1/sys/auth/userpass
```

有効な認証エンジンをリスト
```
curl -k -H "X-Vault-Token: $VAULT_TOKEN"  $VAULT_ADDR/v1/sys/auth  | jq ".data"
```

userpass にユーザーを作成する
ユーザー作成時にポリシーを与えることで権限設定をしている

```
curl -k -H "X-Vault-Token: $VAULT_TOKEN" -X POST \
-d '{"password":"Imprint Bacteria Marathon Aflutter","token_policies":"developer-vault-policy"}' \
$VAULT_ADDR/v1/auth/userpass/users/danielle-vault-user
```

ポリシーを作成する
この中で、出来ることを設定している

```
curl -k -H "X-Vault-Token: $VAULT_TOKEN" -X PUT \
-d '{"policy":"path \"dev-secrets/data/creds\" {\n  capabilities = [\"create\", \"update\"]\n}\n\npath \"dev-secrets/data/creds\" {\n  capabilities = [\"read\"]\n}\n"}' \
$VAULT_ADDR/v1/sys/policies/acl/developer-vault-policy
```

Vault ポリシーを一覧表示

```
ubuntu@node1:~$ curl -k -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/sys/policy | jq ".data.policies"
[
  "default",
  "developer-vault-policy",
  "root"
]
```

`vault`コマンドでポリシーを表示

```
ubuntu@node1:~$ vault policy read developer-vault-policy
path "dev-secrets/data/creds" {
  capabilities = ["create", "update"]
}

path "dev-secrets/data/creds" {
  capabilities = ["read"]
}
```


## シークレットエンジンを有効にして構成

どのシークレット エンジンがすでにマウントされているかを確認

```
ubuntu@node1:~$ curl -k -s -H "X-Vault-Token: $VAULT_TOKEN" $VAULT_ADDR/v1/sys/mounts | jq ".data"
{
  "cubbyhole/": {
    "accessor": "cubbyhole_77f3835f",
    "config": {
      "default_lease_ttl": 0,
      "force_no_cache": false,
      "max_lease_ttl": 0
    },
    "description": "per-token private secret storage",
    "external_entropy_access": false,
    "local": true,
    "options": null,
    "plugin_version": "",
    "running_plugin_version": "v1.18.3+builtin.vault",
    "running_sha256": "",
    "seal_wrap": false,
    "type": "cubbyhole",
    "uuid": "06c9af43-7a63-b625-93aa-8c3f8602dd6f"
  },
  "identity/": {
    "accessor": "identity_2ebca2ca",
    "config": {
      "default_lease_ttl": 0,
      "force_no_cache": false,
      "max_lease_ttl": 0,
      "passthrough_request_headers": [
        "Authorization"
      ]
    },
    "description": "identity store",
    "external_entropy_access": false,
    "local": false,
    "options": null,
    "plugin_version": "",
    "running_plugin_version": "v1.18.3+builtin.vault",
    "running_sha256": "",
    "seal_wrap": false,
    "type": "identity",
    "uuid": "e3c24271-50ed-2d39-afb4-ab7e7266ba4a"
  },
  "secret/": {
    "accessor": "kv_5dc3e761",
    "config": {
      "default_lease_ttl": 0,
      "force_no_cache": false,
      "max_lease_ttl": 0
    },
    "deprecation_status": "supported",
    "description": "key/value secret storage",
    "external_entropy_access": false,
    "local": false,
    "options": {
      "version": "2"
    },
    "plugin_version": "",
    "running_plugin_version": "v0.20.0+builtin",
    "running_sha256": "",
    "seal_wrap": false,
    "type": "kv",
    "uuid": "e1f29d34-3fbe-36b0-bd91-78f6f28c6243"
  },
  "sys/": {
    "accessor": "system_2d68fed5",
    "config": {
      "default_lease_ttl": 0,
      "force_no_cache": false,
      "max_lease_ttl": 0,
      "passthrough_request_headers": [
        "Accept"
      ]
    },
    "description": "system endpoints used for control, policy and debugging",
    "external_entropy_access": false,
    "local": false,
    "options": null,
    "plugin_version": "",
    "running_plugin_version": "v1.18.3+builtin.vault",
    "running_sha256": "",
    "seal_wrap": true,
    "type": "system",
    "uuid": "f6ef144c-2afc-3408-b711-41031dffc693"
  }
}
```

シークレット エンジン dev-secrets を作成します

```
$ curl -k -H "X-Vault-Token: $VAULT_TOKEN" -X POST -d '{ "type":"kv-v2" }' \
$VAULT_ADDR/v1/sys/mounts/dev-secrets
```

## 認証とシークレットの作成

danielle-vault-userのパスワードを送り、danielle-vault-userのトークンを取得

```
ubuntu@node1:~$ curl -k -s -X POST -d '{ "password": "Imprint Bacteria Marathon Aflutter" }' \
$VAULT_ADDR/v1/auth/userpass/login/danielle-vault-user | jq ".auth.client_token"
"hvs.*******************************************************************************************"
```


クライアント トークンをDANIELLE_DEV_TOKEN環境変数値としてエクスポートし、後続の Vault 要求の認証に使用
```
export DANIELLE_DEV_TOKEN="hvs.*******************************************************************************************"
```


credsキーpasswordとその値が に設定された名前のシークレットを作成
```
curl -k -s -H "X-Vault-Token: $DANIELLE_DEV_TOKEN" -X PUT -d '{ "data": {"password": "Driven Siberian Pantyhose Equinox"} }' $VAULT_ADDR/v1/dev-secrets/data/creds | jq ".data"
{
  "created_time": "2025-01-23T22:03:04.566783282Z",
  "custom_metadata": null,
  "deletion_time": "",
  "destroyed": false,
  "version": 3
}
```


dev-secrets/data/credsのシークレットを表示
```
curl -k -s -H "X-Vault-Token: $DANIELLE_DEV_TOKEN" \
$VAULT_ADDR/v1/dev-secrets/data/creds | jq ".data"
{
  "data": {
    "password": "Driven Siberian Pantyhose Equinox"
  },
  "metadata": {
    "created_time": "2025-01-23T22:03:04.566783282Z",
    "custom_metadata": null,
    "deletion_time": "",
    "destroyed": false,
    "version": 3
  }
}
```

