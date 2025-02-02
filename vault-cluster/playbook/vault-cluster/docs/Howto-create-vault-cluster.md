# 常設のAuto unseal サーバーのセットアップ

vaultを起動した時に、このサーバーにアクセスすることで、人がキーをインプットすることなく、封印を解除します。

## ディレクトリの作成

データ保存用ディレクトを作成します。
```
sudo mkdir /var/vault-data
sudo mkdir /etc/vault
```

## /etc/vault/config.hclの作成

vaultサーバーの起動時に読み取る設定ファイルで、/etc/vaultの下におきます。そして、認証局の証明書、サーバー証明書、鍵なども一緒に置くと便利です。
```
tee config.hcl <<EOF
storage "file" {
   path    = "./vault-data"
}

listener "tcp" {
  address               = "0.0.0.0:8200"
  cluster_address       = "0.0.0.0:8201"
  tls_client_ca_file    = "/etc/vault/ca.pem"
  tls_cert_file         = "/etc/vault/vault-node1.pem"
  tls_key_file          = "/etc/vault/vault-node1-key.pem"
}

ui = true
disable_mlock = true
cluster_name  = "vault-cluster"
EOF
```


## Vaultの起動

systemd から起動すためのファイルを作成します。
```
# /lib/systemd/system/vault.service
[Unit]
Description=vault - Manage Secrets & Protect Sensitive Data
Documentation=https://developer.hashicorp.com/vault
After=network.target
Wants=network-online.target

[Service]
#Environment=VAULT_NAME=%H
Type=notify
User=root
PermissionsStartOnly=true
ExecStart=/usr/local/bin/vault server -config /etc/vault/config.hcl
Restart=on-abnormal
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

systemdから起動できる事を確認しておきます。
```
systemctl start vault
```

起動できない時は、以下のコマンドで手動で起動して、エラーの内容を確認できます。
```
vault server -config config.hcl
```


## クライアントからの初期設定

ターミナルを開いて、TLSで接続するための環境変数をセットします。
```
export VAULT_SKIP_VERIFY=1
export VAULT_CA_CERT=/etc/vault/ca.pem
export VAULT_CLIENT_CERT=/etc/vault/vault-node1.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-node1-key.pem
export VAULT_ADDR=https://127.0.0.1:8200
```

起動されたVaultサーバーとの接続を確認します。
```
vault status
```

Vaultサーバーを初期化します。実行結果、封印解除のキー、root トークンなどは、大切に保管しておきます。
```
vault operator init -format=json -key-shares 1 -key-threshold 1
```

サーバーの再起動で、Vaultは封印された状態で起動します。
その封印を解除するために、封印解除のキーが必要です。

以下のコマンドで、封印を解除します。
```
vault operator unseal <UNSEAL KEY> 
```

## Auto unseal サーバーとしての設定

rootでログインして、封印解除の設定をします。
```
vault login <ROOT TOKEN>
vault secrets enable transit
vault write -f transit/keys/autounseal
vault policy write autounseal -<<EOF
path "transit/encrypt/autounseal" {
   capabilities = [ "update" ]
}

path "transit/decrypt/autounseal" {
   capabilities = [ "update" ]
}
EOF
```

自動封印解除対象のサーバーのための、トークンを生成します。
作成したトークンは、Vaultサーバーの起動に必要ですので、大切に保存します。
```
vault token create -orphan -policy="autounseal" \
   -wrap-ttl=120 -period=24h \
   -field=wrapping_token > wrapping-token.txt
vault unwrap -field=token $(cat wrapping-token.txt)
rm wrapping-token.txt
```


## 自動封印解除を使用するサーバーの設定
systemd から起動するためのファイルを /lib/systemd/systemの下に配置します。
ポイントは、`Environment=VAULT_TOKEN=hvs.CAESIB*****`から始まる行で、前述で取得したトークンをセットします。

```
# /lib/systemd/system/vault.service
[Unit]
Description=vault - Manage Secrets & Protect Sensitive Data
Documentation=https://developer.hashicorp.com/vault
After=network.target
Wants=network-online.target

[Service]
Environment=VAULT_TOKEN=hvs.CAESIB******************************************
Type=notify
User=root
PermissionsStartOnly=true
ExecStart=/usr/local/bin/vault server -config /etc/vault/config.hcl
Restart=on-abnormal
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
```

##　クラスタに参加するVaultサーバーのconfig.hcl
`{{ ansible_facts.all_ipv4_addresses[0] }}`は、サーバーのIPアドレスに置き換えます。
`{{ ansible_facts.hostname }}`は、サーバーのホスト名に置き換えます。

```
api_addr      = "https://{{ ansible_facts.all_ipv4_addresses[0] }}:8200"
cluster_addr  = "https://{{ ansible_facts.all_ipv4_addresses[0] }}:8201"
cluster_name  = "vault-cluster"
disable_mlock = true
ui            = true

