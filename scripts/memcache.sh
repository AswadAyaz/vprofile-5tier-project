#!/bin/bash


dnf update -y

dnf install memcached -y

sudo systemctl enable memcached

sudo systemctl start memcached

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

sudo systemctl restart memcached

firewall-cmd --add-port=11211/tcp --permanent

firewall-cmd --reload

systemctl restart memcached

sudo memcached -p 11211 -U 11111 -u memcached -d

