api_addr      = "https://{{ ansible_facts.all_ipv4_addresses[0] }}:8200"
cluster_addr  = "https://{{ ansible_facts.all_ipv4_addresses[0] }}:8201"
cluster_name  = "vault-cluster-1"
disable_mlock = true
ui            = true

storage "raft" {
   path       = "/var/vault-data"
   node_id    = "{{ ansible_facts.hostname }}"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault/vault-cert.pem"
  tls_key_file  = "/etc/vault/vault-key.pem"
}
