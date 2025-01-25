# vault configuration file

listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/etc/neco/server.crt"
  tls_key_file = "/etc/neco/server.key"
  telemetry {
    unauthenticated_metrics_access = true
  }
}

telemetry {
  # Vault retains Prometheus-compatible metrics only for the following periods if the metrics do not change.
  # Some metrics do not change for several tens of minutes or more and such metrics disappear after the period.
  # We set VERY long period (about three years, enough longer than boot server OS upgrade interval) to keep the metrics.
  prometheus_retention_time = "1000d"
  disable_hostname = true
}

api_addr = "https://10.69.1.131:8200"
cluster_addr = "https://10.69.1.131:8201"

storage "etcd" {
  address = "https://10.69.0.3:2379,https://10.69.0.195:2379,https://10.69.1.131:2379"
  etcd_api = "v3"
  ha_enabled = "true"
  tls_cert_file = "/etc/vault/etcd.crt"
  tls_key_file = "/etc/vault/etcd.key"
}
