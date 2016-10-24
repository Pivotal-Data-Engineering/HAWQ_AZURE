#!/bin/sh
sed -i 's/Defaults\s\{1,\}requiretty/Defaults \!requiretty/g' /etc/sudoers
sudo echo "eviCore    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
sudo echo 0 > /selinux/enforce
sudo sed -i -e 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo service iptables stop
sudo chkconfig iptables off
sudo chkconfig ip6tables off

#sudo su -c "{ echo -n '`hostname -I`     '; echo -n '`hostname -f`     '; echo `hostname`; } >> /etc/hosts"

sudo mkdir -p /root/.ssh
sudo cp /home/.ssh/authorized_keys /root/.ssh/authorized_keys
sudo 600 /root/.ssh/authorized_keys
sudo 700 /root/.ssh

sudo yum install -y ntp
sudo chkconfig ntpd on

sudo echo 'umask 0022' >> /etc/profile