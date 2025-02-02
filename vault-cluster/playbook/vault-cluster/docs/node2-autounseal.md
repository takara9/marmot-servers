# 常設のAuto unseal サーバーのセットアップ

## mkdir 

mkdir vault0 && cd vault0
mkdir vault-data


## config.hclの作成

```
tee config.hcl <<EOF
storage "file" {
   path    = "./vault-data"
}

listener "tcp" {
  address               = "0.0.0.0:8000"
  cluster_address       = "0.0.0.0:8001"
  tls_client_ca_file    = "/etc/vault/ca.pem"
  tls_cert_file         = "/etc/vault/vault-node1.pem"
  tls_key_file          = "/etc/vault/vault-node1-key.pem"
}

ui = true
disable_mlock = true
cluster_name  = "vault-cluster"
EOF
```

```
vault server -config config.hcl
```

ターミナルを開く

```
export VAULT_SKIP_VERIFY=1
export VAULT_CA_CERT=/etc/vault/ca.pem
export VAULT_CLIENT_CERT=/etc/vault/vault-node1.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-node1-key.pem
export VAULT_ADDR=https://127.0.0.1:8000
vault status
```

```
vault operator init -format=json -key-shares 1 -key-threshold 1
```


vault operator unseal <UNSEAL KEY> 
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

vault token create -orphan -policy="autounseal" \
   -wrap-ttl=120 -period=24h \
   -field=wrapping_token > wrapping-token.txt

vault unwrap -field=token $(cat wrapping-token.txt)
rm wrapping-token.txt



## NODE-1 サーバーの起動
sudo -s
export VAULT_TOKEN=hvs.CAESIK2jL-0LtUIbYAp0dtUVwQFAsMh31WbcV6TyAz81L7iKGh4KHGh2cy5rTFp4Z0g4MDVQcmxMTFlqenlrTWtPZ0g
vault server -config=/etc/vault/config.hcl 

## NODE-1 クライアント

export VAULT_SKIP_VERIFY=1
export VAULT_CA_CERT=/etc/vault/ca.pem
export VAULT_CLIENT_CERT=/etc/vault/vault-node1.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-node1-key.pem
export VAULT_ADDR=https://172.16.31.11:8200
ubuntu@node1:~$ vault status
Key                      Value
---                      -----
Seal Type                transit
Recovery Seal Type       n/a
Initialized              false
Sealed                   true
Total Recovery Shares    0
Threshold                0
Unseal Progress          0/0
Unseal Nonce             n/a
Version                  1.18.3
Build Date               2024-12-16T14:00:53Z
Storage Type             raft
HA Enabled               true
ubuntu@node1:~$ vault operator init
Recovery Key 1: vzdo7uWa/q2W2K6HZkN+LdzTWs05kRZn3QkjDImK8J6S
Recovery Key 2: 4hQTImabMwOL1+/JeysACP2UY4xqIZ6JX3F3Bghnm4cU
Recovery Key 3: 5TK3LrcsGtmPuXKzAyozwE6TmsCU7DaQ5SroasiSfdWn
Recovery Key 4: VJcHeofUZyftzdtFzkyLLRroVq59pA5zK/Y69ePSKBsb
Recovery Key 5: DMvsZvtxS3OCTCSz5uGZhD4xk7JniApfUP2x6C6Xwt5R

Initial Root Token: hvs.1x3NPGQV8BkfgIzkcCKVsvDG

Success! Vault is initialized

Recovery key initialized with 5 key shares and a key threshold of 3. Please
securely distribute the key shares printed above.




ubuntu@node1:~$ vault login
Token (will be hidden): 
Success! You are now authenticated. The token information displayed below
is already stored in the token helper. You do NOT need to run "vault login"
again. Future Vault requests will automatically use this token.

Key                  Value
---                  -----
token                hvs.1x3NPGQV8BkfgIzkcCKVsvDG
token_accessor       ImiNDvvBstqdIf6LAqqLRKIz
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]

ubuntu@node1:~$ vault operator raft list-peers
Node     Address              State     Voter
----     -------              -----     -----
node1    172.16.31.11:8201    leader    true



## NODE-2

sudo -s
export VAULT_SKIP_VERIFY=1
export VAULT_CA_CERT=/etc/vault/ca.pem
export VAULT_CLIENT_CERT=/etc/vault/vault-node1.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-node1-key.pem
export VAULT_ADDR=https://172.16.31.12:8200
export VAULT_TOKEN=hvs.CAESIOeBqnTUoYWWYM8nfFMBluXR6hx9m7qj0GiS58lrBWq2Gh4KHGh2cy5lRWtkSVdSSzI2TW5pTGx1MkZTSWFySWY
vault server -config=/etc/vault/config.hcl 

vault login <node1 root token>
vault operator members
Host Name    API Address                  Cluster Address              Active Node    Version    Upgrade Version    Redundancy Zone    Last Echo
---------    -----------                  ---------------              -----------    -------    ---------------    ---------------    ---------
node1        https://172.16.31.11:8200    https://172.16.31.11:8201    true           1.18.3     1.18.3             n/a                n/a
node2        https://172.16.31.12:8200    https://172.16.31.12:8201    false          1.18.3     1.18.3             n/a                2025-02-02T12:40:43Z



## NODE-3
sudo -s
export VAULT_SKIP_VERIFY=1
export VAULT_CA_CERT=/etc/vault/ca.pem
export VAULT_CLIENT_CERT=/etc/vault/vault-node1.pem
export VAULT_CLIENT_KEY=/etc/vault/vault-node1-key.pem
export VAULT_ADDR=https://172.16.31.13:8200
export VAULT_TOKEN=hvs.CAESIOeBqnTUoYWWYM8nfFMBluXR6hx9m7qj0GiS58lrBWq2Gh4KHGh2cy5lRWtkSVdSSzI2TW5pTGx1MkZTSWFySWY
vault server -config=/etc/vault/config.hcl 

vault login <node1 root token>


ubuntu@node3:~$ vault operator members
Host Name    API Address                  Cluster Address              Active Node    Version    Upgrade Version    Redundancy Zone    Last Echo
---------    -----------                  ---------------              -----------    -------    ---------------    ---------------    ---------
node1        https://172.16.31.11:8200    https://172.16.31.11:8201    true           1.18.3     1.18.3             n/a                n/a
node2        https://172.16.31.12:8200    https://172.16.31.12:8201    false          1.18.3     1.18.3             n/a                2025-02-02T12:46:13Z
node3        https://172.16.31.13:8200    https://172.16.31.13:8201    false          1.18.3     1.18.3             n/a                2025-02-02T12:46:16Z

