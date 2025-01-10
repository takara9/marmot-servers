
## Ubuntu22.04 node2 の cgroup のリスト

root@node2:~# systemd-cgls --no-pager
Control group /:
-.slice
├─user.slice 
│ └─user-0.slice 
│   ├─session-1.scope 
│   │ ├─2378 sshd: root@pts/0
│   │ ├─2485 -bash
│   │ └─2502 systemd-cgls --no-pager
│   └─user@0.service …
│     └─init.scope 
│       ├─2382 /lib/systemd/systemd --user
│       └─2383 (sd-pam)
├─init.scope 
│ └─1 /sbin/init
├─system.slice 
│ ├─irqbalance.service 
│ │ └─639 /usr/sbin/irqbalance --foreground
│ ├─containerd.service …
│ │ ├─ 652 /usr/local/bin/containerd
│ │ ├─ 947 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 60afea4b416c9ac5f87f9993aa4849114b61adb1a71d963b4727ad4898b87258 -address /run/containerd/containerd.sock
│ │ ├─ 994 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 8bebfa3d737a34481f0915859a4278a0f24d9abbbd215039dd2fdd2d6a24ae34 -address /run/containerd/containerd.sock
│ │ ├─1033 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 6081fa4d9218da6e269ac318faf6138c0d0caff1f783ce3cac3b5e8d6ab4edbf -address /run/containerd/containerd.sock
│ │ ├─1061 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id b5011aa871fa1a7ba6825193e049498135967f48ba43182075b3a0b7c6f8ddd6 -address /run/containerd/containerd.sock
│ │ └─2242 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id e13d6e852a571d3948aaec028d3a6af16390c95adb4d4382c029119d0c8cae15 -address /run/containerd/containerd.sock
│ ├─systemd-networkd.service 
│ │ └─618 /lib/systemd/systemd-networkd
│ ├─systemd-udevd.service 
│ │ └─435 /lib/systemd/systemd-udevd
│ ├─cron.service 
│ │ └─717 /usr/sbin/cron -f -P
│ ├─system-serial\x2dgetty.slice 
│ │ └─serial-getty@ttyS0.service 
│ │   └─721 /sbin/agetty -o -p -- \u --keep-baud 115200,57600,38400,9600 ttyS0 vt220
│ ├─polkit.service 
│ │ └─643 /usr/libexec/polkitd --no-debug
│ ├─networkd-dispatcher.service 
│ │ └─642 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
│ ├─multipathd.service 
│ │ └─429 /sbin/multipathd -d -s
│ ├─kubelet.service 
│ │ └─641 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///var…
│ ├─ModemManager.service 
│ │ └─710 /usr/sbin/ModemManager
│ ├─systemd-journald.service 
│ │ └─390 /lib/systemd/systemd-journald
│ ├─unattended-upgrades.service 
│ │ └─706 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
│ ├─ssh.service 
│ │ └─678 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
│ ├─snapd.service 
│ │ └─647 /usr/lib/snapd/snapd
│ ├─rsyslog.service 
│ │ └─645 /usr/sbin/rsyslogd -n -iNONE
│ ├─rpcbind.service 
│ │ └─573 /sbin/rpcbind -f -w
│ ├─udisks2.service 
│ │ └─651 /usr/libexec/udisks2/udisksd
│ ├─dbus.service 
│ │ └─633 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
│ ├─systemd-timesyncd.service 
│ │ └─575 /lib/systemd/systemd-timesyncd
│ ├─system-getty.slice 
│ │ └─getty@tty1.service 
│ │   └─724 /sbin/agetty -o -p -- \u --noclear tty1 linux
│ └─systemd-logind.service 
│   └─649 /lib/systemd/systemd-logind
└─kubepods.slice 
  ├─kubepods-burstable.slice 
  │ ├─kubepods-burstable-poddeec8eaa_762b_4488_930e_ca027350a56c.slice 
  │ │ ├─cri-containerd-b5011aa871fa1a7ba6825193e049498135967f48ba43182075b3a0b7c6f8ddd6.scope …
  │ │ │ └─1130 /pause
  │ │ └─cri-containerd-a6169e340ef4898071b1a6a143f831e77a8849fd29d8366355e0718bfbcbe6ae.scope …
  │ │   ├─1795 cilium-agent --config-dir=/tmp/cilium/config-map
  │ │   └─2204 cilium-health-responder --listen 4240 --pidfile /var/run/cilium/state/health-endpoint.pid
  │ └─kubepods-burstable-pod37e86a8c_ae27_4d50_a868_a8509947fe25.slice 
  │   ├─cri-containerd-e13d6e852a571d3948aaec028d3a6af16390c95adb4d4382c029119d0c8cae15.scope …
  │   │ └─2266 /pause
  │   └─cri-containerd-a281e28197357910f3de1c784dfde7b3924e49b3147cb2af540a3596a743a88b.scope …
  │     └─2299 /metrics-server --cert-dir=/tmp --secure-port=4443 --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname --kubelet-use-node-status-port --metric-resolution=15s --kubelet-insecure-tls
  └─kubepods-besteffort.slice 
    ├─kubepods-besteffort-pod9da901e3_5ecf_4ad0_8898_6705162646e0.slice 
    │ ├─cri-containerd-60afea4b416c9ac5f87f9993aa4849114b61adb1a71d963b4727ad4898b87258.scope …
    │ │ └─970 /pause
    │ └─cri-containerd-b21d5d7ee6c771bf3929949d7d809ff37fb5ac931fbd9e056aa65cdef0bafa65.scope …
    │   └─1181 cilium-operator-generic --config-dir=/tmp/cilium/config-map --debug=false
    ├─kubepods-besteffort-pod14b729a1_249f_4f8f_a80f_2c18895a4072.slice 
    │ ├─cri-containerd-6081fa4d9218da6e269ac318faf6138c0d0caff1f783ce3cac3b5e8d6ab4edbf.scope …
    │ │ └─1095 /pause
    │ └─cri-containerd-18289688b30a5298b19766895d77d6c6abc69de1660a2302542d3a4968551bad.scope …
    │   ├─1211 /usr/bin/cilium-envoy-starter -- -c /var/run/cilium/envoy/bootstrap-config.json --base-id 0 --log-level info --log-format [%Y-%m-%d %T.%e][%t][%l][%n] [%g:%#] %v
    │   └─1249 /usr/bin/cilium-envoy -c /var/run/cilium/envoy/bootstrap-config.json --base-id 0 --log-level info --log-format [%Y-%m-%d %T.%e][%t][%l][%n] [%g:%#] %v
    └─kubepods-besteffort-pod698c53d8_3460_48bb_988c_3032faa318d3.slice 
      ├─cri-containerd-8bebfa3d737a34481f0915859a4278a0f24d9abbbd215039dd2fdd2d6a24ae34.scope …
      │ └─1024 /pause
      └─cri-containerd-a6371d8f4a0fcdf926e345738d97a12846f6f258c6ed4a088186d0e1f943c6fb.scope …
        └─1119 /usr/local/bin/kube-proxy --config=/var/lib/kube-proxy/config.conf --hostname-override=node2


## 主なCGroup

init.scope
user.slice
system.slice
kubepods.slice
  kubepods-burstable.slice
  kubepods-besteffort.slice

## kubepods.sliceの詳細

### 何も設定していない場合

root@node2:/# ls /sys/fs/cgroup/kubepods.slice/
cgroup.controllers      cgroup.subtree_control  cpu.uclamp.max         cpuset.mems.effective     hugetlb.2MB.events        io.stat                    memory.low           memory.swap.events  rdma.current
cgroup.events           cgroup.threads          cpu.uclamp.min         hugetlb.1GB.current       hugetlb.2MB.events.local  io.weight                  memory.max           memory.swap.high    rdma.max
cgroup.freeze           cgroup.type             cpu.weight             hugetlb.1GB.events        hugetlb.2MB.max           kubepods-besteffort.slice  memory.min           memory.swap.max
cgroup.kill             cpu.idle                cpu.weight.nice        hugetlb.1GB.events.local  hugetlb.2MB.rsvd.current  kubepods-burstable.slice   memory.numa_stat     misc.current
cgroup.max.depth        cpu.max                 cpuset.cpus            hugetlb.1GB.max           hugetlb.2MB.rsvd.max      memory.current             memory.oom.group     misc.max
cgroup.max.descendants  cpu.max.burst           cpuset.cpus.effective  hugetlb.1GB.rsvd.current  io.max                    memory.events              memory.pressure      pids.current
cgroup.procs            cpu.pressure            cpuset.cpus.partition  hugetlb.1GB.rsvd.max      io.pressure               memory.events.local        memory.stat          pids.events
cgroup.stat             cpu.stat                cpuset.mems            hugetlb.2MB.current       io.prio.class             memory.high                memory.swap.current  pids.max

root@node2:/# cat /sys/fs/cgroup/kubepods.slice/cgroup.controllers 
cpuset cpu io memory hugetlb pids rdma misc

root@node2:/# cat /sys/fs/cgroup/kubepods.slice/memory.current 
788398080
root@node2:/# cat /sys/fs/cgroup/kubepods.slice/memory.high 
max
root@node2:/# cat /sys/fs/cgroup/kubepods.slice/memory.low 
0
root@node2:/# cat /sys/fs/cgroup/kubepods.slice/memory.max
8325677056
root@node2:/# cat /sys/fs/cgroup/kubepods.slice/memory.min
0

### Kubeletに設定を入れた場合

/var/lib/kubelet/config.yamlの最後に、以下を追加

systemReserved:
  memory: 4G


oot@node2:/var/lib/kubelet# systemctl restart kubelet
root@node2:/var/lib/kubelet# systemctl status kubelet
● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Thu 2024-11-21 20:21:25 UTC; 7s ago
       Docs: https://kubernetes.io/docs/
   Main PID: 2662 (kubelet)
      Tasks: 10 (limit: 9392)
     Memory: 24.4M
        CPU: 247ms
     CGroup: /system.slice/kubelet.service
             └─2662 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=u>

root@node2:/var/lib/kubelet# cat /sys/fs/cgroup/kubepods.slice/memory.current 
791552000
root@node2:/var/lib/kubelet# cat /sys/fs/cgroup/kubepods.slice/memory.high
max
root@node2:/var/lib/kubelet# cat /sys/fs/cgroup/kubepods.slice/memory.low 
0
root@node2:/var/lib/kubelet# cat /sys/fs/cgroup/kubepods.slice/memory.max
4325675008
root@node2:/var/lib/kubelet# cat /sys/fs/cgroup/kubepods.slice/memory.min
0

tkr@hmc:~/marmot-servers/kubernetes/manifests$ kubectl describe pod boostable-84646bff6-rjxwx
Name:             boostable-84646bff6-rjxwx
Namespace:        default
Priority:         0
Service Account:  default
Node:             node2/172.16.3.32
Start Time:       Fri, 22 Nov 2024 06:07:46 +0900
Labels:           app.kubernetes.io/name=mem-eater-bst
                  pod-template-hash=84646bff6
Annotations:      <none>
Status:           Succeeded
IP:               10.0.2.5
IPs:
  IP:           10.0.2.5
Controlled By:  ReplicaSet/boostable-84646bff6
Containers:
  mem-eater:
    Container ID:  containerd://821940ab50cbe0f9a015079d70c427b53f00e067d7a74853e5f99e7200e2908d
    Image:         ghcr.io/takara9/mem-eater:0.2
    Image ID:      ghcr.io/takara9/mem-eater@sha256:65e948d37a8d3fcb9660c8de29e691da22dc962df61ce957d8a797f888a768d7
    Port:          <none>
    Host Port:     <none>
    Args:
      1
      80
      5
      boostable
    State:          Terminated
      Reason:       Completed
      Exit Code:    0
      Started:      Fri, 22 Nov 2024 06:07:47 +0900
      Finished:     Fri, 22 Nov 2024 06:10:58 +0900
    Ready:          False
    Restart Count:  0
    Requests:
      cpu:        100m
      memory:     100Mi
    Environment:  <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-76lxx (ro)
Conditions:
  Type                        Status
  DisruptionTarget            True 
  PodReadyToStartContainers   False 
  Initialized                 True 
  Ready                       False 
  ContainersReady             False 
  PodScheduled                True 
Volumes:
  kube-api-access-76lxx:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Burstable
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason   Age   From     Message
  ----     ------   ----  ----     -------
  Normal   Pulled   13m   kubelet  Container image "ghcr.io/takara9/mem-eater:0.2" already present on machine
  Normal   Created  13m   kubelet  Created container mem-eater
  Normal   Started  13m   kubelet  Started container mem-eater
  Warning  Evicted  10m   kubelet  The node was low on resource: memory. Threshold quantity: 100Mi, available: 58472Ki. Container mem-eater was using 3694056Ki, request is 100Mi, has larger consumption of memory.
  Normal   Killing  10m   kubelet  Stopping container mem-eater


root@node2:~# ls  /sys/fs/cgroup/kubepods.slice/
cgroup.controllers      cgroup.subtree_control  cpu.uclamp.max         cpuset.mems.effective     hugetlb.2MB.events        io.stat                    memory.low           memory.swap.events  rdma.current
cgroup.events           cgroup.threads          cpu.uclamp.min         hugetlb.1GB.current       hugetlb.2MB.events.local  io.weight                  memory.max           memory.swap.high    rdma.max
cgroup.freeze           cgroup.type             cpu.weight             hugetlb.1GB.events        hugetlb.2MB.max           kubepods-besteffort.slice  memory.min           memory.swap.max
cgroup.kill             cpu.idle                cpu.weight.nice        hugetlb.1GB.events.local  hugetlb.2MB.rsvd.current  kubepods-burstable.slice   memory.numa_stat     misc.current
cgroup.max.depth        cpu.max                 cpuset.cpus            hugetlb.1GB.max           hugetlb.2MB.rsvd.max      memory.current             memory.oom.group     misc.max
cgroup.max.descendants  cpu.max.burst           cpuset.cpus.effective  hugetlb.1GB.rsvd.current  io.max                    memory.events              memory.pressure      pids.current
cgroup.procs            cpu.pressure            cpuset.cpus.partition  hugetlb.1GB.rsvd.max      io.pressure               memory.events.local        memory.stat          pids.events
cgroup.stat             cpu.stat                cpuset.mems            hugetlb.2MB.current       io.prio.class             memory.high                memory.swap.current  pids.max
root@node2:~# cat /sys/fs/cgroup/kubepods.slice/memory.current 
3171254272
root@node2:~# cat /sys/fs/cgroup/kubepods.slice/memory.max 
4325675008
root@node2:~# cat /sys/fs/cgroup/kubepods.slice/memory.min
0
root@node2:~# cat /sys/fs/cgroup/kubepods.slice/memory.low
0
root@node2:~# cat /sys/fs/cgroup/kubepods.slice/memory.high 
max



├─system.slice 
│ ├─irqbalance.service 
│ │ └─639 /usr/sbin/irqbalance --foreground
│ ├─containerd.service …
│ │ ├─ 652 /usr/local/bin/containerd
│ │ ├─ 947 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 60afea4b416c9ac5f87f9993aa4849114b61adb1a71d963b4727ad4898b87258 -address /run/containerd/containerd.sock
│ │ ├─ 994 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 8bebfa3d737a34481f0915859a4278a0f24d9abbbd215039dd2fdd2d6a24ae34 -address /run/containerd/containerd.sock
│ │ ├─1033 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id 6081fa4d9218da6e269ac318faf6138c0d0caff1f783ce3cac3b5e8d6ab4edbf -address /run/containerd/containerd.sock
│ │ ├─1061 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id b5011aa871fa1a7ba6825193e049498135967f48ba43182075b3a0b7c6f8ddd6 -address /run/containerd/containerd.sock
│ │ ├─2242 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id e13d6e852a571d3948aaec028d3a6af16390c95adb4d4382c029119d0c8cae15 -address /run/containerd/containerd.sock
│ │ └─7778 /usr/local/bin/containerd-shim-runc-v2 -namespace k8s.io -id eb8091e86ec0e1af18a1056774ba25499db295a1e0ed12ab2a25b453ac27087d -address /run/containerd/containerd.sock
│ ├─packagekit.service 
│ │ └─3001 /usr/libexec/packagekitd
│ ├─systemd-networkd.service 
│ │ └─618 /lib/systemd/systemd-networkd
│ ├─systemd-udevd.service 
│ │ └─435 /lib/systemd/systemd-udevd
│ ├─cron.service 
│ │ └─717 /usr/sbin/cron -f -P
│ ├─system-serial\x2dgetty.slice 
│ │ └─serial-getty@ttyS0.service 
│ │   └─721 /sbin/agetty -o -p -- \u --keep-baud 115200,57600,38400,9600 ttyS0 vt220
│ ├─polkit.service 
│ │ └─643 /usr/libexec/polkitd --no-debug
│ ├─networkd-dispatcher.service 
│ │ └─642 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
│ ├─multipathd.service 
│ │ └─429 /sbin/multipathd -d -s
│ ├─kubelet.service 
│ │ └─7386 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf --config=/var/lib/kubelet/config.yaml --container-runtime-endpoint=unix:///va>
│ ├─ModemManager.service 
│ │ └─710 /usr/sbin/ModemManager
│ ├─systemd-journald.service 
│ │ └─390 /lib/systemd/systemd-journald
│ ├─unattended-upgrades.service 
│ │ └─706 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
│ ├─ssh.service 
│ │ └─678 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
│ ├─snapd.service 
│ │ └─647 /usr/lib/snapd/snapd
│ ├─rsyslog.service 
root@node2:~# cat /sys/fs/cgroup/system.slice/kubelet.service/memory.max
max
root@node2:~# cat /sys/fs/cgroup/system.slice/kubelet.service/memory.current 
33873920
root@node2:~# cat /sys/fs/cgroup/system.slice/kubelet.service/memory.max
max