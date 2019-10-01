# env

- host1: 192.168.72.128 centos 7
- host2: 192.168.72.129 centos 7

### 关闭防火墙 ( host1 host2)
```sh
systemctl stop firewalld
# or
firewall-cmd --permanent --add-port=4789/udp
firewall-cmd --reload
```

### 设置 host1 (192.168.72.128)
```sh
ip link add vxlan0 type vxlan id 1 remote 192.168.72.129 dstport 4789 dev ens33
ip addr add 10.20.1.2/24 dev vxlan0
ip link set vxlan0 up
```

### 设置 host2 (192.168.72.129)
```sh
ip link add vxlan0 type vxlan id 1 remote 192.168.72.128 dstport 4789 dev ens33
ip addr add 10.20.1.3/24 dev vxlan0
ip link set vxlan0 up
```
ip link add vxlan0 type vxlan id 1 remote 192.168.72.128 dstport 4789 dev ens33

- 启动 vxlan0
ip link set vxlan0 up

- 给vxlan0 添加地址
ip addr add 10.20.1.3/24 dev vxlan0
ip link set vxlan0 up

- 查看路由表
```sh
[root@localhost ~]# ip route
default via 192.168.72.2 dev ens33 proto dhcp metric 100
10.20.1.0/24 dev vxlan0 proto kernel scope link src 10.20.1.2
192.168.72.0/24 dev ens33 proto kernel scope link src 192.168.72.128 metric 100
```

ip route
ip -d link show dev vxlan0
ip link delete vxlan0
bridge fdb


```sh
ip link add vxlan1 type vxlan \
    id 42 \
    dstport 4788 \
    group 239.1.1.1 \
    dev ens33
ip addr add 10.20.1.20/24 dev vxlan1
ip link set vxlan1 up

ip link add vxlan0 type vxlan \
    id 42 \
    dstport 4789 \
    group 239.1.1.1 \
    local 192.168.8.100 \
    dev enp0s8 

ip link add br0 type bridge
ip link set vxlan100 master bridge
ip link set vxlan100 up
ip link set br0 up
```
