#!/bin/sh
ADMINUSER=$1

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
service sshd restart
chkconfig sshd on

sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "disable selinux"

sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
setenforce 0

#disable iptables
service iptables stop
chkconfig iptables off

#Disable  Transparent Huge Pages 
echo "if test -f /sys/kernel/mm/transparent_hugepage/enabled; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled fi if test -f /sys/kernel/mm/transparent_hugepage/defrag; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag fi" >> /etc/rc.local

echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/defrag

#installl and enable ntp
yum install -y ntp
chkconfig ntpd on
service ntpd start

# setup umask for HDP and Ambari
echo 'umask 0022' >> /etc/profile

mkdir -p /root/.ssh
cp /home/$ADMINUSER/.ssh/authorized_keys /root/.ssh/authorized_keys
chmod 640 /root/.ssh/authorized_keys
chmod 700 /root/.ssh

echo "Peparing Disks.... "
chmod ugo+rx vm-disk-utils-centos.sh

sh vm-disk-utils-centos.sh

echo "setting ambari repo......"
wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/
echo "install ambari agent....."
yum install -y ambari-agent
echo "setup the ambari server name in /etc/ambari-agent/conf/ambari-agent.ini"
sed -i 's/hostname=localhost/hostname=edgenode.hawqdatalake.com/g' /etc/ambari-agent/conf/ambari-agent.ini

echo "installing epel repo...."
yum install -y epel-release
