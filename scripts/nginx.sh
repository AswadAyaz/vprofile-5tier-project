#!/bin/bash

apt update -y

apt upgrade -y

apt install nginx -y

cat <<EOT > vproapp
upstream vproapp {
	
  server app01:8080;
}

server {

 listen 80;
 
 location / {
	
   proxy_pass http://vproapp;

}

}

EOT

mv vproapp /etc/nginx/sites-available/vproapp

sudo rm -rf /etc/nginx/sites-enabled/default

ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx
