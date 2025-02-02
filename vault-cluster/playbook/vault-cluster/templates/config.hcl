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
