ui = true
cluster_addr = "https://172.16.31.11:8201"
api_addr = "https://172.16.31.11:8200"
disable_mlock = true

storage "raft" {
  path = "/var/vault-data"
  node_id = "node1_raft_node_id"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault/vault-cert.pem"
  tls_key_file  = "/etc/vault/vault-key.pem"
}

#telemetry {
#  statsite_address = "127.0.0.1:8125"
#  disable_hostname = true
#}
