#!/bin/bash

TOMURL="https://archive.apache.org/dist/tomcat/tomcat-10/v10.1.26/bin/apache-tomcat-10.1.26.tar.gz"

dnf -y install java-17-openjdk java-17-openjdk-devel

dnf install git wget zip unzip -y

cd /tmp/

wget $TOMURL -O tomcatbin.tar.gz

EXTOUT=`tar xzvf tomcatbin.tar.gz`

TOMDIR=`echo $EXTOUT | cut -d '/' -f1`

sudo useradd --shell /sbin/nologin tomcat

rsync -avzh /tmp/$TOMDIR /usr/local/tomcat/

sudo chown -R tomcat:tomcat /usr/local/tomcat

sudo rm -rf /etc/systemd/system/tomcat.service

cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat/apache-tomcat-10.1.26

Environment=JAVA_HOME=/usr/lib/jvm/java-17-openjdk

Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat/apache-tomcat-10.1.26
Environment=CATALINE_BASE=/usr/local/tomcat/apache-tomcat-10.1.26

ExecStart=/usr/local/tomcat/apache-tomcat-10.1.26/bin/startup.sh
ExecStop=/usr/local/tomcat/apache-tomcat-10.1.26/bin/shutdown.sh


RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOT

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

cd /tmp/

wget https://archive.apache.org/dist/maven/maven-3/3.9.9/binaries/apache-maven-3.9.9-bin.zip

unzip apache-maven-3.9.9-bin.zip

cp -r apache-maven-3.9.9 /usr/local/maven3.9
export MAVEN_OPTS="-Xmx512m"

git clone -b local https://github.com/AswadAyaz/vprofile-project.git

cd vprofile-project

/usr/local/maven3.9/bin/mvn install

sudo systemctl stop tomcat

sleep 20

sudo rm -rf /usr/local/tomcat/apache-tomcat-10.1.26/webapps/ROOT*

cp target/vprofile-v2.war /usr/local/tomcat/apache-tomcat-10.1.26/webapps/ROOT.war

sudo systemctl start tomcat
sleep 20
sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo systemctl restart tomcat
