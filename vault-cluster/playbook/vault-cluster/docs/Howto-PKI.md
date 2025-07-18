
rootでログイン

```
$ vault login
```


PKIの有効化

```
$ vault secrets enable -path=pki_root pki
Success! Enabled the pki secrets engine at: pki_root/
```


TTLを１年に延長
```
$ vault secrets tune -max-lease-ttl=8760h pki_root
Success! Tuned the secrets engine at: pki_root/
```


ルートCA及びルート証明書を作成

```
ubuntu@hmc:~$ vault write pki_root/root/generate/internal \
    common_name="My Root CA" \
    ttl=8760h
WARNING! The following warnings were returned from Vault:

  * This mount hasn't configured any authority information access (AIA)
  fields; this may make it harder for systems to find missing certificates
  in the chain or to validate revocation status of certificates. Consider
  updating /config/urls or the newly generated issuer with this information.

Key              Value
---              -----
certificate      -----BEGIN CERTIFICATE-----
MIIDGzCCAgOgAwIBAgIUewEW8HEFGOkNE5xKsKxhKisAlaUwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKTXkgUm9vdCBDQTAeFw0yNTAyMDUxMTI5NTJaFw0yNjAy
MDUxMTMwMjFaMBUxEzARBgNVBAMTCk15IFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC943BuWn0SUOds/MX4WnIQXozpYy3W/hxnvx7JPyWZ
CeMfcXqu96iUoSXq8pKLsF4G8e84QhCl5pR4dp9wcGUupY6urfiAVI7t+RY0k7cP
UcLJPAWkRKjWbQdr/a4Yb711xwXNup47OR+TVatCU2Hknvm0PBmM3lB5FdVBvk8Q
kH3vvnPW9vlKiwes0pYiC8B1WvrBVUZPkHnOE0t2ZxFzBa9IufWwRUpOT+JKSpJs
VMrw2yV7KE+vEfCA1CjCVPrsb0G/UOuIzNeEc5WB07a9tCrb5/ScnR5QdbpeNh0T
pU4BPSZGqo2uApsRMadYP2d+jK8x0H0R1ZHizw6O2FPNAgMBAAGjYzBhMA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQGT1ok93lYzUxf
juP5HX0H8O6NkzAfBgNVHSMEGDAWgBQGT1ok93lYzUxfjuP5HX0H8O6NkzANBgkq
hkiG9w0BAQsFAAOCAQEAYXklYevHHSdrseWRw1oyZb08R743En6quNK+/B1kc2l8
VToJdQh043aeTpl0U4O0yhL+a/DHIlaQTF9PDxsJdsuTSKUKpa0FgUvzFddnxTtJ
HcSEUvtqTt/+S5t0VwHAD7EBApWnSgdQlRsNZ5pr5d3k362d3oBZDFRDnxMme1jN
SA4GsTd2oxH+z4iVAs/BWVgkxzcYlUnA1sy4i58B6uTFkw+tHGTPtuTYdtUqA4mO
JASKwhl8fH1JSbx0NNpFfIs5Ra43y1OWhi0Pva/tvOCG/t0SL6gQYFLKUhjcESIw
sOej9dCoqOgFndiHVVnIxXzwt1rsz7E5DdeFa/pYxA==
-----END CERTIFICATE-----
expiration       1770291021
issuer_id        ef8fe86d-c318-72de-cfa8-e5f03cbb5c8e
issuer_name      n/a
issuing_ca       -----BEGIN CERTIFICATE-----
MIIDGzCCAgOgAwIBAgIUewEW8HEFGOkNE5xKsKxhKisAlaUwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKTXkgUm9vdCBDQTAeFw0yNTAyMDUxMTI5NTJaFw0yNjAy
MDUxMTMwMjFaMBUxEzARBgNVBAMTCk15IFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC943BuWn0SUOds/MX4WnIQXozpYy3W/hxnvx7JPyWZ
CeMfcXqu96iUoSXq8pKLsF4G8e84QhCl5pR4dp9wcGUupY6urfiAVI7t+RY0k7cP
UcLJPAWkRKjWbQdr/a4Yb711xwXNup47OR+TVatCU2Hknvm0PBmM3lB5FdVBvk8Q
kH3vvnPW9vlKiwes0pYiC8B1WvrBVUZPkHnOE0t2ZxFzBa9IufWwRUpOT+JKSpJs
VMrw2yV7KE+vEfCA1CjCVPrsb0G/UOuIzNeEc5WB07a9tCrb5/ScnR5QdbpeNh0T
pU4BPSZGqo2uApsRMadYP2d+jK8x0H0R1ZHizw6O2FPNAgMBAAGjYzBhMA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQGT1ok93lYzUxf
juP5HX0H8O6NkzAfBgNVHSMEGDAWgBQGT1ok93lYzUxfjuP5HX0H8O6NkzANBgkq
hkiG9w0BAQsFAAOCAQEAYXklYevHHSdrseWRw1oyZb08R743En6quNK+/B1kc2l8
VToJdQh043aeTpl0U4O0yhL+a/DHIlaQTF9PDxsJdsuTSKUKpa0FgUvzFddnxTtJ
HcSEUvtqTt/+S5t0VwHAD7EBApWnSgdQlRsNZ5pr5d3k362d3oBZDFRDnxMme1jN
SA4GsTd2oxH+z4iVAs/BWVgkxzcYlUnA1sy4i58B6uTFkw+tHGTPtuTYdtUqA4mO
JASKwhl8fH1JSbx0NNpFfIs5Ra43y1OWhi0Pva/tvOCG/t0SL6gQYFLKUhjcESIw
sOej9dCoqOgFndiHVVnIxXzwt1rsz7E5DdeFa/pYxA==
-----END CERTIFICATE-----
key_id           a046412b-c88b-f85f-3988-0eb21bcdec5b
key_name         n/a
serial_number    7b:01:16:f0:71:05:18:e9:0d:13:9c:4a:b0:ac:61:2a:2b:00:95:a5
```


