## S3 テストクライアント


以下の項目を編集する

- endpoint_url='https://minio.labo.local:9002',
- aws_access_key_id='sSJSyiiLqVD3wX6gk5HJ', # ログイン名
- aws_secret_access_key='mtcEbUYKSEPKuQkNhOzmVWBnJjOBMLOQzlthbTxe', # ログインパスワード
- BUCKET_NAME = 'loki'


### boto3をインストールして実行

バケット、オブジェクトのリストを表示

```
pip3 install boto3
python3 client-list.py
```




