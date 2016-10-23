#!/bin/sh
sed -i "s/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g" /etc/sudoers
echo "$ADMINUSER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo su -c "echo 0 > /selinux/enforce"
sudo su -c "sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
sudo su -c "yum install -y ntp"
sudo su -c "service ntp start"
sudo su -c "chkconfig ntp on"
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"
mkdir -p /home/$ADMINUSER/.ssh
ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ''
chmod 700 /home/$ADMINUSER/.ssh
chmod 600 /home/$ADMINUSER/.ssh/authorized_keys