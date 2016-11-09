#!/bin/sh
ADMINUSER=$1
HDB_VERSION=$2
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "disable selinux"
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

service iptables stop
chkconfig iptables off
chkconfig ip6tables off
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

yum install -y ntp
chkconfig ntpd on
service ntpd start

echo 'umask 0022' >> /etc/profile

#Disable  Transparent Huge Pages 
echo "if test -f /sys/kernel/mm/transparent_hugepage/enabled; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled fi if test -f /sys/kernel/mm/transparent_hugepage/defrag; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag fi" >> /etc/rc.local
echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/defrag

echo "Downloading Ambari repo....."
wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/
echo "installing ambari server ...."
yum install -y ambari-server
echo "running ambari setup with defaults....."
ambari-server setup -s
echo "starting Ambari ...."
ambari-server start

echo "setting nohost check for ssh ..."
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
service sshd restart

echo "Finished executing the initAmbariVM."











