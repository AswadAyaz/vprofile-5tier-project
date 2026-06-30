#!/bin/bash


dnf update -y

dnf install memcached -y

sudo systemctl enable memcached

sudo systemctl start memcached

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

sudo ss -tulnp | grep 11211

sudo fuser -k 11211/tcp 2>/dev/null

sudo systemctl restart memcached

firewall-cmd --add-port=11211/tcp --permanent

firewall-cmd --reload

sudo ss -tulnp | grep 11211

sudo fuser -k 11211/tcp 2>/dev/null

systemctl restart memcached

sudo memcached -p 11211 -U 11111 -u memcached -d