```
ubuntu@hmc:~$ vi root.crt
ubuntu@hmc:~$ openssl x509 -in root.crt -text -noout
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            7b:01:16:f0:71:05:18:e9:0d:13:9c:4a:b0:ac:61:2a:2b:00:95:a5
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: CN = My Root CA
        Validity
            Not Before: Feb  5 11:29:52 2025 GMT
            Not After : Feb  5 11:30:21 2026 GMT
        Subject: CN = My Root CA
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:bd:e3:70:6e:5a:7d:12:50:e7:6c:fc:c5:f8:5a:
                    72:10:5e:8c:e9:63:2d:d6:fe:1c:67:bf:1e:c9:3f:
                    25:99:09:e3:1f:71:7a:ae:f7:a8:94:a1:25:ea:f2:
                    92:8b:b0:5e:06:f1:ef:38:42:10:a5:e6:94:78:76:
                    9f:70:70:65:2e:a5:8e:ae:ad:f8:80:54:8e:ed:f9:
                    16:34:93:b7:0f:51:c2:c9:3c:05:a4:44:a8:d6:6d:
                    07:6b:fd:ae:18:6f:bd:75:c7:05:cd:ba:9e:3b:39:
                    1f:93:55:ab:42:53:61:e4:9e:f9:b4:3c:19:8c:de:
                    50:79:15:d5:41:be:4f:10:90:7d:ef:be:73:d6:f6:
                    f9:4a:8b:07:ac:d2:96:22:0b:c0:75:5a:fa:c1:55:
                    46:4f:90:79:ce:13:4b:76:67:11:73:05:af:48:b9:
                    f5:b0:45:4a:4e:4f:e2:4a:4a:92:6c:54:ca:f0:db:
                    25:7b:28:4f:af:11:f0:80:d4:28:c2:54:fa:ec:6f:
                    41:bf:50:eb:88:cc:d7:84:73:95:81:d3:b6:bd:b4:
                    2a:db:e7:f4:9c:9d:1e:50:75:ba:5e:36:1d:13:a5:
                    4e:01:3d:26:46:aa:8d:ae:02:9b:11:31:a7:58:3f:
                    67:7e:8c:af:31:d0:7d:11:d5:91:e2:cf:0e:8e:d8:
                    53:cd
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier: 
                06:4F:5A:24:F7:79:58:CD:4C:5F:8E:E3:F9:1D:7D:07:F0:EE:8D:93
            X509v3 Authority Key Identifier: 
                06:4F:5A:24:F7:79:58:CD:4C:5F:8E:E3:F9:1D:7D:07:F0:EE:8D:93
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        61:79:25:61:eb:c7:1d:27:6b:b1:e5:91:c3:5a:32:65:bd:3c:
        47:be:37:12:7e:aa:b8:d2:be:fc:1d:64:73:69:7c:55:3a:09:
        75:08:74:e3:76:9e:4e:99:74:53:83:b4:ca:12:fe:6b:f0:c7:
        22:56:90:4c:5f:4f:0f:1b:09:76:cb:93:48:a5:0a:a5:ad:05:
        81:4b:f3:15:d7:67:c5:3b:49:1d:c4:84:52:fb:6a:4e:df:fe:
        4b:9b:74:57:01:c0:0f:b1:01:02:95:a7:4a:07:50:95:1b:0d:
        67:9a:6b:e5:dd:e4:df:ad:9d:de:80:59:0c:54:43:9f:13:26:
        7b:58:cd:48:0e:06:b1:37:76:a3:11:fe:cf:88:95:02:cf:c1:
        59:58:24:c7:37:18:95:49:c0:d6:cc:b8:8b:9f:01:ea:e4:c5:
        93:0f:ad:1c:64:cf:b6:e4:d8:76:d5:2a:03:89:8e:24:04:8a:
        c2:19:7c:7c:7d:49:49:bc:74:34:da:45:7c:8b:39:45:ae:37:
        cb:53:96:86:2d:0f:bd:af:ed:bc:e0:86:fe:dd:12:2f:a8:10:
        60:52:ca:52:18:dc:11:22:30:b0:e7:a3:f5:d0:a8:a8:e8:05:
        9d:d8:87:55:59:c8:c5:7c:f0:b7:5a:ec:cf:b1:39:0d:d7:85:
        6b:fa:58:c4
```


