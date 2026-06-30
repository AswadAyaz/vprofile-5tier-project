#!/bin/bash

dnf update -y

dnf install wget tee -y

cd /tmp/

dnf -y install centos-release-rabbitmq-38

dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

sudo systemctl enable --now rabbitmq-server

firewall-cmd --add-port=5672/tcp --permanent

firewall-cmd --reload

sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server

echo "loopback_users.guest = false" | sudo tee /etc/rabbitmq/rabbitmq.conf

mv /etc/rabbitmq/rabbitmq.config /etc/rabbitmq/rabbitmq.config.bak

sudo rabbitmqctl add_user test test 

sudo rabbitmqctl set_user_tags test administrator

rabbitmqctl set_permissions -p / test ".*" ".*" ".*"

sudo systemctl restart rabbitmq-server
