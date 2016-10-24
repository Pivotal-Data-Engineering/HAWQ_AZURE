#!/bin/sh
userName=$1
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
sudo echo "eviCore    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo echo 0 > /selinux/enforce
sudo sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo service iptables stop
sudo chkconfig iptables off
sudo chkconfig ip6tables off
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

sudo yum install -y ntp
sudo chkconfig ntpd on

sudo echo 'umask 0022' >> /etc/profile

sudo wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/
sudo yum install -y ambari-server
sudo ambari-server setup -s
sudo ambari-server start












