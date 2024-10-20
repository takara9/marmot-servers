# coding: utf-8

## 
## kube-apiserver のアドレスで置き換える
## playbook/node_master/templates/kube-apiserver.service.j2
##
def kube_apiserver_service()

  host_list = host_list("master",1,2379)
  k8s_ver = $conf['kubernetes_version'].split(".")

  if k8s_ver[1].to_i >= 23
    tfn = "templates/playbook/kube-apiserver.service-v1.23.j2.template"
    ofn = "playbook/node_master/templates/kube-apiserver.service-v1.20.j2"
  elsif k8s_ver[1].to_i >= 22
    tfn = "templates/playbook/kube-apiserver.service-v1.22.j2.template"
    ofn = "playbook/node_master/templates/kube-apiserver.service-v1.20.j2"
  elsif k8s_ver[1].to_i >= 20
    tfn = "templates/playbook/kube-apiserver.service-v1.20.j2.template"
    ofn = "playbook/node_master/templates/kube-apiserver.service-v1.20.j2"
  else
    tfn = "templates/playbook/kube-apiserver.service.j2.template"
    ofn = "playbook/node_master/templates/kube-apiserver.service.j2"
  end
  
  $file_list.push(ofn)
  
  File.open(tfn, "r") do |f|  
    File.open(ofn , "w") do |w|
      w.write $insert_msg
      w.write sprintf("### Template file is %s\n",tfn)
      f.each_line { |line|
        if line =~ /__ETCD_LIST__/
          #puts host_list
          w.write line.gsub(/__ETCD_LIST__/, host_list)
        elsif line =~ /__APISERVER_COUNT__/
          api_server_count = 1
          if $cnt['master'] > 0
            api_server_count = $cnt['master']
          end
          w.write line.gsub(/__APISERVER_COUNT__/, sprintf("%d", api_server_count))
        else
          w.write line
        end
      }
    end
  end

end

##
## etcdのクラスタメンバーのIPアドレス設定
## playbook/etcd/templates/etcd.service.j2
##
def etcd_service()

  host_list = coredns_host_ip_list()
  tfn = "templates/playbook/etcd.service.j2.template"
  ofn = "playbook/etcd/templates/etcd.service.j2"
  $file_list.push(ofn)
  File.open(tfn, "r") do |f|  
    File.open(ofn, "w") do |w|
      w.write $insert_msg
      w.write sprintf("### Template file is %s\n",tfn)
      f.each_line { |line|
        if line =~ /__ETCD_LIST__/
          w.write line.gsub(/__ETCD_LIST__/, host_list)            
        else
          w.write line
        end
      }
    end
  end
end

##
## etcd.yam
##  playbook/cert_setup/tasks/etcd.yaml
##
def etcd_yaml()

  # マスターノードと内部ロードバランサーのリスト作成
  list_mst = host_list("master",0,0) + "," + host_list("master",1,0) 
  list_mlb = host_list("mlb",0,0) + "," + host_list("mlb",1,0)  
  list_all = list_mst + "," + list_mlb

  list_all = (host_list("master",0,0).length == 0 ? "" : host_list("master",0,0)) \
             + (host_list("master",1,0).length == 0 ? "" : "," + host_list("master",1,0)) \
             + (host_list("mlb",0,0).length == 0 ? "" : "," + host_list("mlb",0,0)) \
             + (host_list("mlb",1,0).length == 0 ? "" : "," + host_list("mlb",1,0)) \
             + ",10.32.0.1,127.0.0.1,kubernetes,kubernetes.default,kubernetes.default.svc" \
             + ",kubernetes.default.svc." + $sub_domain \
             + ",kubernetes.default.svc." + $domain
               
  ofn = "playbook/cert_setup/vars/main.yaml"
  $file_list.push(ofn)  
  File.open(ofn, "w") do |w|
    w.write sprintf("host_list_etcd: %s\n",list_all)
  end
end

