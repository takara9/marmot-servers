import boto3
import urllib3

urllib3.disable_warnings()


s3 = boto3.resource(
     's3',
     endpoint_url='https://minio.labo.local:9002',
     aws_access_key_id='sSJSyiiLqVD3wX6gk5HJ', # ログイン名
     aws_secret_access_key='mtcEbUYKSEPKuQkNhOzmVWBnJjOBMLOQzlthbTxe', # ログインパスワード
     verify=False
)

# バケット内の全オブジェクトを表示
BUCKET_NAME = 'loki'
OBJECT_NAME = 'testfile.txt'
FILE_NAME = OBJECT_NAME + '-get'


# オブジェクトをアップロード
bucket = s3.Bucket(BUCKET_NAME)
with open(FILE_NAME, 'wb') as f:
    bucket.download_fileobj(OBJECT_NAME, f)


