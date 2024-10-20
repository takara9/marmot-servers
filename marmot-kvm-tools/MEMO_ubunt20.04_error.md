Ubuntu20.04 でリポジトリへアクセスできなくなったり、エラーが発生する場合に、
OSテンプレートイメージを起動して、以下の手順でアップグレードする。

virt-install --connect=qemu+tls://hv3/system --name ubuntu20.04 --memory 1024 --vcpus 1 --cpu kvm64 --hvm --os-variant ubuntu20.04 --network network=default,model=virtio --network network=private --network bridge=virbr1 --import --graphics none --noautoconsole --disk /home/images/ubuntu20.04-amd.qcow2


virt-install --connect=qemu+tls://hv4/system --name ubuntu20.04 --memory 1024 --vcpus 1 --cpu kvm64 --hvm --os-variant ubuntu20.04 --network network=default,model=virtio --network network=private --network bridge=virbr1 --import --graphics none --noautoconsole --disk /home/images/ubuntu20.04-amd.qcow2

apt-get upgrade --fix-missing
apt-get clean
apt update && sudo apt upgrade -y
apt-get autoremove