```
ubuntu@hmc:~$ cat root.crt 
-----BEGIN CERTIFICATE-----
MIIDGzCCAgOgAwIBAgIUewEW8HEFGOkNE5xKsKxhKisAlaUwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKTXkgUm9vdCBDQTAeFw0yNTAyMDUxMTI5NTJaFw0yNjAy
MDUxMTMwMjFaMBUxEzARBgNVBAMTCk15IFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC943BuWn0SUOds/MX4WnIQXozpYy3W/hxnvx7JPyWZ
CeMfcXqu96iUoSXq8pKLsF4G8e84QhCl5pR4dp9wcGUupY6urfiAVI7t+RY0k7cP
UcLJPAWkRKjWbQdr/a4Yb711xwXNup47OR+TVatCU2Hknvm0PBmM3lB5FdVBvk8Q
kH3vvnPW9vlKiwes0pYiC8B1WvrBVUZPkHnOE0t2ZxFzBa9IufWwRUpOT+JKSpJs
VMrw2yV7KE+vEfCA1CjCVPrsb0G/UOuIzNeEc5WB07a9tCrb5/ScnR5QdbpeNh0T
pU4BPSZGqo2uApsRMadYP2d+jK8x0H0R1ZHizw6O2FPNAgMBAAGjYzBhMA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQGT1ok93lYzUxf
juP5HX0H8O6NkzAfBgNVHSMEGDAWgBQGT1ok93lYzUxfjuP5HX0H8O6NkzANBgkq
hkiG9w0BAQsFAAOCAQEAYXklYevHHSdrseWRw1oyZb08R743En6quNK+/B1kc2l8
VToJdQh043aeTpl0U4O0yhL+a/DHIlaQTF9PDxsJdsuTSKUKpa0FgUvzFddnxTtJ
HcSEUvtqTt/+S5t0VwHAD7EBApWnSgdQlRsNZ5pr5d3k362d3oBZDFRDnxMme1jN
SA4GsTd2oxH+z4iVAs/BWVgkxzcYlUnA1sy4i58B6uTFkw+tHGTPtuTYdtUqA4mO
JASKwhl8fH1JSbx0NNpFfIs5Ra43y1OWhi0Pva/tvOCG/t0SL6gQYFLKUhjcESIw
sOej9dCoqOgFndiHVVnIxXzwt1rsz7E5DdeFa/pYxA==
-----END CERTIFICATE-----
ubuntu@hmc:~$ cat issuer-ca.crt 
-----BEGIN CERTIFICATE-----
MIIDGzCCAgOgAwIBAgIUewEW8HEFGOkNE5xKsKxhKisAlaUwDQYJKoZIhvcNAQEL
BQAwFTETMBEGA1UEAxMKTXkgUm9vdCBDQTAeFw0yNTAyMDUxMTI5NTJaFw0yNjAy
MDUxMTMwMjFaMBUxEzARBgNVBAMTCk15IFJvb3QgQ0EwggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQC943BuWn0SUOds/MX4WnIQXozpYy3W/hxnvx7JPyWZ
CeMfcXqu96iUoSXq8pKLsF4G8e84QhCl5pR4dp9wcGUupY6urfiAVI7t+RY0k7cP
UcLJPAWkRKjWbQdr/a4Yb711xwXNup47OR+TVatCU2Hknvm0PBmM3lB5FdVBvk8Q
kH3vvnPW9vlKiwes0pYiC8B1WvrBVUZPkHnOE0t2ZxFzBa9IufWwRUpOT+JKSpJs
VMrw2yV7KE+vEfCA1CjCVPrsb0G/UOuIzNeEc5WB07a9tCrb5/ScnR5QdbpeNh0T
pU4BPSZGqo2uApsRMadYP2d+jK8x0H0R1ZHizw6O2FPNAgMBAAGjYzBhMA4GA1Ud
DwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBQGT1ok93lYzUxf
juP5HX0H8O6NkzAfBgNVHSMEGDAWgBQGT1ok93lYzUxfjuP5HX0H8O6NkzANBgkq
hkiG9w0BAQsFAAOCAQEAYXklYevHHSdrseWRw1oyZb08R743En6quNK+/B1kc2l8
VToJdQh043aeTpl0U4O0yhL+a/DHIlaQTF9PDxsJdsuTSKUKpa0FgUvzFddnxTtJ
HcSEUvtqTt/+S5t0VwHAD7EBApWnSgdQlRsNZ5pr5d3k362d3oBZDFRDnxMme1jN
SA4GsTd2oxH+z4iVAs/BWVgkxzcYlUnA1sy4i58B6uTFkw+tHGTPtuTYdtUqA4mO
JASKwhl8fH1JSbx0NNpFfIs5Ra43y1OWhi0Pva/tvOCG/t0SL6gQYFLKUhjcESIw
sOej9dCoqOgFndiHVVnIxXzwt1rsz7E5DdeFa/pYxA==
-----END CERTIFICATE-----
```

issuing certificate endpointsやCRL distribution pointsを設定します。
ルートCAのVaultサーバのドメインを指定します。

vault write pki_root/config/urls \
    issuing_certificates="http://root-ca.vault.com:8200/v1/pki/ca" \
    crl_distribution_points="http://root-ca.vault.com:8200/v1/pki/crl"