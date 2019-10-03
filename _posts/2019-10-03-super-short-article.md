---
layout: post
title: "nexus proxy quay.io & k8s.gcr.io"
categories: misc
---

```sh
mkdir -p /cert/quay.io /cert/k8s.gcr.io

openssl req -newkey rsa:4096 -nodes -sha256 -keyout /cert/quay.io/domain.key -x509 -days 3650 -out /cert/quay.io/domain.crt -subj "/CN=quay.io"
openssl req -newkey rsa:4096 -nodes -sha256 -keyout /cert/k8s.gcr.io/domain.key -x509 -days 3650 -out /cert/k8s.gcr.io/domain.crt -subj '/CN=k8s.gcr.io'
```

```nginx
worker_processes  1;
events { worker_connections  1024; }

http {
  server {
    listen       443 ssl;
    server_name  quay.io;

    ssl_certificate       /cert/quay.io/domain.crt;
    ssl_certificate_key   /cert/quay.io/domain.key;

    location / {
	proxy_pass http://127.0.0.1:9001;
    }
  }
  server {
    listen       443 ssl;
    server_name  k8s.gcr.io;

    ssl_certificate       /cert/k8s.gcr.io/domain.crt;
    ssl_certificate_key   /cert/k8s.gcr.io/domain.key;

    location / {
      proxy_pass http://127.0.0.1:9002;
    }
  }
}
```
```sh
docker run -d --net host -v `pwd`/nginx.conf:/etc/nginx/nginx.conf:ro -v `pwd`:/cert --name nginx nginx 
docker run -d --net host --name nexus sonatype/nexus3
```

