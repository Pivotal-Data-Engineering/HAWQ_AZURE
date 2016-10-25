#!/bin/sh
ADMINUSER=$1
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo 0 > /selinux/enforce
sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux
service iptables stop
chkconfig iptables off
chkconfig ip6tables off
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

yum install -y ntp
chkconfig ntpd on

echo 'umask 0022' >> /etc/profile

wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/
yum install -y ambari-server
ambari-server setup -s
ambari-server start












