#!/usr/bin/ruby
# coding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :
#
Warning[:deprecated] = false

require 'etcdv3'
require "json"
require 'yaml'
$conn = nil
$conf = nil

# etcd キーの情報
#   vm_serial    VMのシリアル番号 1から999で循環
#   hv1〜hv99    HVノード(廃止)
#   hvr1〜hvr99  HVノードの割当可能資源
#   vm1〜vm999   VMのデータ
#

# 公開
# Etcdエンドポイント
#
def etcd_connect()
  $conn = Etcdv3.new(endpoints: 'http://127.0.0.1:2379', command_timeout: 3)
  return $conn
end


# 公開
# YAMLデータの取り込み
#
def hvm_hv_config(config_file)
  if $conn == nil
    etcd_connect()
  end
  $conf = YAML.load_file(config_file)
  save_etcd_hv_config()
end


# 内部
# 登録仮想サーバー登録
#
def set_vm_on_hv(vm)
  json_text = JSON.generate(vm)
  sno = $conn.get('vm_serial').kvs.first.value.to_i
  key = sprintf("vm%d",sno)
  $conn.put(key,json_text)
  sno = sno + 1
  $conn.put('vm_serial', sno.to_s)
end


# 公開
# 仮想サーバーの名前を指定して削除、HVノードのリソースを戻す
#
def hvm_vm_destroy(vm_name)
  if $conn == nil
    etcd_connect()
  end
  
  x = $conn.get('vm1', range_end: 'vm999')
  for y in x.kvs
    z = JSON.parse!(y.value)
    if vm_name == z['vm_name']
      printf("key=%s hv=%s vm=%s key=%s CPU=%d RAM=%d \n",y.key,z['hv_node'],z['vm_name'],z['key'],z['cpu'],z['memory'])

      # VM1から削除
      $conn.del(y.key)

      # HVRにリソースを返却
      hv = JSON.parse!($conn.get(z['key']).kvs.first.value)
      hv['free-cpu'] = hv['free-cpu'].to_i + z['cpu'].to_i
      hv['free-memory'] = hv['free-memory'].to_i + z['memory'].to_i
      json_text = JSON.generate(hv)
      $conn.put(z['key'],json_text)
      return true, z['hv_node']
    end
  end
  return nil,nil
end

# 公開
# 仮想サーバーの名前を指定して削除、HVノードのリソースを戻す
#
def hvm_vm_host(vm_name)
  if $conn == nil
    etcd_connect()
  end
  
  x = $conn.get('vm1', range_end: 'vm999')
  for y in x.kvs
    z = JSON.parse!(y.value)
    if vm_name == z['vm_name']
      #printf("key=%s hv=%s vm=%s key=%s CPU=%d RAM=%d \n",y.key,z['hv_node'],z['vm_name'],z['key'],z['cpu'],z['memory'])
      return true, z['hv_node']
    end
  end
  return nil,nil
end



# 内部
# 仮想サーバーの名前を検索
#
def vm_search(vm_name)
  x = $conn.get('vm1', range_end: 'vm999')
  for y in x.kvs
    z = JSON.parse!(y.value)
    if vm_name == z['vm_name']
      return true
    end
  end
  return false
end



# 内部
# リソースの読み込み
#
def save_etcd_hv_config()
  hv_idx = 1
  $conf['hypervisor_specs'].each do |val|
    # 消費量の初期値セット
    val['free-cpu'] = val['cpu'] 
    val['free-memory'] = val['memory']
    
    # JSONテキストを生成
    json_text = JSON.generate(val)
    
    # 残りリソース管理用のキー
    hvr_key = sprintf("hvr%d",hv_idx)
    ret = $conn.put(hvr_key, json_text)
    hv_idx = hv_idx + 1

  end
end


# 内部
# 引き当てたリソースを更新する
#
def update_rsc(hv,vm,vkey)

  # リソースの引当て
  hv['free-cpu'] = (hv['free-cpu'].to_i - vm['cpu']).to_s
  hv['free-memory'] = (hv['free-memory'].to_i - vm['memory']).to_s
  hv['key'] = vkey
  vm['key'] = vkey

  # 引当て後のリソース量を更新
  json_text = JSON.generate(hv)
  $conn.put(vkey, json_text)

  # 更新したHVノード名を返却
  x = sprintf("* デプロイするノード決定 %s (%s)\n",hv['nodename'],hv['key'])
  start_tm(x)
  x = sprintf("* 残り資源 CPU=%s RAM=%s\n",hv['free-cpu'],hv['free-memory'] )
  start_tm(x)
  return hv['nodename']
end


# 公開
# 仮想サーバーのスケジュールと仮想サーバーリストへ登録
#
def hvm_schedule(vm)
  if $conn == nil
    etcd_connect()
  end

  # 同一VM名で起動していないかチェック
  if vm_search(vm['vm_name']) == true
    return nil
  end
  
  # HVノードをサーチ
  vm['hv_node'] = search_hv_node(vm) 
  if vm['hv_node'].nil?
    # スケジュール不可
    return nil
  else
    # VMを管理テーブルへ登録
    set_vm_on_hv(vm)
    return vm
  end
end




# 内部
# ハイパーバイザーのリストを取得
#
def list_hv_node()
  list = $conn.get('hvr1', range_end: 'hvr99')
  nno = $conn.get('hv_rotate').kvs.first.value.to_i
  nnox = nno + 1
  if nnox == list.kvs.length
    nnox = 0
  end
  $conn.put('hv_rotate', nnox.to_s)
  return list.kvs[nno].key, JSON.parse!(list.kvs[nno].value)
end

# 内部
# スケジュール可能なHVノードのサーチ
#
def search_hv_node( vm )
  key, hvn = list_hv_node()
  a_cpu = hvn['free-cpu'].to_i
  a_ram = hvn['free-memory'].to_i
  if a_cpu >= vm['cpu'] and a_ram >= vm['memory']
    x = sprintf("* スケジュール可能ノードのサーチ key=%s node=%s cpu=%d, ram=%d\n",
                key, hvn['nodename'], a_cpu ,a_ram)
    start_tm(x)
    return update_rsc(hvn, vm, key)
  else
    for i in 0..2
      key, hvn = list_hv_node()
      a_cpu = hvn['free-cpu'].to_i
      a_ram = hvn['free-memory'].to_i
      if a_cpu >= vm['cpu'] and a_ram >= vm['memory']
        x = sprintf("* スケジュール可能ノードのサーチ key=%s node=%s cpu=%d, ram=%d\n",
                    key, hvn['nodename'], a_cpu ,a_ram)
        start_tm(x)
        return update_rsc(hvn, vm, key)
      end
    end
    return nil
  end
end

