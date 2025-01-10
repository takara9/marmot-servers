
## 参考資料
- https://gihyo.jp/admin/serial/01/linux_containers/0038






```
root@cgroup-test:/home/ubuntu# systemd-cgls --no-pager > memo.txt
root@cgroup-test:/home/ubuntu# cat memo.txt 
Control group /:
-.slice
├─user.slice 
│ └─user-1000.slice 
│   ├─user@1000.service …
│   │ └─init.scope 
│   │   ├─803 /lib/systemd/systemd --user
│   │   └─804 (sd-pam)
│   ├─session-3.scope 
│   │ ├─ 996 sshd: ubuntu [priv]
│   │ ├─1056 sshd: ubuntu@pts/2
│   │ ├─1057 -bash
│   │ ├─1066 sudo -s
│   │ ├─1067 sudo -s
│   │ ├─1068 /bin/bash
│   │ └─1184 systemd-cgls --no-pager
│   └─session-1.scope 
│     ├─742 sshd: ubuntu [priv]
│     ├─887 sshd: ubuntu@pts/0
│     ├─888 -bash
│     ├─900 sudo -s
│     └─906 sudo -s
├─init.scope 
│ └─1 /sbin/init
├─system.slice 
│ ├─systemd-networkd.service 
│ │ └─588 /lib/systemd/systemd-networkd
│ ├─systemd-udevd.service 
│ │ └─419 /lib/systemd/systemd-udevd
│ ├─cron.service 
│ │ └─601 /usr/sbin/cron -f -P
│ ├─system-serial\x2dgetty.slice 
│ │ └─serial-getty@ttyS0.service 
│ │   └─624 /sbin/agetty -o -p -- \u --keep-baud 115200,57600,38400,9600 ttyS0 …
│ ├─polkit.service 
│ │ └─610 /usr/libexec/polkitd --no-debug
│ ├─networkd-dispatcher.service 
│ │ └─609 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
│ ├─multipathd.service 
│ │ └─417 /sbin/multipathd -d -s
│ ├─ModemManager.service 
│ │ └─665 /usr/sbin/ModemManager
│ ├─systemd-journald.service 
│ │ └─374 /lib/systemd/systemd-journald
│ ├─unattended-upgrades.service 
│ │ └─659 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-sh…
│ ├─ssh.service 
│ │ └─660 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
│ ├─snapd.service 
│ │ └─614 /usr/lib/snapd/snapd
│ ├─rsyslog.service 
│ │ └─658 /usr/sbin/rsyslogd -n -iNONE
│ ├─systemd-resolved.service 
│ │ └─590 /lib/systemd/systemd-resolved
│ ├─udisks2.service 
│ │ └─618 /usr/libexec/udisks2/udisksd
│ ├─dbus.service 
│ │ └─604 @dbus-daemon --system --address=systemd: --nofork --nopidfile --syste…
│ ├─systemd-timesyncd.service 
│ │ └─580 /lib/systemd/systemd-timesyncd
│ ├─system-getty.slice 
│ │ └─getty@tty1.service 
│ │   └─630 /sbin/agetty -o -p -- \u --noclear tty1 linux
│ └─systemd-logind.service 
│   └─616 /lib/systemd/systemd-logind
└─test01 
  └─907 /bin/bash
```


## メモリ

systemd-cgls <resource_controller>

```
root@cgroup-test:/home/ubuntu# systemd-cgls memory
Control group /:
├─user.slice 
│ └─user-1000.slice 
│   ├─user@1000.service …
│   │ └─init.scope 
│   │   ├─803 /lib/systemd/systemd --user
│   │   └─804 (sd-pam)
│   ├─session-3.scope 
│   │ ├─ 996 sshd: ubuntu [priv]
│   │ ├─1056 sshd: ubuntu@pts/2
│   │ ├─1057 -bash
│   │ ├─1066 sudo -s
│   │ ├─1067 sudo -s
│   │ ├─1068 /bin/bash
│   │ ├─1189 systemd-cgls memory
│   │ └─1190 less
```

## systemctl status

