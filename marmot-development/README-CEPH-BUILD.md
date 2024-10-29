#

~~~
$ mactl -api http://hv1:8750 -ccf ceph-build-config.yaml create
~~~

$ ssh ubuntu@172.16.0.101
$ sudo -s
# lsblk
# mkfs.ext4 /dev/vdb
# mkfs.ext4 /dev/vdc
# mkdir /work
# mount /dev/vdb /work
# mount /dev/vdc /usr/local
# cd /work
# chown ubuntu:ubuntu .
# exit
$ cd /work
$ sudo apt-get update
$ sudo apt-get install nmon
$ git clone -b v17.2.5 https://github.com/ceph/ceph.git
$ cd ceph
$ git submodule update --init --recursive
$ ./install-deps.sh
$ ./do_cmake.sh
$ cd build
$ ninja
$ cd ..
$ sudo locale-gen en_US
$ sudo update-locale LANG=en_US
$ sudo dpkg-buildpackage
