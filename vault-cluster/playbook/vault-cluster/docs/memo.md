cybozu@stage1-boot-2:/etc/neco$ ls -la
total 48
drwxr-xr-x   2 root root 4096 May 24  2023 .
drwxr-xr-x 105 root root 4096 Jan 24 03:51 ..
-rw-r--r--   1 root root   98 Nov  6  2023 bmc-address.json
-rw-r--r--   1 root root  491 Nov  6  2023 bmc-user.json
-rw-r--r--   1 root root    7 May 24  2023 cluster
-rw-r--r--   1 root root  262 Jan 23 05:22 config.yml
-rw-r--r--   1 root root 1146 May 24  2023 etcd.crt
-rw-r--r--   1 root root 1678 May 24  2023 etcd.key
-rw-r--r--   1 root root    2 May 24  2023 rack
-rw-r--r--   1 root root  311 May 24  2023 sabakan_ipam.json
-rw-r--r--   1 root root 1215 May 24  2023 server.crt
-rw-r--r--   1 root root 1678 May 24  2023 server.key
cybozu@stage1-boot-2:/etc/neco$ cat cluster 
stage1
cybozu@stage1-boot-2:/etc/neco$ cat config.yml 
endpoints:
- https://10.69.0.3:2379
- https://10.69.0.195:2379
- https://10.69.1.131:2379
password: ""
prefix: /neco/
timeout: 2s
tls-ca: ""
tls-ca-file: ""
tls-cert: ""
tls-cert-file: /etc/neco/etcd.crt
tls-key: ""
tls-key-file: /etc/neco/etcd.key
username: ""
cybozu@stage1-boot-2:/etc/neco$ cat rack 
2