```
 oot@cgroup-test:/home/ubuntu# systemctl status
● cgroup-test
    State: running
     Jobs: 0 queued
   Failed: 0 units
    Since: Tue 2024-11-19 21:37:02 UTC; 1h 7min ago
   CGroup: /
           ├─user.slice 
           │ └─user-1000.slice 
           │   ├─user@1000.service …
           │   │ └─init.scope 
           │   │   ├─803 /lib/systemd/systemd --user
           │   │   └─804 (sd-pam)
           │   ├─session-3.scope 
           │   │ ├─ 996 sshd: ubuntu [priv]
           │   │ ├─1056 sshd: ubuntu@pts/2
           │   │ ├─1057 -bash
           │   │ ├─1066 sudo -s
           │   │ ├─1067 sudo -s
           │   │ ├─1068 /bin/bash
           │   │ ├─1204 systemctl status
           │   │ └─1205 less
           │   └─session-1.scope 
           │     ├─742 sshd: ubuntu [priv]
           │     ├─887 sshd: ubuntu@pts/0
           │     ├─888 -bash
           │     ├─900 sudo -s
           │     └─906 sudo -s
           ├─init.scope 
           │ └─1 /sbin/init
           ├─system.slice 
           │ ├─systemd-networkd.service 
           │ │ └─588 /lib/systemd/systemd-networkd
           │ ├─systemd-udevd.service 
           │ │ └─419 /lib/systemd/systemd-udevd
           │ ├─cron.service 
           │ │ └─601 /usr/sbin/cron -f -P
           │ ├─system-serial\x2dgetty.slice 
           │ │ └─serial-getty@ttyS0.service 
           │ │   └─624 /sbin/agetty -o -p -- \u --keep-baud 115200,57600,38400,9600 ttyS0 vt220
           │ ├─polkit.service 
           │ │ └─610 /usr/libexec/polkitd --no-debug
           │ ├─networkd-dispatcher.service 
           │ │ └─609 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
           │ ├─multipathd.service 
           │ │ └─417 /sbin/multipathd -d -s
           │ ├─ModemManager.service 
           │ │ └─665 /usr/sbin/ModemManager
           │ ├─systemd-journald.service 
           │ │ └─374 /lib/systemd/systemd-journald
           │ ├─unattended-upgrades.service 
           │ │ └─659 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
           │ ├─ssh.service 
           │ │ └─660 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
           │ ├─snapd.service 
           │ │ └─614 /usr/lib/snapd/snapd
           │ ├─rsyslog.service 
           │ │ └─658 /usr/sbin/rsyslogd -n -iNONE
           │ ├─systemd-resolved.service 
           │ │ └─590 /lib/systemd/systemd-resolved
           │ ├─udisks2.service 
           │ │ └─618 /usr/libexec/udisks2/udisksd
           │ ├─dbus.service 
           │ │ └─604 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
           │ ├─systemd-timesyncd.service 
           │ │ └─580 /lib/systemd/systemd-timesyncd
           │ ├─system-getty.slice 
           │ │ └─getty@tty1.service 
           │ │   └─630 /sbin/agetty -o -p -- \u --noclear tty1 linux
           │ └─systemd-logind.service 
           │   └─616 /lib/systemd/systemd-logind
           └─test01 
             └─907 /bin/bash
```

## systemd status <service>

```
root@cgroup-test:/home/ubuntu# systemctl status systemd-networkd.service 
● systemd-networkd.service - Network Configuration
     Loaded: loaded (/lib/systemd/system/systemd-networkd.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2024-11-19 21:37:13 UTC; 1h 8min ago
TriggeredBy: ● systemd-networkd.socket
       Docs: man:systemd-networkd.service(8)
   Main PID: 588 (systemd-network)
     Status: "Processing requests..."
      Tasks: 1 (limit: 4559)
     Memory: 2.6M
        CPU: 120ms
     CGroup: /system.slice/systemd-networkd.service
             └─588 /lib/systemd/systemd-networkd

Nov 19 21:37:13 cgroup-test systemd[1]: Starting Network Configuration...
Nov 19 21:37:13 cgroup-test systemd-networkd[588]: lo: Link UP
Nov 19 21:37:13 cgroup-test systemd-networkd[588]: lo: Gained carrier
Nov 19 21:37:13 cgroup-test systemd-networkd[588]: Enumeration completed
Nov 19 21:37:13 cgroup-test systemd[1]: Started Network Configuration.
Nov 19 21:37:13 cgroup-test systemd-networkd[588]: enp6s0: Link UP
Nov 19 21:37:13 cgroup-test systemd-networkd[588]: enp6s0: Gained carrier
Nov 19 21:37:15 cgroup-test systemd-networkd[588]: enp6s0: Gained IPv6LL
```

