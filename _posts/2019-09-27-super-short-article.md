# display k8s svc
```
[root@cp1 opt]# kubectl get svc
NAME             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                           AGE
gitlab           NodePort    10.107.12.34     <none>        80:30080/TCP,22:30022/TCP         23d

[root@cp1 opt]# kubectl get pod
NAME                              READY   STATUS             RESTARTS   AGE
gitlab-7b4657f9d9-d89x6           1/1     Running            0          23d

[root@cp1 opt]# kubectl describe pod gitlab-7b4657f9d9-d89x6
IP:             10.32.0.6
```

# iptables svc 
```
[root@cp1 opt]# iptables -L -n -t nat
Chain KUBE-SERVICES (2 references)
target     prot opt source               destination
    0     0 KUBE-SVC-5QWMUZGI6RE4EX4J  tcp  --  *      *       0.0.0.0/0            10.107.12.34         /* default/gitlab:gitlab-ui cluster IP */ tcp dpt:80
    0     0 KUBE-SVC-7GIV3D4MIXKARDDM  tcp  --  *      *       0.0.0.0/0            10.107.12.34         /* default/gitlab:gitlab-ssh cluster IP */ tcp dpt:22
``

# iptables svc
```
[root@cp1 opt]# iptables -L KUBE-SVC-5QWMUZGI6RE4EX4J  -t nat -n
Chain KUBE-SVC-5QWMUZGI6RE4EX4J (2 references)
target     prot opt source               destination
KUBE-SEP-4PI4NMBMAFCHTS42  all  --  0.0.0.0/0            0.0.0.0/0
```
```
[root@cp1 opt]# iptables -L KUBE-SVC-7GIV3D4MIXKARDDM -t nat -n
Chain KUBE-SVC-7GIV3D4MIXKARDDM (2 references)
target     prot opt source               destination
KUBE-SEP-CMB2BXLXSDKPPOWF  all  --  0.0.0.0/0            0.0.0.0/0
```

# iptables pod 
```
[root@cp1 opt]# iptables -L KUBE-SEP-4PI4NMBMAFCHTS42 -t nat -n
Chain KUBE-SEP-4PI4NMBMAFCHTS42 (1 references)
target     prot opt source               destination
KUBE-MARK-MASQ  all  --  10.32.0.6            0.0.0.0/0
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp to:10.32.0.6:30080
```
```
[root@cp1 opt]# iptables -L KUBE-SEP-CMB2BXLXSDKPPOWF  -t nat -n
Chain KUBE-SEP-CMB2BXLXSDKPPOWF (1 references)
target     prot opt source               destination
KUBE-MARK-MASQ  all  --  10.32.0.6            0.0.0.0/0
DNAT       tcp  --  0.0.0.0/0            0.0.0.0/0            tcp to:10.32.0.6:22
```

# iptables
```
[root@cp1 opt]# iptables -L KUBE-MARK-MASQ -t nat -n
Chain KUBE-MARK-MASQ (21 references)
target     prot opt source               destination
MARK       all  --  0.0.0.0/0            0.0.0.0/0            MARK or 0x4000
```
