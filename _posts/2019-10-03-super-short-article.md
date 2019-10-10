---
layout: post
title: "nexus proxy quay.io & k8s.gcr.io"
categories: misc
---

```sh
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -days 9999 -out ca.pem -subj '/CN=shinhwagk'

openssl genrsa -out nexus-quay.key 2048
openssl req -new -key nexus-quay.key -out nexus-quay.csr -subj '/CN=quay.io'
openssl x509 -req -days 9999 -CA ca.pem -CAkey ca.key -CAcreateserial -in nexus-quay.csr -out nexus-quay.pem 

openssl genrsa -out nexus-gcr.key 2048
openssl req -new -key nexus-gcr.key -out nexus-gcr.csr -subj '/CN=gcr.io'
openssl x509 -req -days 9999 -CA ca.pem -CAkey ca.key -CAcreateserial -in nexus-gcr.csr -out nexus-gcr.pem

openssl genrsa -out nexus-gk.key 2048
openssl req -new -key nexus-gk.key -out nexus-gcr.csr -subj '/CN=gk.io'
openssl x509 -req -days 9999 -CA ca.pem -CAkey ca.key -CAcreateserial -in nexus-gcr.csr -out nexus-gk.pem 

openssl genrsa -out nexus-elastic.key 2048
openssl req -new -key nexus-elastic.key -out nexus-gcr.csr -subj '/CN=docker.elastic.co'
openssl x509 -req -days 9999 -CA ca.pem -CAkey ca.key -CAcreateserial -in nexus-gcr.csr -out nexus-elastic.pem 
```

```nginx
worker_processes 1;
events {
    worker_connections 1024;
}
http {
    server {
        listen 443 ssl;
        server_name quay.io;
        ssl_certificate /cert/nexus-quay.pem;
        ssl_certificate_key /cert/nexus-quay.key;
        location / {
            proxy_pass http://nexus:9001;
        }
    }
    server {
        listen 443 ssl;
        server_name gcr.io;
        ssl_certificate /cert/nexus-gcr.pem;
        ssl_certificate_key /cert/nexus-gcr.key;
        location / {
            proxy_pass http://nexus:9002;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto "https";
        }
    }
    server {
        listen 443 ssl;
        server_name gk.io;
        client_max_body_size 1G; # 用于私有仓库所以增大client发送过来的body大小
        ssl_certificate /cert/nexus-gk.pem;
        ssl_certificate_key /cert/nexus-gk.key;
        location / {
            proxy_pass http://nexus:9003;
        }
    }
    server {
        listen 443 ssl;
        server_name docker.elastic.co;
        ssl_certificate /cert/nexus-elastic.pem;
        ssl_certificate_key /cert/nexus-elastic.key;
        location / {
            proxy_pass http://nexus:9004;
        }
    }
}
```

```sh
docker volume create nexus-data
docker volume create nginx

docker rm -f nginx
docker rm -f nexus
docker run -d -p 8081:8081 -p 9004:9004 -p 9003:9003 -p 9002:9002 -p 9001:9001 --name nexus -v nexus-data:/nexus-data sonatype/nexus3
docker run -d -p 443:443 --link nexus:nexus -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro -v nginx:/cert --name nginx nginx 
```
