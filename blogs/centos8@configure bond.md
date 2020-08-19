

# configure network bond using nmcli

## 1. create bond interface

```sh
# nmcli connection add type bond con-name <bondname> ifname <bondname> bond.options "mode=active-backup"
nmcli connection add type bond con-name bond0 ifname bond0 bond.options "mode=active-backup"
# use options: nmcli connection add type bond con-name bond0 ifname bond0 bond.options "mode=active-backup,miimon=1000"
```

## 2. assign slave interface to bond

```sh
nmcli connection add type ethernet slave-type bond con-name bond0-port1 ifname enp7s0 master bond0
nmcli connection add type ethernet slave-type bond con-name bond0-port2 ifname enp8s0 master bond0
```

## 3. ip settings for bond 

```sh
nmcli connection modify bond0 ipv4.addresses '192.0.2.1/24'
nmcli connection modify bond0 ipv4.gateway '192.0.2.254'
nmcli connection modify bond0 ipv4.dns '192.0.2.253'
nmcli connection modify bond0 ipv4.dns-search 'example.com'
nmcli connection modify bond0 ipv4.method manual
nmcli connection up bond0
```

## 4. active bond
```sh
nmcli connection up bond0

```

## concpets
- activates master and slave devices when the system boots.
- By activating any slave connection, the master is also activated.
- By default, activating the master does not automatically activate the slaves. However, you can set __connection.autoconnect-slaves__ for bond to auto active slave.

## other: verification
```sh
nmcli device
nmcli device status
cat /proc/net/bonding/bond0
```

## Media Independent Interface (MII)
1. miimon
2. 设置监控间隔 1000 milliseconds 1 second

## command 
```sh
# auto acitve slave when aciting master
nmcli connection modify bond0 connection.autoconnect-slaves 1
nmcli connection up bond0
```

