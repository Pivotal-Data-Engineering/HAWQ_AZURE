#!/bin/sh

userName=$1

sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
#sed -i '/Defaults[[:space:]]\+!*requiretty/s/^/#/' /etc/sudoers

sudo su -c "echo 0 > /selinux/enforce"
sudo su -c "sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

#sudo su -c 'echo "yoda   ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

sudo su -c "mkdir -p ~/.ssh"
sudo su -c "ssh-keygen -f ~/.ssh/id_rsa1 -t rsa -N "'""'" "
sudo su -c "chmod 700 ~/.ssh"
sudo su -c "chmod 600 ~/.ssh/authorized_keys"

