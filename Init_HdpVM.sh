#!/bin/sh
ADMINUSER=$1
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo 0 > /selinux/enforce
sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux
service iptables stop
chkconfig iptables off
chkconfig ip6tables off

#sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"{

mkdir -p /root/.ssh
cp /home/$username/.ssh/authorized_keys /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
chmod 700 /root/.ssh

yum install -y ntp
chkconfig ntpd on

echo 'umask 0022' >> /etc/profile