storage "raft" {
   path       = "/var/vault-data"
   node_id    = "{{ ansible_facts.hostname }}"
   retry_join {
      leader_tls_servername   = "vault-cluster"
      leader_api_addr         = "https://172.16.31.11:8200"
      leader_ca_cert_file     = "/etc/vault/ca.pem"
      leader_client_cert_file = "/etc/vault/vault-node1.pem"
      leader_client_key_file  = "/etc/vault/vault-node1-key.pem"
   }
   retry_join {
      leader_tls_servername   = "vault-cluster"
      leader_api_addr         = "https://172.16.31.12:8200"
      leader_ca_cert_file     = "/etc/vault/ca.pem"
      leader_client_cert_file = "/etc/vault/vault-node1.pem"
      leader_client_key_file  = "/etc/vault/vault-node1-key.pem"
   }
   retry_join {
      leader_tls_servername   = "vault-cluster"
      leader_api_addr         = "https://172.16.31.13:8200"
      leader_ca_cert_file     = "/etc/vault/ca.pem"
      leader_client_cert_file = "/etc/vault/vault-node1.pem"
      leader_client_key_file  = "/etc/vault/vault-node1-key.pem"
   }
}

listener "tcp" {
  address               = "0.0.0.0:8200"
  cluster_address       = "0.0.0.0:8201"
  tls_client_ca_file    = "/etc/vault/ca.pem"
  tls_cert_file         = "/etc/vault/vault-node1.pem"
  tls_key_file          = "/etc/vault/vault-node1-key.pem"
}

seal "transit" {
  address             = "https://172.16.0.9:8200"
  disable_renewal     = "false"
  key_name            = "autounseal"
  mount_path          = "transit/"
  tls_cert_file       = "/etc/vault/vault-node1.pem"
  tls_key_file        = "/etc/vault/vault-node1-key.pem"
  tls_client_ca_file  = "/etc/vault/ca.pem"
  tls_skip_verify    = "true"
}
```


## 自動封印解除を使用するサーバーの起動

Vaultサーバーの初回起動では、前述のトークンを VAULT_TOKENにセットして、サーバーを起動します。
```
sudo -s
export VAULT_TOKEN=<hvs.CAESIKから始まるトークン>
vault server -config=/etc/vault/config.hcl 
```

systemctl start vault を使用して、起動できる様に設定すると便利です。



## Vault の初期設定

TLS暗号化接続の設定
```
export VAULT_SKIP_VERIFY=1
export VAULT_CA_CERT=/etc/vault/ca.pem
export VAULT_CLIENT_CERT=/etc/vault/vault-node1.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-node1-key.pem
export VAULT_ADDR=https://172.16.31.11:8200
```

接続の確認
```
vault status
Key                      Value
---                      -----
Seal Type                transit
Recovery Seal Type       n/a
Initialized              false
Sealed                   true
<以下省略>
```

サーバーの初期化
```
vault operator init
```

初期の結果表示されたキーを保存しておきます。
```
Recovery Key 1: vzdo7uWa/q2W2K6HZkN+LdzTWs05kRZn3QkjDImK8J6S
Recovery Key 2: 4hQTImabMwOL1+/JeysACP2UY4xqIZ6JX3F3Bghnm4cU
Recovery Key 3: 5TK3LrcsGtmPuXKzAyozwE6TmsCU7DaQ5SroasiSfdWn
Recovery Key 4: VJcHeofUZyftzdtFzkyLLRroVq59pA5zK/Y69ePSKBsb
Recovery Key 5: DMvsZvtxS3OCTCSz5uGZhD4xk7JniApfUP2x6C6Xwt5R

Initial Root Token: hvs.1x3NPGQV8BkfgIzkcCKVsvDG

Success! Vault is initialized
```


## rootでログインして、クラスタ状態を確認します。
クラスタに参加するvaultサーバーには、前述の初期化で表示された`Initial Root Token:`でログインします。
```
vault login <hvs.から始まるトークン>
```

クラスタのメンバーをリストできます。
```
$ vault operator raft list-peers
Node     Address              State     Voter
----     -------              -----     -----
node1    172.16.31.11:8201    leader    true
```

サーバーが起動するごとに、参加するメンバーが増えていきます。
```
vault operator members
Host Name    API Address                  Cluster Address              Active Node    Version    Upgrade Version    Redundancy Zone    Last Echo
---------    -----------                  ---------------              -----------    -------    ---------------    ---------------    ---------
node1        https://172.16.31.11:8200    https://172.16.31.11:8201    true           1.18.3     1.18.3             n/a                n/a
node2        https://172.16.31.12:8200    https://172.16.31.12:8201    false          1.18.3     1.18.3             n/a                2025-02-02T12:46:13Z
node3        https://172.16.31.13:8200    https://172.16.31.13:8201    false          1.18.3     1.18.3             n/a                2025-02-02T12:46:16Z
```

