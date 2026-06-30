#!/bin/bash

DATABASE_PASS='admin123'
SERVER='mariadb-server'
GIT_PATH='https://github.com/AswadAyaz/vprofile-project.git'


dnf update -y

dnf install git zip unzip -y

dnf install $SERVER -y

sudo systemctl start mariadb

sudo systemctl enable mariadb

cd /tmp/

git clone -b local $GIT_PATH

sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

sudo systemctl restart mariadb

sudo systemctl start firewalld
sudo systemctl enable firewalld

sudo firewall-cmd --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo systemctl restart mariadb
