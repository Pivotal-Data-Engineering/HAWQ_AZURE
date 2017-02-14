#!/bin/sh
ADMINUSER=$1
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "disable selinux"
setenforce 0
sed -i -e 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

echo "setting IP Table rules......."
service iptables stop
chkconfig iptables off
chkconfig ip6tables off
chkconfig iptables --del
chkconfig ip6tables --del

echo "Installing ntp ....."
yum install -y ntp
chkconfig ntpd on
service ntpd start

echo 'umask 0022' >> /etc/profile

echo "Disable  Transparent Huge Pages ........."
 
echo "if test -f /sys/kernel/mm/transparent_hugepage/enabled; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled fi" >> /etc/rc.local
echo "if test -f /sys/kernel/mm/transparent_hugepage/defrag; then echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag fi" >> /etc/rc.local

echo never > /sys/kernel/mm/redhat_transparent_hugepage/enabled
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo never > /sys/kernel/mm/redhat_transparent_hugepage/defrag
echo never > /sys/kernel/mm/transparent_hugepage/defrag

echo "setting nohost check for ssh ..."
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
service sshd restart

echo "install httpd ........."
yum -y install httpd
echo "starting httpd..."
service httpd start

echo "installing epel repo...."
yum install -y epel-release

echo "Finished executing the initAmbariVM."











