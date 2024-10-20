# coding: utf-8
##
## Ansibleプレイブックの転送と適用
##
def apply_ansible_playbook(node)

  $base = File.basename(Dir.getwd)
  #msg = sprintf("\n\nVM %s setup in progress\n", node['name'])
  #step_start(msg)

  # 
  # 不要なAnsibleのディレクトリを削除
  #
  start_tm(sprintf("* 不要なAnsibleのディレクトリを削除\n"))
  cmd = sprintf("ssh -i __work/id_rsa ubuntu@%s -o 'StrictHostKeyChecking no' \"rm -fr %s\"", node['private_ip'], $base)
  puts cmd
  value = %x( #{cmd} )
  puts value

  #
  # 最新のAnsibleプレイブックを転送
  #
  start_tm(sprintf("* 最新のAnsibleプレイブックを転送\n"))
  cmd = sprintf("scp  -o 'StrictHostKeyChecking no' -i __work/id_rsa -r %s ubuntu@%s:", "../" + $base, node['private_ip'])
  puts cmd
  value = %x( #{cmd} )
  retc = $?.exitstatus
  finish_tm(retc)
  if retc != 0
    !exit
  end

  #
  # Inventory の存在チェックとデフォルトセット
  #
  inventory = "hosts_kvm"
  if node['inventory'].nil? == false
      inventory = node['inventory']
  end

  
  #
  # Ansibleの適用
  #
  start_tm(sprintf("* Ansibleプレイブックの適用\n"))
  cmd = sprintf("ssh -i __work/id_rsa ubuntu@%s -o 'StrictHostKeyChecking no' \"cd %s && sudo ansible-playbook -i %s  -l %s playbook/%s\"", node['private_ip'], $base, inventory, node['name'],node['playbook'])
  puts cmd
  value = %x( #{cmd} )
  retc = $?.exitstatus  
  puts value
  finish_tm(retc)
  if retc != 0
    !exit
  end
end
