## Vaultサーバーの起動
```
sudo systemctl start vault
```

## クライアントの環境変数セットアップ
```
export VAULT_SKIP_VERIFY=1
export VAULT_CLIENT_CERT=/etc/vault/vault-cert.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-key.pem
export VAULT_ADDR=https://127.0.0.1:8200
```

## サーバーステータスの確認
```
vault status
```

```
Key                Value
---                -----
Seal Type          shamir
Initialized        false
Sealed             true
Total Shares       0
Threshold          0
Unseal Progress    0/0
Unseal Nonce       n/a
Version            1.18.3
Build Date         2024-12-16T14:00:53Z
Storage Type       raft
HA Enabled         true
```

## サーバーの初期化
初期化コマンドを実行する
```
vault operator init -format=json -key-shares 1 -key-threshold 1
```

応答には、封印解除(Unseal)のキー、rootユーザーのトークンが表示されるので、流出しない様に保管する。
```
{
  "unseal_keys_b64": [
    "uueT6wsvmtqDDkZCPpLS2d9UYEadduhKIbaYuakkSak="
  ],
  "unseal_keys_hex": [
    "bae793eb0b2f9ada830e46423e92d2d9df5460469d76e84a21b698b9a92449a9"
  ],
  "unseal_shares": 1,
  "unseal_threshold": 1,
  "recovery_keys_b64": [],
  "recovery_keys_hex": [],
  "recovery_keys_shares": 0,
  "recovery_keys_threshold": 0,
  "root_token": "hvs.ylxucg0WpIJj4r9vqFqwdsga"
}
```

## 封印を解除
封印を解除なければ、ログインなどの操作が出来ない。そのため、初期化時の "unseal_keys_b64" を使って解除する。
```
vault operator unseal ptgJ6oK6mIJIekCnVDdFlobM4JqRI0mux11tjRhpdjU=
```

## ルートでログイン
ユーザー登録、ポリシー設定、認証方法などの設定のため、rootでログインする。
```
vault login hvs.0G5YuZbmTNeg1VFziKYTNPSj
```

## パスワードによる認証を有効化
パスワード／パスフレーズによる認証(userpass)を有効化する
```
vault auth enable userpass
```



## ポリシーを作成

ポリシーの書き込み
```
vault policy write users - << EOF
path "user-secrets/data/creds" {
   capabilities = ["create", "list", "read", "update"]
}
EOF
```

応答
```
Success! Uploaded policy: users
```

ポリシーのリスト
```
vault policy list
```

応答
```
default
users
root
```

ポリシーの内容を確認
```
vault policy read users
```

応答
```
path "user-secrets/data/creds" {
   capabilities = ["create", "list", "read", "update"]
}
```

## ユーザーの登録

```
vault write /auth/userpass/users/user1 password='Lemon x1 Banana x2 Apple x1' policies=users
```

```
Success! Data written to: auth/userpass/users/user1
```

登録内容の確認
```
vault read /auth/userpass/users/user1
```

## シークレットエンジンの有効化

```
vault secrets enable -path=user-secrets -version=2 kv
```

```
Success! Enabled the kv secrets engine at: user-secrets/
```




## ユーザーでログイン

```
vault login -method=userpass username=user1
```
または、

```
vault login -method=userpass username=user1 password='Lemon x1 Banana x2 Apple x1'
```

結果（パスワードをセットした時は、パスワードのプロンプトは出ない）
```
Password (will be hidden): 
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                    Value
---                    -----
token                  hvs.CAESIHYBw8yJ37MwkPMKIS7ZQj7LIXgh8VwM5MPDEXU2Sv04Gh4KHGh2cy40UnVXeUNsd3MyQmxHNUtOMnh3aGZOcU4
token_accessor         fAih8sA4nTFLaNRrX39NHkNX
token_duration         768h
token_renewable        true
token_policies         ["default" "user"]
identity_policies      []
policies               ["default" "user"]
token_meta_username    user1
```


## KVへ書き込み、読み取り


```
$ vault kv put /user-secrets/creds api-key='パスワードとかトークンなど秘密をセット'
```

```
===== Secret Path =====
user-secrets/data/creds

======= Metadata =======
Key                Value
---                -----
created_time       2025-02-01T08:33:21.160350834Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1
```


```
$ vault kv get /user-secrets/creds
===== Secret Path =====
user-secrets/data/creds

======= Metadata =======
Key                Value
---                -----
created_time       2025-02-01T08:33:21.160350834Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            1

===== Data =====
Key        Value
---        -----
api-key    パスワードとかトークンなど秘密をセット
```

