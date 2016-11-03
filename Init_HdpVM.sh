#!/bin/sh
ADMINUSER=$1

sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

#disable selinux
echo 0 > /selinux/enforce
sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux

#disable iptables
service iptables stop
chkconfig iptables off
chkconfig ip6tables off

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

chkconfig sshd on

# setup umask for HDP and Ambari
echo 'umask 0022' >> /etc/profile

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
service sshd restart

mkdir -p /root/.ssh
cp /home/$ADMINUSER/.ssh/authorized_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh

echo "Peparing Disks.... "
chmod ugo+rx vm-disk-utils-centos.sh

sh vm-disk-utils-centos.sh -s

echo "setting ambari repo......"
wget http://public-repo-1.hortonworks.com/ambari/centos6/2.x/updates/2.2.2.0/ambari.repo -P /etc/yum.repos.d/
echo "install ambari agent....."
yum install -y ambari-agent
echo "setup the ambari server name in /etc/ambari-agent/conf/ambari-agent.ini"
sed -i 's/hostname=localhost/hostname=hawqdatalake-clientvm/g' /etc/ambari-agent/conf/ambari-agent.ini
