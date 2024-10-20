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
FILE_NAME = 'testfile.txt'
OBJECT_NAME = FILE_NAME


# オブジェクトをアップロード
bucket = s3.Bucket(BUCKET_NAME)
with open(FILE_NAME, 'rb') as f:
    bucket.upload_fileobj(f, OBJECT_NAME)


