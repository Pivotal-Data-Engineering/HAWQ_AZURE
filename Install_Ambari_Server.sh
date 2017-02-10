#!/bin/sh
AMB_VERSION=$1

echo "Downloading Ambari repo version $AMB_VERSION....."
sudo su -c " wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/$AMB_VERSION/ambari.repo -O /etc/yum.repos.d/ambari.repo "
#wget -nv http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.4.2.0/ambari.repo -O /etc/yum.repos.d/ambari.repo
echo "installing ambari server ...."
sudo su -c " yum install -y ambari-server "
sleep 10
echo "running ambari setup with defaults....."
sudo su -c " ambari-server setup -s "
sleep 20
echo "starting Ambari ...."
sudo su -c " ambari-server start "
