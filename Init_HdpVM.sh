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

#installl and enable ntp
yum install -y ntp
chkconfig ntpd on
service ntpd start

# setup umask for HDP and Ambari
echo 'umask 0022' >> /etc/profile

echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
service sshd restart

mkdir -p /root/.ssh
cp /home/$ADMINUSER/.ssh/authorized_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh

./vm-disk-utils-centos.sh -s


