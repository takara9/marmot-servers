# Vault クラスタの構成

## 1. 起動と初期化

## Vaultサーバーをスタート
$ unset VAULT_TOKEN
$ export VAULT_API_ADDR=http://127.0.0.1:8200
$ vault server -log-level=trace -config config-vault_1.hcl 

## Vaultサーバーの初期化
$ export VAULT_ADDR=http://127.0.0.1:8200
$ vault operator init -format=json -key-shares 1 -key-threshold 1
{
  "unseal_keys_b64": [
    "su3xOYPYO3ZeDim80tyXGfGvk3bIDJhfpu1fcin9TfY="
  ],
  "unseal_keys_hex": [
    "b2edf13983d83b765e0e29bcd2dc9719f1af9376c80c985fa6ed5f7229fd4df6"
  ],
  "unseal_shares": 1,
  "unseal_threshold": 1,
  "recovery_keys_b64": [],
  "recovery_keys_hex": [],
  "recovery_keys_shares": 0,
  "recovery_keys_threshold": 0,
  "root_token": "hvs.Ngln2JIcOntcw3f2tkQwF68K"
}

export UNSEAL_KEY=su3xOYPYO3ZeDim80tyXGfGvk3bIDJhfpu1fcin9TfY=
export VAULT_TOKEN_1=hvs.Ngln2JIcOntcw3f2tkQwF68K
export VAULT_TOKEN=$VAULT_TOKEN_1


## 2. シール解除、ログイン
## シール解除
$ vault operator unseal ${UNSEAL_KEY}
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
Cluster Name    vault-cluster-b3ef9fb9
Cluster ID      60e484e9-a3bc-fcbf-371f-1181f3d49141
HA Enabled      false

## ログイン
$ vault login ${VAULT_TOKEN}
Key                  Value
---                  -----
token                hvs.Ngln2JIcOntcw3f2tkQwF68K
token_accessor       LAVRvA5Obux4a33tHEntMhji
token_duration       ∞
token_renewable      false
token_policies       ["root"]
identity_policies    []
policies             ["root"]


## 3  シークレット転送の有効化
##　　シークレット転送の有効化
$ vault secrets enable transit
Success! Enabled the transit secrets engine at: transit/

## キーの作成
$ vault write -f transit/keys/unseal_key
Key                       Value
---                       -----
allow_plaintext_backup    false
auto_rotate_period        0s
deletion_allowed          false
derived                   false
exportable                false
imported_key              false
keys                      map[1:1737889574]
latest_version            1
min_available_version     0
min_decryption_version    1
min_encryption_version    0
name                      unseal_key
supports_decryption       true
supports_derivation       true
supports_encryption       true
supports_signing          false
type                      aes256-gcm96



## Vault 2 を起動

vault 1 の rootトークンを VAULT_TOKEN にセットして、
vault 2 の APIアドレスを VAULT_API_ADDR にセットして、
vault2 を起動する。

```
export VAULT_TOKEN=$VAULT_TOKEN_1
export VAULT_API_ADDR=http://172.16.31.11:8200
vault server -log-level=trace -config /etc/vault/config.hcl 
```

export VAULT_ADDR=http://172.16.31.11:8200
vault operator init -format=json -recovery-shares 1 -recovery-threshold 1

RECOVERY_KEY2=$(echo "$INIT_RESPONSE2" | jq -r .recovery_keys_b64[0])
VAULT_TOKEN2=$(echo "$INIT_RESPONSE2" | jq -r .root_token)

vault_2 login "$VAULT_TOKEN2"
vault_2 secrets enable -path=kv kv-v2

vault_2 kv put kv/apikey webapp=ABB39KKPTWOR832JGNLS02
vault_2 kv get kv/apikey





## Vaultの繋ぎ方

vault status -client-cert=/etc/vault/vault-cert.pem -client-key=/etc/vault/vault-key.pem -tls-skip-verify
