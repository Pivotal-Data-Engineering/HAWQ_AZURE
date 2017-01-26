#!/bin/sh
AMB_VERSION=$1

echo "Downloading Ambari repo version $AMB_VERSION....."
sudo su -c " wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/$AMB_VERSION/ambari.repo -P /etc/yum.repos.d/ "
echo "installing ambari server ...."
sudo su -c " yum install -y ambari-server "
sleep 10
echo "running ambari setup with defaults....."
sudo su -c " ambari-server setup -s "

echo "starting Ambari ...."
sudo su -c " ambari-server start "


