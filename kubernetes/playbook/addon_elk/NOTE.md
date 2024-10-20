# Helmによるインストール


https://github.com/elastic/helm-charts/blob/main/elasticsearch/README.md

kubectl create namespace elasticsearch
helm repo add elastic https://helm.elastic.co
helm inspect values  elastic/elasticsearch > elasticsearch-values.yaml    

ストレージクラスとIngressの追加

helm install elasticsearch -n elasticsearch -f elasticsearch-values.yaml elastic/elasticsearch
helm install kibana -n elasticsearch -f kibana-values.yaml elastic/kibana