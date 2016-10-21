#!/bin/sh
sed -i "s/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g" /etc/sudoers
sudo su -c "echo 0 > /selinux/enforce"
sudo su -c "sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux"
sudo su -c "service iptables stop"
sudo su -c "chkconfig iptables off"
sudo su -c "chkconfig ip6tables off"
sudo su -c "yum install -y ntp"
sudo su -c "service ntp start"
sudo su -c "chkconfig ntp on"

